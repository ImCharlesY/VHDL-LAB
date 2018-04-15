 library ieee;                    
 use  ieee.std_logic_1164.all;     
 use  ieee.std_logic_unsigned.all; 
 
 ------------------------------------------
 ---- This is the top module of lab 4  ----
 ------------------------------------------
 
 entity electricalClock is
	port(
		clk:in std_logic;	--12MHz clock
		
		rst_key:in std_logic;			--the state of reset key
		mode_key:in std_logic;		--the state of mode key
		up_key:in std_logic;		--the state of count up key
		down_key:in std_logic;		--the state of count down key
		
		modedisplay:out std_logic_vector(3 downto 0);  --using 4 leds to display the mode
		
		din:out std_logic;		--data stream to 595
		sck:out std_logic;		--595 shift clock
		rck:out std_logic;		--595 output pulse
	);
 end electricalClock;
 
 
 
 architecture behavior of electricalClock is
 -----------------------Signals Declaration-------------------
signal mode:integer:=0;		--current mode

signal sec:std_logic;   --1s clock

signal rst_key_state:std_logic;		--the state of rst key(after sampling)
signal mode_key_state:std_logic;	--the state of mode key(after sampling)
signal up_key_state:std_logic;	--the state of up key(after sampling)
signal down_key_state:std_logic;	--the state of down key(after sampling)

signal hL:integer range 0 to 9;		--the lower digit of hour
signal hH:integer range 0 to 2;		--the higher digit of hour
signal mL:integer range 0 to 9;		--the lower digit of minute
signal mH:integer range 0 to 6;		--the higher digit of minute
signal sL:integer range 0 to 9;		--the lower digit of second
signal sH:integer range 0 to 6;		--the higher digit of second

--the control code sent to 595
--Each segment requires 16bit serial code:
--bit0:DP, bit1-7:G to A, bit8-9:don't care, bit10-15:digit6-digit1
--6 segments, so the total ctrl code is 16*6=96bits
signal ctrlcode595:std_logic_vector(95 downto 0);	
---------------------End Signals Declaration-----------------	


 -----------------------Declare Components---------------------------
 --component for clock divider
 component clk_div
 port(
	clk:in std_logic;
	rst:in std_logic;
	clk_out:out std_logic;
 );
 end component clk_div;
 
 --component for key sampler
 component CycleSampler
 port(
 	clk: in std_logic;
	btnstate: in std_logic;
	keystate: out std_logic
	);
 end component CycleSampler;
 
 --component for Timer
 component timer
 port(
  	clk:in std_logic;
	sec:in std_logic;
	rst:in std_logic;
	
	mode:in integer range 0 to 3;
	
	upkey:in std_logic;
	downkey:in std_logic;
	
	hL:out integer range 0 to 9;		
	hH:out integer range 0 to 2;		
	mL:out integer range 0 to 9;		
	mH:out integer range 0 to 6;		
	sL:out integer range 0 to 9;		
	sH:out integer range 0 to 6;		
);
 end component timer;
 
 --component for time encoder for 595
 component timeencoder
 port(
	hL:in integer range 0 to 9;		
	hH:in integer range 0 to 2;		
	mL:in integer range 0 to 9;		
	mH:in integer range 0 to 6;		
	sL:in integer range 0 to 9;		
	sH:in integer range 0 to 6;	
	
	ctrlcode595:out std_logic_vector(95 downto 0);
);
 end component timeencoder;
 
 --component for sending data to 595
  component dataTo595
 port(
	clk:in std_logic;
	rst:in std_logic;
	
	ctrlcode595:in std_logic_vector(95 downto 0);
	
	din:out std_logic;
	sck:out std_logic;
	rck:out std_logic;
);
 end component dataTo595;
 
 -----------------------End Components Declaration------------------------
 
 begin
 
	--utilize clock divider: generate 1s clock
	secGen:clk_div PORT MAP (clk,rst,sec);
	
	--utilize key sampler
	rstkey:CycleSampler PORT MAP (clk,rst_key,rst_key_state);
	modekey:CycleSampler PORT MAP (clk,mode_key,mode_key_state);
	upkey:CycleSampler PORT MAP (clk,up_key,up_key_state);
	downkey:CycleSampler PORT MAP (clk,down_key,down_key_state);
	
	--utilize timer
	tm:timer PORT MAP (clk,sec,rst_key_state,mode,up_key_state,down_key_state,hL,hH,mL,mH,sL,sH);
	
	--utilize time encoder
	te:timeencoder PORT MAP (hL,hH,mL,mH,sL,sH,ctrlcode595);
	
	--utilize dataTo595 module
	dt:dataTo595 PORT MAP (clk,rst_key_state,ctrlcode595,din,sck,rck);
 
 end behavior;