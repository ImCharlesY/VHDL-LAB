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
 signal seccnt:integer:=0;		--counter
 signal sec:std_logic:='0';
 begin
	process(clk,rst)
	begin
		if (rst='1') then	--asynchronous reset
			seccnt<=0;
			sec<='0';
		elsif (rising_edge(clk)) then
			seccnt<=seccnt+1;
			if (seccnt=6000000) then
				sec<=not sec;
				seccnt<=0;	
			end if;
		end if;
	end process;
	clk_out<=sec;
 end secgen;