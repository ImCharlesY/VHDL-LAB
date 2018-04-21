library ieee;
use ieee.std_logic_1164.all;
---------------------------------------------------------------
entity Key_Table is 
    port
    (
      	COLandROW :	in  std_logic_vector(7 downto 0);
		--7  6  5  4  3  2  1  0
		--r1 r2 r3 r4 c1 c2 c3 c4
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
signal get_clk:		integer 	range 0 to 200		;
signal overflow:	boolean 	:= true 			;
signal CaR_cache: 	std_logic_vector(7 downto 0)	;
signal BTN_cache:	std_logic_vector(3 downto 0)	;
begin
	process(clk)
	begin
	if clk'event and clk = '1' then --1ms分频	
		if clk_cnt = 6000 then
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
	if overflow'event and overflow = true then
		--键盘的延迟读?		
		if CaR_cache /= COLandROW or BTN_cache /=button_four then 
			CaR_cache <= COLandROW;
			BTN_cache <= button_four;
			get_clk <= 0;
		elsif get_clk = 30 then
			get_clk <= 0; 
			case CaR_cache(0) is
				when '0' =>a_to_g <= "1111110"; seg <= '0';--0
				when '1' =>a_to_g <= "0110000"; seg <= '0';--1
				--when "01110111" =>a_to_g <= "0110000"; seg <= '0';--1
				--when "01111011" =>a_to_g <= "1101101"; seg <= '0';--2
				--when "01111101" =>a_to_g <= "1111001"; seg <= '0';--3
				--when "01111110" =>a_to_g <= "0110011"; seg <= '0';--4
				--when "10110111" =>a_to_g <= "1011011"; seg <= '0';--5
				--when "10111011" =>a_to_g <= "1011111"; seg <= '0';--6
				--when "10111101" =>a_to_g <= "1110000"; seg <= '0';--7
				--when "10111110" =>a_to_g <= "1111111"; seg <= '0';--8
				--when "11010111" =>a_to_g <= "1111011"; seg <= '0';--9
				--when "11011011" =>a_to_g <= "1110111"; seg <= '0';--a
				--when "11011101" =>a_to_g <= "0011111"; seg <= '0';--b
				--when "11011110" =>a_to_g <= "1001110"; seg <= '0';--c
				--when "11100111" =>a_to_g <= "0111101"; seg <= '0';--d
				--when "11101011" =>a_to_g <= "1001111"; seg <= '0';--e
				--when "11101101" =>a_to_g <= "1000111"; seg <= '0';--f
				--when "11101110" =>a_to_g <= "1111110"; seg <= '0';--0
				--when others 	=>a_to_g <= "0000000"; seg <= '1';--NULL
			end case;
			led_four <= BTN_cache;
		else 
			get_clk<=get_clk+1;
		end if;
	end if;
	end process	;
end	Key_Table_arch;