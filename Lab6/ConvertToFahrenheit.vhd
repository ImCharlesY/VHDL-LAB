library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_unsigned.all;
use ieee.std_logic_arith.all;
use work.my_data_types.all;

entity ConvertToFahrenheit is
port(
    DataOut: in integer_number(4 downto 0);
	clk: in std_logic;
	DataF: out integer_number(4 downto 0)
	);
end entity;

architecture behavior of ConvertToFahrenheit is

-----signal declaration
signal DataLastBit:integer;
signal Fahrenheit:integer:=0;
signal da,db,dc,dd,de,df,dg,dh:std_logic_vector(3 downto 0);

signal dh3,dh2,dh1,dh0: std_logic;
signal dh3_1,dh2_1,dh1_1,dh0_1: integer;
signal dg3,dg2,dg1,dg0: std_logic;
signal dg3_1,dg2_1,dg1_1,dg0_1: integer;

signal df3,df2,df1,df0: std_logic;
signal df3_1,df2_1,df1_1,df0_1: integer;
signal de3,de2,de1,de0: std_logic;
signal de3_1,de2_1,de1_1,de0_1: integer;

signal dd3,dd2,dd1,dd0: std_logic;
signal dd3_1,dd2_1,dd1_1,dd0_1: integer;
signal dc3,dc2,dc1,dc0: std_logic;
signal dc3_1,dc2_1,dc1_1,dc0_1: integer;

signal db3,db2,db1,db0: std_logic;
signal db3_1,db2_1,db1_1,db0_1: integer;
signal da3,da2,da1,da0: std_logic;
signal da3_1,da2_1,da1_1,da0_1: integer;

-----end signal declaration

begin
    Fahrenheit<=DataOut(4)*1800000+DataOut(3)*180000+DataOut(2)*18000+DataOut(1)*1800+DataOut(0)*180+DataLastBit*18+3200000;
	
process(clk)
variable tmp: integer range 0 to 99999999:=0;
begin
    if(clk'event and clk='1') then
	    if(tmp<Fahrenheit) then
		    if(da=9 and db=9 and dc=9 and dd=9 and de=9 and df=9 and dg=9 and dh=9 ) then
			    da<="0000";
				db<="0000";
				dc<="0000";
				dd<="0000";
				
				de<="0000";
				df<="0000";
				dg<="0000";
				dh<="0000";
				
				tmp:=0;
			elsif(da=9 and db=9 and dc=9 and dd=9 and de=9 and df=9 and dg=9) then
			    da<="0000";
				db<="0000";
				dc<="0000";
				dd<="0000";
				
				de<="0000";
				df<="0000";
				dg<="0000";
				dh<=dh+1; 
				
				tmp:=tmp+1;
				
			elsif(da=9 and db=9 and dc=9 and dd=9 and de=9 and df=9) then
			    da<="0000";
				db<="0000";
				dc<="0000";
				dd<="0000";
				
				de<="0000";
				df<="0000";
				dg<=dg+1;
			    
				tmp:=tmp+1;
				
			elsif(da=9 and db=9 and dc=9 and dd=9 and de=9) then
			    da<="0000";
				db<="0000";
				dc<="0000";
				dd<="0000";
				de<="0000";
			    df<=df+1;
				tmp:=tmp+1;
				
			elsif(da=9 and db=9 and dc=9 and dd=9) then
			    da<="0000";
				db<="0000";
				dc<="0000";
				dd<="0000";
				de<=de+1;
				tmp:=tmp+1;
			
			elsif(da=9 and db=9 and dc=9) then
			    da<="0000";
				db<="0000";
				dc<="0000";
				dd<=dd+1;
				tmp:=tmp+1;
				
			elsif(da=9 and db=9 ) then
			    da<="0000";
				db<="0000";
				dc<= dc+1;
				
				tmp:=tmp+1;
			elsif(da=9) then
			    da<="0000";
				db<= db+1;
				
				tmp:=tmp+1;
			else
			    da<=da+1;
				tmp:=tmp+1;
			end if;
		else
		    tmp:=0;
			 dh3<=dh(3);
			 dh3_1<=conv_integer(dh3);
			 dh2<=dh(2);
			 dh2_1<=conv_integer(dh2);
			 dh1<=dh(1);
			 dh1_1<=conv_integer(dh1);
			 dh0<=dh(0);
			 dh0_1<=conv_integer(dh0);
		     DataF(4)<=(dh3_1*8+dh2_1*4+dh1_1*2+dh0_1);
			 
			 dg3<=dg(3);
			 dg3_1<=conv_integer(dg3);
			 dg2<=dg(2);
			 dg2_1<=conv_integer(dg2);
			 dg1<=dg(1);
			 dg1_1<=conv_integer(dg1);
			 dg0<=dg(0);
			 dg0_1<=conv_integer(dg0);
		     DataF(3)<=(dg3_1*8+dg2_1*4+dg1_1*2+dg0_1);
			
			 df3<=df(3);
			 df3_1<=conv_integer(df3);
			 df2<=df(2);
			 df2_1<=conv_integer(df2);
			 df1<=df(1);
			 df1_1<=conv_integer(df1);
			 df0<=df(0);
			 df0_1<=conv_integer(df0);
		     DataF(2)<=(df3_1*8+df2_1*4+df1_1*2+df0_1);
			 
			 de3<=de(3);
			 de3_1<=conv_integer(de3);
			 de2<=de(2);
			 de2_1<=conv_integer(de2);
			 de1<=de(1);
			 de1_1<=conv_integer(de1);
			 de0<=de(0);
			 de0_1<=conv_integer(de0);
		     DataF(1)<=(de3_1*8+de2_1*4+de1_1*2+de0_1);
			 
			 dd3<=dd(3);
			 dd3_1<=conv_integer(dd3);
			 dd2<=dd(2);
			 dd2_1<=conv_integer(dd2);
			 dd1<=dd(1);
			 dd1_1<=conv_integer(dd1);
			 dd0<=dd(0);
			 dd0_1<=conv_integer(dd0);
		     DataF(0)<=(dd3_1*8+dd2_1*4+dd1_1*2+dd0_1);
			 
			 da<="0000";
		     db<="0000";
			 dc<="0000";
		     dd<="0000";
			 de<="0000";
		     df<="0000";
			 dg<="0000";
		     dh<="0000";
			 
		     end if;
	    end if;
end process;

end behavior;

			
			
	    
		
	    


