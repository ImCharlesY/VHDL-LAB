 library ieee;                    
 use  ieee.std_logic_1164.all;     
 use  ieee.std_logic_unsigned.all; 
 use ieee.std_logic_arith.all;
 use work.my_data_types.all;
 
 ------------------------------------------
 ---- This is the top module of lab 6  ----
 ------------------------------------------
 
 entity TemperatureSensor is
 port(
	clk:in std_logic;		--12MHz clock
	rst:in std_logic;
	
	mode_key:in std_logic;
	
	beep: out std_logic;
	
	DQ:inout std_logic;		--bus connecting step and DS18B20
		
	din:out std_logic;		--data stream to 595
	sck:out std_logic;		--595 shift clock
	rck:out std_logic		--595 output pulse
 );
 end TemperatureSensor;
 
 
 
 architecture behavior of TemperatureSensor is
 -----------------------Signals Declaration-------------------
 signal sample: std_logic_vector(15 downto 0);	-- sample value from DS18B20
 signal tempC: integer_number(4 downto 0);
 signal tempF: integer_number(4 downto 0);
 signal mode: integer;
 signal en: std_logic;
 
 --the control code sent to 595
 --Each segment requires 16bit serial code:
 --bit0:DP, bit1-7:G to A, bit8-9:don't care, bit10-15:digit6-digit1
 --6 segments, so the total ctrl code is 16*6=96bits
 signal ctrlcode595:std_logic_vector(95 downto 0);
---------------------End Signals Declaration-----------------	


 -----------------------Declare Components---------------------------
 --component for DS18B20
 component ComunicateWithB20
 port(
	DQ:inout std_logic;
	Data:out std_logic_vector(15 downto 0);
	clk:in 	std_logic
 );
 end component ComunicateWithB20;
 
 --component for BIN2DEC
 component ConvertToCelsius
 port(
    Data: in std_logic_vector(15 downto 0);
	clk: in std_logic;
	--DataLastBit:out integer;
	DataOut: out integer_number(4 downto 0)
	);
 end component ConvertToCelsius;
 
 --component for BIN2DEC
 component ConvertToFahrenheit is
 port(
    DataOut: in integer_number(4 downto 0);
	clk: in std_logic;
	DataF: out integer_number(4 downto 0)
	);
 end component ConvertToFahrenheit;
 
 --component for digit encoder for 595
 component DigitEncoder
 port(
	tempC: in integer_number(4 downto 0);
	tempF: in integer_number(4 downto 0);
	
	mode: in integer range 0 to 1;
	
	ctrlcode595:out std_logic_vector(95 downto 0)
 );
 end component DigitEncoder;
 
 --component for sending data to 595
 component dataTo595
 port(
	clk:in std_logic;
	rst:in std_logic;
	
	ctrlcode595:in std_logic_vector(95 downto 0);
	
	din:out std_logic;
	sck:out std_logic;
	rck:out std_logic
 );
 end component dataTo595;
 
 --component for mode controller
 component ModeCtrller is
 port(
	clk:in std_logic;
	rst:in std_logic;
	
	modekey:in std_logic;
	
	mode:out integer;
	
	tempC:in integer_number(4 downto 0);
	en:out std_logic
 );
 end component ModeCtrller;
 
 --component for beep controller
 component BeepCtrller is
	port(
		clk:in std_logic;	--12MHz clock
		en:in std_logic;
		beep:out std_logic
	);
 end component BeepCtrller;

 
 ---------------------End Components Declaration------------------------
 
 begin
	--utilize Comunication with B20
	CB:ComunicateWithB20 PORT MAP (DQ,sample,clk);
	
	--utilize encoder
	CC:ConvertToCelsius PORT MAP (sample,clk,tempC);
	
	--utilize encoder
	CF:ConvertToFahrenheit PORT MAP (tempC,clk,tempF);
	
	--utilize digit encoder
	DE:DigitEncoder PORT MAP (tempC,tempF,mode,ctrlcode595);
	
	--utilize dataTo595 module
	DT:dataTo595 PORT MAP (clk,rst,ctrlcode595,din,sck,rck);
	
	--utilize mode controller
	MC:ModeCtrller PORT MAP (clk,rst,mode_key,mode,tempC,en);
	
	--utilize beep
	BC:BeepCtrller PORT MAP (clk,en,beep);
	
 end behavior;