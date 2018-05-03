library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_arith.all;
use ieee.std_logic_unsigned.all;

entity PWM is
         
port(
     rst_n:in std_logic; 
     clk:in std_logic; 
     key_menu: in std_logic;
	 key_up: in std_logic;
	 key_down: in std_logic;
	 menu_state: buffer std_logic;
     pulse_out:buffer std_logic;
	 display:out std_logic
);

end entity PWM;

architecture behavior of PWM is


signal clk0:std_logic;
signal cnt1:integer range 0 to 80000;
signal cnt2:integer range 0 to 80000;
signal cycle_pulse:integer range 0 to 3;
signal duty_pulse:integer range 0 to 3;
signal cycle:integer range 0 to 80000;
signal dt: integer;
signal key_menu1: std_logic;
signal key_up1:std_logic;
signal key_down1:std_logic;
signal key_up1_ls:std_logic;
signal key_down1_ls:std_logic;

component CycleSampler
 port(
	clk: in std_logic;
	btnstate: in std_logic;
	keystate: out std_logic
	);

end component CycleSampler;

begin

P1:CycleSampler port map(clk,key_menu,key_menu1);
P2:CycleSampler port map(clk,key_up,key_up1);
P3:CycleSampler port map(clk,key_down,key_down1);

process(clk)
variable count0: integer range 0 to 200;
begin
    if(clk'event and clk='1') then
        if (count0=200) then
	        clk0 <= not clk0;
		    count0:=0;
		    else count0:=count0+1;
		 end if;
	 end if;
end process;

process(clk)
begin
    if(clk'event and clk='1') then
    key_up1_ls <= key_up1;
	key_down1_ls <= key_down1;
	end if;
end process;

---cnt1
process(clk0,rst_n,duty_pulse,cycle_pulse)
begin 
case duty_pulse is
	       when 0 => dt<=40;
	       when 1 => dt<=80;
	       when 2 => dt<=160;
	       when 3 => dt<=320;
end case; 
    if(rst_n='0') then
	    cnt1<=0;
	elsif(clk0'event and clk0='1') then
	   if(cnt1>=(cycle-dt) and (cnt1<cycle)) then  cnt1<=cycle;
	   elsif(cnt1=cycle) then  cnt1<=0;
	   else cnt1<=cnt1+dt;
	   end if;
	 end if;
end process;


process(clk0,rst_n,cycle_pulse)
variable direction: std_logic;
begin
case cycle_pulse is
        when 0 => cycle<=10000;
		when 1 => cycle<=20000;
		when 2 => cycle<=40000;
		when 3 => cycle<=80000;
end case;
    if(rst_n='0') then
		cnt2<=0;
	elsif(clk0'event and clk0='1') then
	    if (direction='0') then
		    if (cnt2>=(cycle-1)) then cnt2<=cycle; direction:='1';
			else cnt2<=cnt2+1;
			end if;
		end if;
		if(direction='1') then
		    if(cnt2=1) then cnt2<=0; direction:='0';
			else cnt2<= cnt2-1;
			end if;
		end if;
	end if;
end process;


---compare cnt1&cnt2

process(cnt1,cnt2,clk0)
begin
    if(clk0'event and clk0='0') then
	    if (cnt1>cnt2) then
		    pulse_out<='0';
		else pulse_out<='1';
	    end if;
		display<=pulse_out;
	end if;
end process;

process(key_menu1,rst_n)
begin
    if(rst_n='0') then
	    menu_state<='0';
	elsif(key_menu1'event and key_menu1='1') then
	    menu_state<=not menu_state;
	end if;
end process;


process(clk,rst_n)
begin
	if(rst_n='0') then
	    duty_pulse<=0;
		cycle_pulse<=0;
	elsif(rising_edge(clk)) then 
	 if(menu_state='0') then
	    if(key_up1_ls='1' and key_up1='0') then
		    if(cycle_pulse<3) then 
			    cycle_pulse<=cycle_pulse+1;
			end if;
		end if;
		if(key_down1_ls='1' and key_down1='0') then
		    if(cycle_pulse>0) then
			    cycle_pulse<=cycle_pulse-1;
			end if;
		end if;
	end if;
	
		if(menu_state='1') then
	   if(key_up1_ls='1' and key_up1='0') then
	       if(duty_pulse<3) then
		       duty_pulse<=duty_pulse+1;
		    end if;
		end if;
		if(key_down1_ls='1' and key_down1='0')then
		    if(duty_pulse>0) then
			    duty_pulse<=duty_pulse-1;
			end if;
		end if;
	end if;
  end if;
end process;

end architecture behavior;


	    

	    
	    

    
	    

			



		
	
 


