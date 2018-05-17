 library ieee;                    
 use  ieee.std_logic_1164.all;     
 use  ieee.std_logic_unsigned.all; 
 
 
 entity BeepCtrller is
	port(
		clk:in std_logic;	--12MHz clock
		en:in std_logic;
		beep:out std_logic
	);
 end BeepCtrller;
 
 
 architecture behavior of BeepCtrller is
-----------------------Signals Declaration-------------------
signal div_clk:std_logic;
signal div_clk_cnt:integer;
signal div_clk_ls:std_logic;
signal tune_change_cnt:integer;
signal pwm_out:std_logic;
signal pwm_cnt:integer;
signal cycle:integer;
signal tune:integer;

type intarr is array(natural range <>) of integer;
constant freq:intarr(1 to 16):=(
	523,587,659,698,784,880,988,1046,1175,1318,1397,1568,1750,1967,2093,2349
);
---------------------End Signals Declaration-----------------	

 begin
	
	process(clk)	--generate 1MHz Clock
	begin 
		if(rising_edge(clk)) then
			div_clk_cnt<=div_clk_cnt+1;
			if(div_clk_cnt=6) then
				div_clk<=not div_clk;
				div_clk_cnt<=0;
			end if;
		end if;
	end process;
	
	process(clk)	--record last state
	begin 
		if(rising_edge(clk)) then
			div_clk_ls<=div_clk;
		end if;
	end process;
	
	process(clk)
	begin
		if(rising_edge(clk)) then
			tune_change_cnt<=tune_change_cnt+1;
			if(tune_change_cnt>=6000000) then
				tune_change_cnt<=0;
				if(tune=6) then
					tune<=1;
				else
					tune<=6;
				end if;
			end if;
			--tune<=3;
		end if;
	end process;
	
	process(tune)	--set cycle
	begin 
		if(tune>0 and tune<17) then
			cycle<=500000/freq(tune);
		else
			cycle<=500000;
		end if;
	end process;

	process(clk)	--generate pwm
	begin 
		if(rising_edge(clk)) then
			if(div_clk_ls='1' and div_clk='0') then
				if(cycle=500000) then
					pwm_out<='0';
				else
					pwm_cnt<=pwm_cnt+1;
					if(pwm_cnt>=cycle) then
						pwm_out<= not pwm_out;
						pwm_cnt<=0;
					end if;
				end if;
			end if;
		end if;
	end process;
	
	process(en)
	begin
		if (en='1') then
			beep<=pwm_out;
		else 
			beep<='0';
		end if;
	end process;
	
 end behavior;