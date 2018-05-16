 library ieee;                    
 use  ieee.std_logic_1164.all;     
 use  ieee.std_logic_unsigned.all; 
 use work.my_data_types.all;
 
 ------------------------------------------
 ---- This is the top module of lab 6  ----
 ------------------------------------------
 
 entity TemperatureSensor is
 port(
	clk:in std_logic;		--12MHz clock
	rst:in std_logic;
	
	DQ:inout std_logic;		--bus connecting step and DS18B20
		
	din:out std_logic;		--data stream to 595
	sck:out std_logic;		--595 shift clock
	rck:out std_logic		--595 output pulse
 );
 end TemperatureSensor;
 
 
 
 architecture behavior of TemperatureSensor is
 -----------------------Signals Declaration-------------------
 signal sample: std_logic_vector(15 downto 0);	-- sample value from DS18B20
 signal temp: rational_number(4 downto 0);
 
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
 component ConvertToDecimal
 port(
    Data: in std_logic_vector(15 downto 0);
	clk: in std_logic;
	DataOut: out rational_number(4 downto 0)
	);
 end component ConvertToDecimal;
 
 --component for digit encoder for 595
 component DigitEncoder
 port(
	temp: in rational_number(4 downto 0);
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
 
 ---------------------End Components Declaration------------------------
 
 begin
	--utilize digit encoder
	CB:ComunicateWithB20 PORT MAP (DQ,sample,clk);
	
	--utilize digit encoder
	CD:ConvertToDecimal PORT MAP (sample,clk,temp);
	
	--utilize digit encoder
	DE:DigitEncoder PORT MAP (temp,ctrlcode595);
	
	--utilize dataTo595 module
	DT:dataTo595 PORT MAP (clk,rst,ctrlcode595,din,sck,rck);
	
 end behavior;