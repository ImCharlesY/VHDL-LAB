Library IEEE;            
USE  IEEE.std_logic_1164.ALL;     
USE  IEEE.std_logic_unsigned.ALL; 

entity dataTo595_tb is 
end dataTO595_tb;

architecture behav of dataTo595_tb is 
 component DataTo595 
	port(
	clk:in std_logic;		--12MHz clock
	rst:in std_logic;		--the state of reset key(after sampling)
	
	ctrlcode595:in std_logic_vector(95 downto 0);	
	
	din:out std_logic;	--data stream to 595
	sck:out std_logic;	--595 shift clock
	rck:out std_logic	--595 output pulse
	);
 end component DataTo595;
 
 signal clk1: std_logic:='0';	--12MHz clock	
 signal rst1: std_logic:='0';			--the state of reset key
 --signal ctrlcode5951:std_logic_vector(95 downto 0):="111111000111111101100000101111111101101011011111111100101110111101100110111101111011011011111011";
 signal ctrlcode5951:std_logic_vector(95 downto 0):="000000000000000000000000000000000000000000000000000000000000000000000000000000000101010101010101";
 --signal ctrlcode5951:std_logic_vector(95 downto 0):="000000000000000000000000000000000000000000000000000000000000000001010101010101010000000000000000";
 --signal ctrlcode5951:std_logic_vector(95 downto 0):="000000000000000000000000000000000000000000000000010101010101010100000000000000000000000000000000";
 --signal ctrlcode5951:std_logic_vector(95 downto 0):="000000000000000000000000000000000101010101010101000000000000000000000000000000000000000000000000";
 --signal ctrlcode5951:std_logic_vector(95 downto 0):="000000000000000001010101010101010000000000000000000000000000000000000000000000000000000000000000";
 --signal ctrlcode5951:std_logic_vector(95 downto 0):="010101010101010100000000000000000000000000000000000000000000000000000000000000000000000000000000";
 signal din1:std_logic;
 signal sck1:std_logic;	
 signal	rck1:std_logic;
 
 constant clk_period: time:=84ns;
 
 begin
 
 EC:DataTo595 port map ( 
	clk=>clk1,
	rst=>rst1,
	ctrlcode595=>ctrlcode5951,
	din=>din1,
	sck=>sck1,
	rck=>rck1
	);
	
	clk_process: process
	begin
		clk1<='0';
		wait for clk_period/2;
		clk1<='1';
		wait for clk_period/2;
	end process;
 
 end behav;