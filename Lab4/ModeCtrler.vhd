 library ieee;                    
 use  ieee.std_logic_1164.all;     
 use  ieee.std_logic_unsigned.all; 
 
 --this entity implements mode controller
 
 entity ModeCtrler is 
 port (
	clk:in std_logic;			--12MHz Clock
	rst:in std_logic;			--the state of reset key(after sampling) 
	modekey:in std_logic;		--the state of mode key(after sampling) 
	mode:out integer range 0 to 3;		--current clock mode
	modedisplay:out std_logic_vector(3 downto 0)	--4 LEDs displaying current clock mode
 );
 end ModeCtrler;
 
 architecture ModeCtrl of ModeCtrler is
-----------------------Signals Declaration-------------------
 signal moderec:integer range 0 to 3;	--record current clock mode
---------------------End Signals Declaration-----------------	

 begin
	----This process tests the change of mode key and rst signal, then set moderec
	process(modekey,rst)
	begin
		if (rst='1') then	--asynchronous reset
			moderec<=0;
		elsif (falling_edge(modekey)) then
			moderec<=moderec+1;
		end if;
		if (moderec>3) then
			moderec<=0;
		end if;
	end process;
	
	----This process tests the change of 12MHz clock, then set mode
	process(clk)
	begin
		if (rising_edge(clk)) then
			mode<=moderec;
		end if;
	end process;
	
	----This process tests the change of moderec, then display current clock mode
	process(moderec)
	begin
	    case moderec is
		when 0=> modedisplay<="1110";
		when 1=> modedisplay<="1101";
		when 2=> modedisplay<="1011";
		when 3=> modedisplay<="0111";
		when others=> modedisplay<="1110";
		end case;
	end process;
 
 end ModeCtrl;