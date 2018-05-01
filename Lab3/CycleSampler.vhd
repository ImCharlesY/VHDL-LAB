 library ieee;                    
 use  ieee.std_logic_1164.all;     
 use  ieee.std_logic_unsigned.all; 
 
 --this entity implements key debounce using cycle sampling method
 
 entity CycleSampler is 
 port(
	clk: in std_logic;
	btnstate: in std_logic;
	keystate: out std_logic
	);
 end CycleSampler;
 
 
 architecture CycleSample of CycleSampler is
 
 signal keysamplerpulsecnt:integer:=0;		--counter
 signal keysamplerpulse:std_logic;	--scan clock pulse for key sampler
 signal keysamplerpulse_ls:std_logic;
 signal keystore:std_logic_vector(2 downto 0);	--store btn state: 0-current,1-previous,2-before last
 
 begin
	------------------------The following implements key debounce------------------------
	----This process divide the 12MHz clock into 240kHz, generating a pulse per 20ms
	process(clk)
	begin
		if (rising_edge(clk)) then
			keysamplerpulsecnt<=keysamplerpulsecnt+1;
			if (keysamplerpulsecnt=120000) then
				keysamplerpulse<=not keysamplerpulse;						
				keysamplerpulsecnt<=0;						--clear cnt
			end if;
		end if;	
	end process;
	
	----This process records last state of sample clk
	process(clk)
	begin
		if (rising_edge(clk)) then
			keysamplerpulse_ls<=keysamplerpulse;
		end if;
	end process;
	
	----This process samples (per 20ms) 3 times
	process(clk)
	begin
		if (rising_edge(clk)) then
			if (keysamplerpulse='1' and keysamplerpulse_ls='0') then
				keystore(2)<=keystore(1);
				keystore(1)<=keystore(0);
				keystore(0)<=not btnstate;
			end if;
			keystate<=keystore(0) and keystore(1) and keystore(2);	
		end if;
	end process;
	-------------------------------End key debounce--------------------------------
	

 end CycleSample;