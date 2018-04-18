 library ieee;                    
 use  ieee.std_logic_1164.all;     
 use  ieee.std_logic_unsigned.all; 
 
  --this entity implements clock divider
  --generating 1sec clock
  
 entity ClockDivider is
 port(
	clk:in std_logic;		--12MHz clock
	rst:in std_logic;		--the state of reset key(after sampling)
	clk_out:out std_logic	--1Hz clock
 );
 end ClockDivider;
 
 architecture secgen of ClockDivider is
 
 begin
	process(clk,rst)
		variable seccnt:integer:=0;		--counter
	begin
		if (rst='1') then	--asynchronous reset
			seccnt:=0;
			clk_out<='0';
		elsif (rising_edge(clk)) then
			seccnt:=seccnt+1;
		end if;
		if (seccnt=6000000) then
			clk_out<='0';						
		elsif (seccnt=12000000) then
			clk_out<='1';					
			seccnt:=0;	
		end if;
	end process;
 end secgen;