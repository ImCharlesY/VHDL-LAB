 library ieee;                    
 use  ieee.std_logic_1164.all;     
 use  ieee.std_logic_unsigned.all; 
 
 entity RotaryEncoder is
	port(
		clk:in std_logic;	--12MHz clock
		PortA:in std_logic;	--A
		PortB:in std_logic;	--B
		
		act:out integer		--scan result: 0-no action; 1-clockwise; -1-anti-clockwise
	);
 end RotaryEncoder;
 
 architecture behavior of RotaryEncoder is
 -----------------------Signals Declaration-------------------
 signal PA_ls:std_logic;	 --last state of PortA
 signal act_cache:integer;	 --cache action
 signal int_times:std_logic; --deal with falling edge of PA when 0, deal with rising when 1
 signal act_cache_tmp:std_logic;	--judge action at falling edge of PA
 ---------------------End Signals Declaration-----------------	
 
 begin
 
 --scan PA, record last state
 process(clk)
 begin
	if(rising_edge(clk)) then 
		PA_ls<=PortA;
	end if;
 end process;
 
 process(clk)
 begin
	if(rising_edge(clk)) then
		if(int_times='0' and PA_ls='1' and PortA='0') then --if PortA falling
			if(PortB='1') then	--if PortB high
				act_cache_tmp<='1';		--judge as clockwise
			else				--else PortB low
				act_cache_tmp<='0';		--judge as anti-clockwise
			end if;
			int_times<='1';
		elsif(int_times='1' and PA_ls='0' and PortA='1') then   --else PortA rising
			if(PortB='1' and act_cache_tmp='0') then	        --if PortB high, judge as anti, and if it is also anti at PA falling
				act_cache<=-1;									--confirm as anti
			elsif(PortB='0' and act_cache_tmp='1') then			--else PortB low, judge as clockwise, and if it is also clockwise at PA falling
				act_cache<=1;									--confirm as clockwise
			else
				act_cache<=0;
			end if;
			int_times<='0';
		else
			act_cache<=0;
		end if;
	end if;
 end process;
 
 act<=act_cache;
	
 end behavior;