library ieee;
use ieee.std_logic_1164.all;
---------------------------------------------------------------
entity Key_Table is 
    port
    (
      	ROW :		out std_logic_vector(3 downto 0);
      	COL :		in 	std_logic_vector(3 downto 0);
		button_four:in 	std_logic_vector(3 downto 0);
		a_to_g :	out std_logic_vector(6 downto 0);
		led_four:	out std_logic_vector(3 downto 0);
		seg :		out std_logic;
		clk	:		in 	std_logic
    );
end Key_Table;
----------------------------------------------------------------
architecture Key_Table_arch of Key_Table is
signal clk_cnt:		integer 	range 0 to 12000	;--12MHz,1ms
signal R_get:		integer 	range 0 to 30 		;
signal LED_get:		integer 	range 0 to 30		;
signal num_cnt:		integer		range 0 to 4 		;
signal overflow:	boolean 	:= true 			;
signal R_cache: 	std_logic_vector(15 downto 0)	;
signal BTN_cache:	std_logic_vector(3 downto 0)	;
begin

	process(clk)
	begin
	if clk'event and clk = '1' then --1ms分频	
		if clk_cnt = 6000 then
			if num_cnt = 4 then 
				num_cnt <= 0;
			else 
				num_cnt <= num_cnt + 1;
			end if;
			overflow <= false;
		elsif clk_cnt = 11999 then
			clk_cnt <= 0;
			overflow <= true;
		end if;
		clk_cnt <= clk_cnt + 1;
	end if ;
	end process;

	process(overflow)
	begin
	if overflow'event and overflow = false then
		case num_cnt is
			when 0 => ROW <= "0111";
			when 1 => ROW <= "1011";
			when 2 => ROW <= "1101";
			when 3 => ROW <= "1110";
		end case;
	end if;
	end process;


	process(overflow)
	begin 
	if overflow'event and overflow = true then
		--键盘的延迟读		
		if num_cnt = 0 then R_cache(15 downto 12) <= COL; end if;

		if num_cnt = 1 then R_cache(11 downto 8) <= COL; end if;

		if num_cnt = 2 then R_cache(7 downto 4) <= COL; end if;

		if num_cnt = 3 then R_cache(3 downto 0) <= COL; end if;

		if num_cnt = 4 then
		--如果想延迟可以在这里加
			case R_cache is
			when "0111111111111111" =>	a_to_g <= "0110000"; seg <= '0';--1
			when "1011111111111111" =>	a_to_g <= "1101101"; seg <= '0';--2
			when "1101111111111111" =>	a_to_g <= "1111001"; seg <= '0';--3
			when "1110111111111111" =>	a_to_g <= "0110011"; seg <= '0';--4
			when "1111011111111111" =>	a_to_g <= "1011011"; seg <= '0';--5
			when "1111101111111111" =>	a_to_g <= "1011111"; seg <= '0';--6
			when "1111110111111111" =>	a_to_g <= "1110000"; seg <= '0';--7
			when "1111111011111111" =>	a_to_g <= "1111111"; seg <= '0';--8
			when "1111111101111111" =>	a_to_g <= "1111011"; seg <= '0';--9
			when "1111111110111111" =>	a_to_g <= "1110111"; seg <= '0';--a
			when "1111111111011111" =>	a_to_g <= "0011111"; seg <= '0';--b
			when "1111111111101111" =>	a_to_g <= "1001110"; seg <= '0';--c
			when "1111111111110111" =>	a_to_g <= "0111101"; seg <= '0';--d
			when "1111111111111011" =>	a_to_g <= "1001111"; seg <= '0';--e
			when "1111111111111101" =>	a_to_g <= "1000111"; seg <= '0';--f
			when "1111111111111110" =>	a_to_g <= "0110111"; seg <= '0';--H
			when others 			=>	a_to_g <= "1111110"; seg <= '0';--0
			end case;
		end if;

		if BTN_cache /=button_four then 
			BTN_cache <= button_four;
			LED_get <= 0;
		elsif LED_get = 30 then
			LED_get <= 0;
			led_four <= BTN_cache;
		else 
			LED_get <= LED_get + 1;
		end if;
			
	end if;
	end process;

end	Key_Table_arch;