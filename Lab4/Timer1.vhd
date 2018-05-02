 library ieee;                    
 use  ieee.std_logic_1164.all;     
 use  ieee.std_logic_unsigned.all; 
 
 ----This entity implements the main timer
 
 entity Timer is
 port(
  	clk:in std_logic;		--12MHz clock
	sec:in std_logic;		--1Hz clock
	rst:in std_logic;		--the state of reset key(after sampling)
	
	mode:in integer range 0 to 3;	--current clock mode
	
	upkey:in std_logic;			--the state of up key(after sampling)
	downkey:in std_logic;		--the state of down key(after sampling)
	
	act_of_re:in integer;	--action of rotary encoder: 0-no action; 1-clockwise; -1-anti-clockwise
	
	hL:out integer range 0 to 9;		
	hH:out integer range 0 to 2;		
	mL:out integer range 0 to 9;		
	mH:out integer range 0 to 5;		
	sL:out integer range 0 to 9;		
	sH:out integer range 0 to 5	
);
 end Timer;
 
 architecture mainTimer of Timer is
-----------------------Signals Declaration-------------------
 ----signals for mode 0
 signal hLRec0:integer range 0 to 9;		--record the value of hour low
 signal hHRec0:integer range 0 to 2;		--record the value of hour high
 
 signal mLRec0:integer range 0 to 9;		--record the value of minute low
 signal mHRec0:integer range 0 to 5;		--record the value of minute high
 
 signal sLRec0:integer range 0 to 9;		--record the value of second low
 signal sHRec0:integer range 0 to 6;		--record the value of second high
 
 ----signals for mode 1&2&3 
 signal hLRec1:integer range 0 to 9;		--record the value of hour low
 signal hHRec1:integer range 0 to 2;		--record the value of hour high
 
 signal mLRec1:integer range 0 to 9;		--record the value of minute low
 signal mHRec1:integer range 0 to 5;		--record the value of minute high
 
 signal sLRec1:integer range 0 to 9;		--record the value of second low
 signal sHRec1:integer range 0 to 5;		--record the value of second high
 
 ----Record last state of keys
 signal sec_ls:std_logic;
 signal upkey_ls:std_logic;		--store the last state of up key
 signal downkey_ls:std_logic;	--store the last state of down key
