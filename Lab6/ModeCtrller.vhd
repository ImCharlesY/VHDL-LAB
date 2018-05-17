 library ieee;
 use ieee.std_logic_1164.all;
 use ieee.std_logic_unsigned.all;
 
 entity ModeCtrller is
 port(
	clk: in std_logic;
	rst:in std_logic;
	
	modekey: in std_logic;
	
	mode: out integer
 );
 end entity;
 
 architecture behavior of ModeCtrller is
 
 -----------------------Declare Components---------------------------
 component CycleSampler is 
 port(
	clk: in std_logic;
	btnstate: in std_logic;
	keystate: out std_logic
	);
 end component CycleSampler;
 ---------------------End Components Declaration------------------------
 
 ----------------------Signal Declaration-------------------
 signal modekey_state: std_logic;
 signal modekey_state_ls: std_logic;
 signal mode_cache: integer;
 ---------------------End Signal Declaration-----------------
 
 begin
	MK:CycleSampler PORT MAP (clk,modekey,modekey_state);
	
	process(clk)
	begin
		if (rising_edge(clk)) then
			modekey_state_ls<=modekey_state;
		end if;
	end process;
	
	process(clk,rst)
	begin
		if (rst='0') then
			mode_cache<=0;
		elsif (rising_edge(clk)) then
			if (modekey_state_ls='1' and modekey_state='0') then
				if (mode_cache=1) then
					mode_cache<=0;
				else
					mode_cache<=1;
				end if;
			end if;
		end if;
	end process;
	mode<=mode_cache;
 
 end behavior;