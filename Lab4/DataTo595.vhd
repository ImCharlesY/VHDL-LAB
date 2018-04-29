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
 signal shift_clock_cnt:integer:=0;		--counter
 signal shift_clock:std_logic:='1';
 signal shift_clock_ls:std_logic;
 signal shift_cnt:integer range 0 to 15;
 signal parallout:std_logic;		--parallel out pulse
 
 signal codeP: integer range 0 to 5;  --indicate which part of ctrl code is being sent
 signal codeP0: std_logic_vector(15 downto 0);
 signal codeP1: std_logic_vector(15 downto 0);
 signal codeP2: std_logic_vector(15 downto 0);
 signal codeP3: std_logic_vector(15 downto 0);
 signal codeP4: std_logic_vector(15 downto 0);
 signal codeP5: std_logic_vector(15 downto 0);
 
---------------------End Signals Declaration-----------------	
 begin
 
	--divide ctrl code into 6 parts
	codeP0 <= ctrlcode595(15 downto 0);
	codeP1 <= ctrlcode595(31 downto 16);
	codeP2 <= ctrlcode595(47 downto 32);
	codeP3 <= ctrlcode595(63 downto 48);
	codeP4 <= ctrlcode595(79 downto 64);
	codeP5 <= ctrlcode595(95 downto 80);
 
	----This process divides 12MHz clock into 1MHz, using as data shift clock
	process(clk,rst)
	begin
		if (rst='1') then	--asynchronous reset
			shift_clock_cnt<=0;
			shift_clock<='1';
		elsif (rising_edge(clk)) then
			shift_clock_cnt<=shift_clock_cnt+1;
			if (shift_clock_cnt=2) then
				shift_clock<=not shift_clock;					
				shift_clock_cnt<=0;	
			end if;
		end if;	
	end process;
	sck<=shift_clock;

	----This process record last state of shift clock
	process(clk)
	begin
		if(rising_edge(clk)) then
			shift_clock_ls<=shift_clock;
		end if;
	end process;
	
	----This process counts the times of shift at rising edge of shift_clk
	----When shift_cnt is n, it means we have already shift n digits to 595
	process(clk,rst)
	begin
		if (rst='1') then
			shift_cnt<=0;
		elsif (rising_edge(clk)) then
			if (shift_clock='1' and shift_clock_ls='0') then
				if (shift_cnt=15) then
					shift_cnt<=0;
				else
					shift_cnt<=shift_cnt+1;
				end if;
			end if;
		end if;
	end process;
	
	----This process parallely outputs data when shift_cnt=0
	----Because if shift_cnt is reset to 0, it means we have already shift 16 digits to 595
	----and it is time to output them.
	process(shift_cnt,rst)
	begin
		if (rst='1') then
			parallout<='1';
		elsif (shift_cnt=0) then
			parallout<='1';	--send data
		else
			parallout<='0';
		end if;
	end process;
	rck<=parallout;
	
	----This process writes a digit to din at falling edge of shift_clk
	----and the rising edge right after it will actually shift the certain digit into 595
	----then the counting process above will count a shift
	process(clk,rst)
	begin
		if (rst='1') then
			din<='0';
		elsif (rising_edge(clk)) then
			if (shift_clock='0' and shift_clock_ls='1') then
				case codeP is
					when 0=> din<=codeP0(shift_cnt);
					when 1=> din<=codeP1(shift_cnt);
					when 2=> din<=codeP2(shift_cnt);
					when 3=> din<=codeP3(shift_cnt);
					when 4=> din<=codeP4(shift_cnt);
					when 5=> din<=codeP5(shift_cnt);
					when others=> null;
				end case;
				if (shift_cnt=15) then	--finish one part, begin next part
					if (codeP=5) then
						codeP<=0;
					else
						codeP<=codeP+1;
					end if;
				end if;
			end if;
		end if;
	end process;
	
 end Series2Parallel;