---------------------End Signals Declaration-----------------	

 begin
	----This process tests the change of 1Hz clock and the reset signal and mode, then counts in mode 0
	process(clk,rst,mode)
	begin
		if (rst='1') then	--asynchronous reset
			hLRec0<=0;hHRec0<=0;
			mLRec0<=0;mHRec0<=0;
			sLRec0<=0;sHRec0<=0;
		elsif (rising_edge(clk)) then
			if (sec_ls='0' and sec='1') then
				case mode is
					--Mode 0: Normal Timer
					when 0=>
						if (sLRec0=9) then	--seconds low carry
							sLRec0<=0;
							if (sHRec0=5) then	--seconds high carry
								sHRec0<=0;
								if (mLRec0=9) then	--minutes low carry
									mLRec0<=0;
									if (mHRec0=5) then	--minutes high carry
										mHRec0<=0;
										if (hLRec0=3 and hHRec0=2) then --reset state
											hLRec0<=0; hHRec0<=0;
										elsif (hLRec0=9) then --hours low carry
											hLRec0<=0; hHRec0<=hHRec0+1;
										else	--hours low no carry
											hLRec0<=hLRec0+1;
										end if;
									else	--minutes high no carry
										mHRec0<=mHRec0+1;
									end if;
								else	--minutes low no carry
									mLRec0<=mLRec0+1;
								end if;
							else	--seconds high no carry
								sHRec0<=sHRec0+1;
							end if;
						else	--seconds low no carry
							sLRec0<=sLRec0+1;
						end if;
					--Other
					when others=>
						hLRec0<=hLRec1;hHRec0<=hHRec1;
						mLRec0<=mLRec1;mHRec0<=mHRec1;
						sLRec0<=sLRec1;sHRec0<=sHRec1;
				end case;
			end if;
		end if;
	end process;
	
	----This process tests the change of 12MHz clock and the reset signal and mode, then counts in mode 1&2&3
	process(clk,rst,mode)
	begin
		if (rst='1') then	--asynchronous reset
			hLRec1<=0;hHRec1<=0;
			mLRec1<=0;mHRec1<=0;
			sLRec1<=0;sHRec1<=0;
		elsif (rising_edge(clk)) then
			case mode is
				--Mode 1: Setting Hour
				when 1=>
					if (act_of_re=1 or (upkey_ls='1' and upkey='0')) then		--If up key pressed
						if (hLRec1=3 and hHRec1=2) then		--reset state
							hLRec1<=0; hHRec1<=0;
						elsif (hLRec1=9) then	--hours low carry
							hLRec1<=0;
							hHRec1<=hHRec1+1;
						else	--hours low no carry
							hLRec1<=hLRec1+1;
						end if;
					elsif (act_of_re=-1 or (downkey_ls='1' and downkey='0')) then --If down key pressed
						if (hLRec1=0 and hHRec1=0) then		--reset state
							hLRec1<=3; hHRec1<=2;
						elsif (hLRec1=0) then	--hours low carry
							hLRec1<=9;
							hHRec1<=hHRec1-1;
						else	--hours low no carry
							hLRec1<=hLRec1-1;
						end if;
					end if;
				--Mode 2: Setting Minute
				when 2=>
					if (act_of_re=1 or (upkey_ls='1' and upkey='0')) then		--If up key pressed
						if (mLRec1=9) then	--minutes low carry
							mLRec1<=0;
							if (mHRec1=5) then	--minutes high carry
								mHRec1<=0;
							else	--minutes high no carry
								mHRec1<=mHRec1+1;
							end if;
						else	--minutes low no carry
							mLRec1<=mLRec1+1;
						end if;
					elsif (act_of_re=-1 or (downkey_ls='1' and downkey='0')) then --If down key pressed
						if (mLRec1=0) then	--minutes low carry
							mLRec1<=9;
							if (mHRec1=0) then	--minutes high carry
								mHRec1<=5;
							else	--minutes high no carry
								mHRec1<=mHRec1-1;
							end if;
						else	--minutes low no carry
							mLRec1<=mLRec1-1;
						end if;
					end if;
				--Mode 3: Setting Second
				when 3=>
					if (act_of_re=1 or (upkey_ls='1' and upkey='0')) then		--If up key pressed
						if (sLRec1=9) then	--seconds low carry
							sLRec1<=0;
							if (sHRec1=5) then	--seconds high carry
								sHRec1<=0;
							else	--seconds high no carry
								sHRec1<=sHRec1+1;
							end if;
						else	--seconds low no carry
							sLRec1<=sLRec1+1;
						end if;
					elsif (act_of_re=-1 or (downkey_ls='1' and downkey='0')) then --If down key pressed
						if (sLRec1=0) then	--seconds low carry
							sLRec1<=9;
							if (sHRec1=0) then	--seconds high carry
								sHRec1<=5;
							else	--seconds high no carry
								sHRec1<=sHRec1-1;
							end if;
						else	--seconds low no carry
							sLRec1<=sLRec1-1;
						end if;
					end if;
				--Other	
				when others=>	--If mode is 0, keep the recording the same as rec of mode 0
					hLRec1<=hLRec0;hHRec1<=hHRec0;
					mLRec1<=mLRec0;mHRec1<=mHRec0;
					sLRec1<=sLRec0;sHRec1<=sHRec0;
			end case;
		end if;
	end process;
	
	----Set Timer and record key state
	process(clk)
	begin
		if (rising_edge(clk)) then
			upkey_ls<=upkey;		--if up key pressed, upkey_ls = '1' and upkey = '0'
			downkey_ls<=downkey;    --if down key pressed, downkey_ls = '1' and downkey = '0'
			sec_ls<=sec;
		end if;
	end process;
	
	hL<=hLRec1;hH<=hHRec1;mL<=mLRec1;mH<=mHRec1;sL<=sLRec1;sH<=sHRec1;
	
 end mainTimer;