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
     pulse_out:out std_logic
);

end entity PWM;

architecture behavior of PWM is


signal clk0:std_logic;
signal cnt1:integer range 0 to 8000;
signal cnt2:integer range 0 to 8000;
signal cycle_pulse:integer range 0 to 3;
signal duty_pulse:integer range 0 to 3;
signal cycle:integer range 1000 to 8000;
signal dt: integer range 10 to 80;

begin

process(clk)
variable count0: integer range 0 to 600;
begin
    if(clk'event and clk='1') then
        if (count0=600) then
	        clk0 <= not clk0;
		    count0:=0;
		    else count0:=count0+1;
		 end if;
	 end if;
end process;

process(clk0,rst_n,duty_pulse,cycle_pulse)
begin 
    if(rst_n='1') then
	    cnt1<=0;
	elsif(clk0'event and clk0='1') then
	   case duty_pulse is
	       when 0 => dt<=10;
	       when 1 => dt<=20;
	       when 2 => dt<=40;
	       when 3 => dt<=80;
	   end case; 
	   if(cnt1>=(cycle-(cycle mod dt)) and cnt1<cycle) then cnt1<=cycle;
	   end if;
	   if(cnt1=cycle) then cnt1<=0;
	   end if;
	   cnt1<=cnt1+dt;
	 end if;
end process;

process(clk0,rst_n,cycle_pulse)
variable direction: std_logic;
begin
case cycle_pulse is
        when 0 => cycle<=1000;
		when 1 => cycle<=2000;
		when 2 => cycle<=4000;
		when 3 => cycle<=8000;
end case;
    if(rst_n='1') then
	cnt2<=0;
	elsif(clk0'event and clk0='1') then
	    if (direction='0') then
		    if (cnt2=(cycle-1)) then cnt2<=cycle; direction:='1';
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

process(cnt1,cnt2,clk0)
begin
    if(clk0'event and clk0='1') then
	    if cnt1>cnt2 then
		    pulse_out<='1';
		else pulse_out<='0';
	    end if;
	end if;
end process;

process(key_menu,rst_n)
begin
    if(rst_n='1') then
	    menu_state<='0';
	elsif(key_menu'event and key_menu='1') then
	    menu_state<=not menu_state;
	end if;
end process;

process(menu_state,key_up,key_down)
begin
    if(menu_state='0') then
	    if(key_up'event and key_up='1') then
		    if(cycle_pulse<3) then 
			    cycle_pulse<=cycle_pulse+1;
			end if;
		end if;
		if(key_down'event and key_down='1') then
		    if(cycle_pulse>0) then
			    cycle_pulse<=cycle_pulse-1;
			end if;
		end if;
	end if;
	
	if(menu_state='1') then
	   if(key_up'event and key_up='1') then
	       if(duty_pulse<3) then
		       duty_pulse<=duty_pulse+1;
		    end if;
		end if;
		if(key_down'event and key_down='1')then
		    if(duty_pulse>0) then
			    duty_pulse<=duty_pulse-1;
			end if;
		end if;
	end if;
end process;

end architecture behavior;


	    

	    
	    

    
	    

			



		
	
 


