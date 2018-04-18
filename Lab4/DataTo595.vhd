 library ieee;                    
 use  ieee.std_logic_1164.all;     
 use  ieee.std_logic_unsigned.all; 
 
 ----This entity implements sending data to 595
 
 entity dataTo595 is
 port(
	clk:in std_logic;		--12MHz clock
	rst:in std_logic;		--the state of reset key(after sampling)
	
	--the control code sent to 595
	--Each segment requires 16bit serial code:
	--bit0:DP, bit1-7:G to A, bit8-9:don't care, bit10-15:digit6-digit1
	--6 segments, so the total ctrl code is 16*6=96bits
	ctrlcode595:in std_logic_vector(95 downto 0);	
	
	din:out std_logic;	--data stream to 595
	sck:out std_logic;	--595 shift clock
	rck:out std_logic	--595 output pulse
);
 end dataTo595;
 
 architecture Series2Parallel of dataTo595 is
---------------------- Signals Declaration-------------------
 
---------------------End Signals Declaration-----------------	

 begin
	
 end Series2Parallel;