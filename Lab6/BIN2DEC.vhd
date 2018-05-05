 library ieee;                    
 use  ieee.std_logic_1164.all;     
 use  ieee.std_logic_unsigned.all; 
 
 
 entity BIN2DEC is
 port(
	bin_value:in std_logic_vector(7 downto 0);
	sign:out std_logic;				--1->negative;0->positive
	dec_out_int:out integer; 		--integer part of dec value
	dec_out_frac:out integer 		--fractional part of dec value
 );
 end entity;
 
 architecture behavior of BIN2DEC is
 ----------------------Signal Declaration-------------------
 
 ---------------------End Signal Declaration-----------------
 
 begin
 
 end behavior;