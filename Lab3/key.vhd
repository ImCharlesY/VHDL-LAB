 library ieee;                    
 use  ieee.std_logic_1164.all;     
 use  ieee.std_logic_unsigned.all; 
 
 --this entity detects 2 separate keys using entity CycelSampler
 
 entity key is 
 port(
 	clk: in std_logic;				--sampling clock
	btnstate: in std_logic_vector (1 downto 0);	--the state of buttons (before sampling)
	keystate: out std_logic_vector (1 downto 0)
 );
 end key;
 
 architecture keySample of key is 
 --declare CycleSampler component
 component CycleSampler
 port(
 	clk: in std_logic;
	btnstate: in std_logic;
	keystate: out std_logic
	);
 end component CycleSampler;
 
 begin
	--instantiate 2 CycleSampler 
	k0: CycleSampler PORT MAP (clk,btnstate(0),keystate(0));
	k1: CycleSampler PORT MAP (clk,btnstate(1),keystate(1));
 
 end keySample;