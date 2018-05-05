 library ieee;                    
 use  ieee.std_logic_1164.all;     
 use  ieee.std_logic_unsigned.all; 
  
 entity DigitEncoder is
 port(
	sign:out std_logic;				--1->negative;0->positive
	int:out integer; 				--integer part
	frac:out integer; 				--fractional part	
	
	--the control code sent to 595
	--Each segment requires 16bit serial code:
	--bit0:DP, bit1-7:G to A, bit8-9:don't care, bit10-15:digit6-digit1
	--6 segments, so the total ctrl code is 16*6=96bits
	ctrlcode595:out std_logic_vector(95 downto 0)
 );
 end DigitEncoder;
 
 architecture behavior of DigitEncoder is
 ------------------Constant Table Declaration---------------
 type TwoDim_Array is array(natural range <>) of std_logic_vector(7 downto 0);		--define 2D array

 constant enDig:TwoDim_Array(0 to 6):=(		--enable each digit
 "01111111","10111111","11011111",
 "11101111","11110111","11111011",
 "11111111");

 constant segmentdecode:TwoDim_Array(0 to 16):=(		--decoder fot each num, 16 is off
 "11111100","01100000","11011010","11110010",
 "01100110","10110110","10111110","11100000",
 "11111110","11110110","11101110","00111110",
 "10011100","01111010","10011110","10001110",
 "00000000");

 constant segmentdecode_dp:TwoDim_Array(0 to 16):=(		--decoder fot each num, 16 is off, lighten the digit point
 "11111101","01100001","11011011","11110011",
 "01100111","10110111","10111111","11100001",
 "11111111","11110111","11101111","00111111",
 "10011101","01111011","10011111","10001111",
 "00000000");
 ---------------------End Table Declaration-----------------
 
 begin
 --Get all code and combine them into a series code as ctrlcode595
	--for hour low
	ctrlcode595(7 downto 0)<=segmentdecode(0);
	ctrlcode595(15 downto 8)<=enDig(0);
	
	--for hour high
	ctrlcode595(23 downto 16)<=segmentdecode_dp(0);
	ctrlcode595(31 downto 24)<=enDig(1);
	
	--for minute low
	ctrlcode595(39 downto 32)<=segmentdecode(0);
	ctrlcode595(47 downto 40)<=enDig(2);
	
	--for minute high
	ctrlcode595(55 downto 48)<=segmentdecode_dp(0);
	ctrlcode595(63 downto 56)<=enDig(3);
	
	--for second low
	ctrlcode595(71 downto 64)<=segmentdecode(0);
	ctrlcode595(79 downto 72)<=enDig(4);
	
	--for second high
	ctrlcode595(87 downto 80)<=segmentdecode(0);
	ctrlcode595(95 downto 88)<=enDig(5);
 end behavior;