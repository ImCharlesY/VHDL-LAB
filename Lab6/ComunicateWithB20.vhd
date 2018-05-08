library ieee;                    
use  ieee.std_logic_1164.all;     
use  ieee.std_logic_unsigned.all; 

entity ComunicateWithB20 is
port(
	DQ:		inout 	std_logic 			   := '1'	;
	Data:	out 	std_logic_vector(15 downto 0) 	;
	clk:	in 		std_logic
);
end entity;

architecture behavior of ComunicateWithB20 is
----------------------Signal Declaration-------------------
--State machine
signal turn:		integer 					:=0 		;
signal state:		integer range 0 to 3 		:=0 		;
signal num:			integer range 0 to 16 					;
--Instruction
signal ROM_ins: 	std_logic_vector(7 downto 0):="11001100";--CCH
signal CHG_ins:		std_logic_vector(7 downto 0):="01000100";--44H
signal READ_ins: 	std_logic_vector(7 downto 0):="10111110";--BEH
--CLK
signal us_devide: 	integer range 0 to 11 					;
signal s_devide:	integer range 0 to 1000000 				;
signal overflow: 	std_logic 								;
signal us_cnt:		integer	range 0 to 1500 				;
--Cache
signal read_in:		std_logic 								;
---------------------End Signal Declaration-----------------

begin
	process(clk)
	begin
		if clk'event and clk = '1' then --1us clk
			if us_devide = 5 then
				overflow <= '0';
			elsif us_devide = 11 then
				us_devide <= 0;
				overflow <= '1';
			end if;
			us_devide <= us_devide + 1;
		end if ;
	end process;

	process(overflow)
	begin
	if overflow'event and overflow = '1' then
		case state is 
			when 0 =>		--Initialize
				us_cnt <= us_cnt + 1;
				if 	us_cnt < 700 then 	
					DQ <= '0';
				elsif us_cnt = 700 then	
					DQ <= 'Z'; 
				elsif us_cnt = 760 then
					if DQ = '0' then 
						us_cnt <= 761;
					else us_cnt <= 759;
					end if;
				elsif us_cnt = 1500 then 
					us_cnt <= 0;
					num <= 0;
					state <= 1;
				end if;
			when 1 =>		--Write ROM Instruction
				if us_cnt < 5 then 
					DQ <= '0';
				elsif us_cnt = 5 then 
					DQ <= ROM_ins(num);
				elsif us_cnt = 80 then
					DQ <= 'Z'; 
				elsif us_cnt = 90 then
					num <= num + 1;
					us_cnt <= 0;
				end if;
				us_cnt <= us_cnt + 1;
				if num = 8 then 
					us_cnt <= 0;
					state <= 2;
					num <= 0;
				end if;
			when 2 =>		--Write RAM Instruction
				if us_cnt < 5 then 
					DQ <= '0';
				elsif us_cnt = 5 then 
					if turn = 0 then DQ <= CHG_ins(num);
					else DQ <= READ_ins(num); end if;
				elsif us_cnt = 80 then
					DQ <= 'Z'; 
				elsif us_cnt = 90 then
					num <= num + 1;
					us_cnt <= 0;
				end if;
				us_cnt <= us_cnt + 1;
				if num = 8 then 
					us_cnt <= 0;
					state <= 3;
					num <= 0;
					DQ <= 'Z';
				end if;
			when 3 =>		--Wait for Convertion / Read Temperature Data from the Device
				if turn = 0 then --Wait for Convertion
					s_devide <= s_devide + 1;
					if s_devide = 1000000 then 
						turn <= 1;
						state <= 0;
					end if;
				else 		--Read Temperature Data 
					if us_cnt < 5 then 
						DQ <= '0';
					elsif us_cnt = 5 then 
						DQ <= 'Z';
					elsif us_cnt < 20 then 
						read_in <= DQ;
					elsif us_cnt = 80 then
						Data(num) <= read_in;
						num <= num + 1;
						us_cnt <= 0;
					end if;
					us_cnt <= us_cnt + 1;
					if num = 16 then 
						us_cnt <= 0;
						state <= 0;
						turn <= 0;
						num <= 0;
					end if;
				end if;
		end case;
	end if;
	end process;
 
end behavior;