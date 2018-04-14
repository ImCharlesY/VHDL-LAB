library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_unsigned.all;

entity STEP_MXO2 is
	port(
		clk:in std_logic;		--12MHz clock
		button:in std_logic_vector(1 downto 0);		--state of buttons:0->mode btn;1->reset btn
		secdisplay:out std_logic;	--state of led which shows 1s clock
		modedisplay:out std_logic_vector(3 downto 0);  --using 4 leds to display the mode
		trafficLights:out std_logic_vector(5 downto 0);	--the ctrlword of two RGB LEDs
		digitdisplay:out std_logic_vector(17 downto 0)  --the ctrlword of two segments
	);
end STEP_MXO2;



architecture trafficlights of STEP_MXO2 is
-----------------------Signals Declaration-------------------
signal mode:integer:=0;		--current mode

signal sec:std_logic;   --1s clock

signal keystate:std_logic_vector (1 downto 0);	--the state of 2 key(mode and reset)(after sampling)

type state is (RG,RY,GR,YR,YY,NN);		--for FSM
signal prstate:state:=RG;		
signal nxstate:state:=RY;

constant delayMax:integer:=13;			--define delay time
type OneDim_Array is array (0 to 3) of integer;
constant delayRG:OneDim_Array:=(10,7,13,0);		--delay in state RG for each mode
constant delayRY:OneDim_Array:=(3,3,3,0);
constant delayGR:OneDim_Array:=(10,13,7,0);
constant delayYR:OneDim_Array:=(3,3,3,0);
signal delay:integer range 0 to delayMax;		--current state actual delay time according to mode

type TwoDim_Array is array(natural range <>) of std_logic_vector(17 downto 0);		--define 2D array
constant segmentdecode:TwoDim_Array(0 to 15):=(								--decode of 0-15 for segments
"000000001111111000","000000001011000000","000000001110110100","000000001111100100",
"000000001011001100","000000001101101100","000000001101111100","000000001111000000",
"000000001111111100","000000001111101100","011000000111111000","011000000011000000",
"011000000110110100","011000000111100100","011000000011001100","011000000101101100");
---------------------End Signals Declaration-----------------	



 -----------------------Declare Components---------------------------
 --component for keys
 component key
 port(
  	clk: in std_logic;
	btnstate: in std_logic_vector (1 downto 0);	
	keystate: out std_logic_vector (1 downto 0)
 );
 end component key;
 -----------------------End Components Declaration------------------------

---------------------PROCESS-------------------------
begin
	--utilize key sampler
	ks: key PORT MAP (clk,button,keystate);
	
	----This process is the top process. It displays the mode
	process(clk)
	begin
		if (rising_edge(clk)) then
			secdisplay<=not(sec);					--display 1s clock using a led
			case mode is
				when 0=>
					modedisplay<="0111";				--output state of four leds showing current mode
				when 1=>
					modedisplay<="1011";
				when 2=>
					modedisplay<="1101";
				when 3=>
					modedisplay<="1110";
				when others=>
					modedisplay<="0111";
			end case;
		end if;
	end process;
	
	
	----This process divide the 12MHz clock into 1Hz, generating 1s clock
	process(clk)
		variable seccnt:integer:=0;		--counter
	begin
		if (rising_edge(clk)) then
			seccnt:=seccnt+1;
		end if;
		if (seccnt=6000000) then
			sec<='1';						--go high
		elsif (seccnt=12000000) then
			sec<='0';
			seccnt:=0;						--clear cnt
		end if;
	end process;

	
	----This process changes mode if key0 pressed
	process(keystate(0),keystate(1))
	begin
		if (keystate(1)='1') then		--If key1 pressed,reset
			mode<=0;
		elsif (rising_edge(keystate(0))) then
			mode<=mode+1;
		end if;
		if (mode>=4) then
			mode<=0;
		end if;
	end process;
	
	
	------------------------The following implements FSM-----------------------------
	----This process counts the delay and changes the state
	process(sec,mode,keystate(1))
		variable delaycnt:integer:=0;
	begin
		if (keystate(1)='1') then		--If key1 pressed,reset
			prstate<=RG;
			delaycnt:=0;
		elsif (rising_edge(sec)) then
			delaycnt:=delaycnt+1;
			if (delaycnt>=delay) then
				prstate<=nxstate;
				delaycnt:=0;
			end if;
		end if;
		digitdisplay<=segmentdecode(delay-delaycnt);	--display countdown
	end process;
	
	
	----This process implements all state
	process(prstate,mode)
	begin
		case prstate is
			when RG=>
				trafficLights<="011110";
				if (mode/=3) then
					nxstate<=RY;
					delay<=delayRG(mode);
				else 
					nxstate<=YY;
					delay<=0;
				end if;
			when RY=>
				trafficLights<="011101";
				if (mode/=3) then
					nxstate<=GR;
					delay<=delayRY(mode);
				else 
					nxstate<=YY;
					delay<=0;
				end if;
			when GR=>
				trafficLights<="110011";
				if (mode/=3) then
					nxstate<=YR;
					delay<=delayGR(mode);
				else 
					nxstate<=YY;
					delay<=0;
				end if;
			when YR=>
				trafficLights<="101011";
				if (mode/=3) then
					nxstate<=RG;
					delay<=delayYR(mode);
				else 
					nxstate<=YY;
					delay<=0;
				end if;
			when YY=>
				trafficLights<="101101";
				if (mode/=3) then
					nxstate<=RG;
				else 
					nxstate<=NN;
					delay<=1;
				end if;
			when NN=>
				trafficLights<="111111";
				if (mode/=3) then
					nxstate<=RG;
				else 
					nxstate<=YY;
					delay<=0;
				end if;
			when others=>
				trafficLights<="011110";
				nxstate<=RG;
				delay<=delayRG(mode);
		end case;
	end process;
	
	----------------------------------End FSM----------------------------------------
end trafficlights;
