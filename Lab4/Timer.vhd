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
 signal hLRec0:integer range -1 to 10;		--record the value of hour low
 signal hHRec0:integer range -1 to 2;		--record the value of hour high
 
 signal mLRec0:integer range -1 to 10;		--record the value of minute low
 signal mHRec0:integer range -1 to 6;		--record the value of minute high
 
 signal sLRec0:integer range -1 to 10;		--record the value of second low
 signal sHRec0:integer range -1 to 6;		--record the value of second high
 
 ----signals for mode 1&2&3 
 signal hLRec1:integer range -1 to 10;		--record the value of hour low
 signal hHRec1:integer range -1 to 2;		--record the value of hour high
 
 signal mLRec1:integer range -1 to 10;		--record the value of minute low
 signal mHRec1:integer range -1 to 6;		--record the value of minute high
 
 signal sLRec1:integer range -1 to 10;		--record the value of second low
 signal sHRec1:integer range -1 to 6;		--record the value of second high
 
 ----Record last state of keys
 signal upkey_ls:std_logic;		--store the last state of up key
 signal downkey_ls:std_logic;	--store the last state of down key
---------------------End Signals Declaration-----------------	

 begin
	----This process tests the change of 1Hz clock and the reset signal and mode, then counts in mode 0
	process(sec,rst,mode)
	begin
		if (rst='1') then	--asynchronous reset
			hLRec0<=0;hHRec0<=0;
			mLRec0<=0;mHRec0<=0;
			sLRec0<=0;sHRec0<=0;
		elsif (falling_edge(sec)) then
			case mode is
				--Mode 0: Normal Timer
				when 0=>
					sLRec0<=sLRec0+1;
					----Deal with carry----
					if (sLRec0=10) then
						sLRec0<=0;
						sHRec0<=sHRec0+1;
					end if;
					if (sHRec0=6) then
						sHRec0<=0;
						mLRec0<=mLRec0+1;
					end if;
					if (mLRec0=10) then
						mLRec0<=0;
						mHRec0<=mHRec0+1;
					end if;
					if (mHRec0=6) then
						mHRec0<=0;
						hLRec0<=hLRec0+1;
					end if;
					if (hLRec0=10) then
						hLRec0<=0;
						hHRec0<=hHRec0+1;
					end if;
					if (hHRec0=2 and hLRec0=4) then
						hLRec0<=0;hHRec0<=0;
						mLRec0<=0;mHRec0<=0;
						sLRec0<=0;sHRec0<=0;
					end if;
					----Deal with carry end----
				--Other
				when others=>null;
			end case;
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
					if (upkey_ls='1' and upkey='0') then		--If up key pressed
						hLRec1<=hLRec1+1;
						----Deal with carry----
						if (hLRec1=10) then
							hLRec1<=0;
							hHRec1<=hHRec1+1;
						end if;
						if (hHRec1=2 and hLRec1=5) then
							hLRec1<=0;hHRec1<=0;
						end if;
						----Deal with carry end----
					elsif (downkey_ls='1' and downkey='0') then --If down key pressed
						hLRec1<=hLRec1-1;
						----Deal with carry----
						if (hLRec1=-1) then
							hLRec1<=0;
							hHRec1<=hHRec1-1;
						end if;
						if (hHRec1=-1) then
							hLRec1<=3;hHRec1<=2;
						end if;
						----Deal with carry end----
					end if;
				--Mode 2: Setting Minute
				when 2=>
					if (upkey_ls='1' and upkey='0') then		--If up key pressed
						mLRec1<=mLRec1+1;
						----Deal with carry----
						if (mLRec1=10) then
							mLRec1<=0;
							mHRec1<=mHRec1+1;
						end if;
						if (mHRec1=10) then
							mLRec1<=0;mHRec1<=0;
						end if;
						----Deal with carry end----
					elsif (downkey_ls='1' and downkey='0') then --If down key pressed
						mLRec1<=mLRec1-1;
						----Deal with carry----
						if (mLRec1=-1) then
							mLRec1<=0;
							mHRec1<=mHRec1-1;
						end if;
						if (mHRec1=-1) then
							mLRec1<=9;mHRec1<=5;
						end if;
						----Deal with carry end----
					end if;
				--Mode 3: Setting Second
				when 3=>
					if (upkey_ls='1' and upkey='0') then		--If up key pressed
						sLRec1<=sLRec1+1;
						----Deal with carry----
						if (sLRec1=10) then
							sLRec1<=0;
							sHRec1<=sHRec1+1;
						end if;
						if (sHRec1=10) then
							sLRec1<=0;sHRec1<=0;
						end if;
						----Deal with carry end----
					elsif (downkey_ls='1' and downkey='0') then --If down key pressed
						sLRec1<=sLRec1-1;
						----Deal with carry----
						if (sLRec1=-1) then
							sLRec1<=0;
							sHRec1<=sHRec1-1;
						end if;
						if (sHRec1=-1) then
							sLRec1<=9;sHRec1<=5;
						end if;
						----Deal with carry end----
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
	process(clk,mode)
	begin
		if (rising_edge(clk)) then
			upkey_ls<=upkey;		--if up key pressed, upkey_ls = '1' and upkey = '0'
			downkey_ls<=downkey;    --if down key pressed, downkey_ls = '1' and downkey = '0'
			
			case mode is
				when 0=> hL<=hLRec0;hH<=hHRec0;mL<=mLRec0;mH<=mHRec0;sL<=sLRec0;sH<=sHRec0;
				when others=> hL<=hLRec1;hH<=hHRec1;mL<=mLRec1;mH<=mHRec1;sL<=sLRec1;sH<=sHRec1;
			end case;
		end if;
	end process;
	
 end mainTimer;