library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_unsigned.all;
use ieee.std_logic_arith.all;
use work.my_data_types.all;


entity ConvertToDecimal is
port(
    Data: in std_logic_vector(15 downto 0);
	clk: in std_logic;
	DataLastBit:out integer;
	DataOut: out integer_number(4 downto 0)
	--DataOut_integer: out integer;
	--DataOut_decimal: out integer;
	);
end entity;

architecture behavior of ConvertToDecimal is


------signal declaration
--signal tmp: integer :=0;
signal DataOut_integer: integer:=0;
signal DataOut_decimal: integer:=0;

signal Data0_1: integer:=0;
signal Data1_1: integer:=0;
signal Data2_1: integer:=0;
signal Data3_1: integer:=0;
signal Data4_1: integer:=0;
signal Data5_1: integer:=0;
signal Data6_1: integer:=0;
signal Data7_1: integer:=0;
signal Data8_1: integer:=0;
signal Data9_1: integer:=0;
signal Data10_1: integer;

signal Data0: std_logic;
signal Data1: std_logic;
signal Data2: std_logic;
signal Data3: std_logic;
signal Data4: std_logic;
signal Data5: std_logic;
signal Data6: std_logic;
signal Data7: std_logic;
signal Data8: std_logic;
signal Data9: std_logic;
signal Data10: std_logic;

signal da,db:std_logic_vector(3 downto 0);
signal db3,db2,db1,db0: std_logic;
signal db3_1,db2_1,db1_1,db0_1: integer;
signal da3,da2,da1,da0: std_logic;
signal da3_1,da2_1,da1_1,da0_1: integer;


signal d1,d2,d3,d4:std_logic_vector(3 downto 0);
signal d13,d12,d11,d10: std_logic;
signal d13_1,d12_1,d11_1,d10_1: integer;
signal d23,d22,d21,d20: std_logic;
signal d23_1,d22_1,d21_1,d20_1: integer;
signal d33,d32,d31,d30: std_logic;
signal d33_1,d32_1,d31_1,d30_1: integer;
signal d43,d42,d41,d40: std_logic;
signal d43_1,d42_1,d41_1,d40_1: integer;




----end signal declaration

----get real integer part of data;
----get decimal part of data multiplied by 10000
----so we get DataOut_integer range from 0 to 127;
----and DataOut_decinal range from 0 to 9325;
begin
process(clk)
begin
   if(clk'event and clk='1') then
   
      Data0<=Data(0);
	  Data0_1<=conv_integer(Data0);
	  Data1<=Data(1);
	  Data1_1<=conv_integer(Data1);
	  Data2<=Data(2);
	  Data2_1<=conv_integer(Data2);
	  Data3<=Data(3);
	  Data3_1<=conv_integer(Data3);
	  Data4<=Data(4);
	  Data4_1<=conv_integer(Data4);
	  Data5<=Data(5);
	  Data5_1<=conv_integer(Data5);
	  Data6<=Data(6);
	  Data6_1<=conv_integer(Data6);
	  Data7<=Data(7);
	  Data7_1<=conv_integer(Data7);
	  Data8<=Data(8);
	  Data8_1<=conv_integer(Data8);
	  Data9<=Data(9);
	  Data9_1<=conv_integer(Data9);
	  Data10<=Data(10);
	  Data10_1<=conv_integer(Data10);

     -- tmp <=((Data10_1)*1024+(Data9_1)*512+(Data8_1)*256+(Data7_1)*128+(Data6_1)*64+Data5_1*32+Data4_1*16+Data3_1*8+Data2_1*4+Data1_1*2+Data0_1);
      DataOut_integer<=(Data10_1*64+Data9_1*32+Data8_1*16+Data7_1*8+Data6_1*4+Data5_1*2+Data4_1);
	  DataOut_decimal<=(Data3_1*5000+Data2_1*2500+Data1_1*1250+Data0_1*625);
    end if;
end process;

----convert DataOut_integer to DataOut(4)&DataOut(3) in std_logic_vector form
process(clk)
variable tmp: integer range 0 to 99:=0;
begin
    if(clk'event and clk='1') then
	    if(tmp<DataOut_integer) then
		    if(da=9 and db=9) then
			    da<="0000"; 
				db<="0000";
				tmp:=0;
			elsif(da=9) then
				    da<="0000";
					db<=db+1;
					tmp:=tmp+1;
			else da<=da+1;
			     tmp:=tmp+1;
			end if;
		else 
		     db3<=db(3);
			 db3_1<=conv_integer(db3);
			 db2<=db(2);
			 db2_1<=conv_integer(db2);
			 db1<=db(1);
			 db1_1<=conv_integer(db1);
			 db0<=db(0);
			 db0_1<=conv_integer(db0);
		     DataOut(4)<=(db3_1*8+db2_1*4+db1_1*2+db0_1);
			 
			 da3<=da(3);
			 da3_1<=conv_integer(da3);
			 da2<=da(2);
			 da2_1<=conv_integer(da2);
			 da1<=da(1);
			 da1_1<=conv_integer(da1);
			 da0<=da(0);
			 da0_1<=conv_integer(da0);
		     DataOut(3)<=(da3_1*8+da2_1*4+da1_1*2+da0_1);

		     da<="0000";
		     db<="0000";
			 tmp:=0;
		end if;
	end if;
end process;




---connvert DataOut_decimal to DataOut(2),DataOut(1)&DataOut(0) in std_logic_vector form
process(clk)
variable tmp1: integer range 0 to 9999:=0;
begin
    if(clk'event and clk='1') then
	    if(tmp1<DataOut_decimal) then
		    if(d1=9 and d2=9 and d3=9 and d4=9) then
			    d1<="0000";
				d2<="0000";
				d3<="0000";
				d4<="0000";
				tmp1:=0;
			elsif(d1=9 and d2=9 and d3=9) then
			    d1<="0000";
				d2<="0000";
				d3<="0000";
				d4<=d4+1;
				tmp1:=tmp1+1;
			elsif(d1=9 and d2=9) then
			    d1<="0000";
				d2<="0000";
				d3<=d3+1;
				tmp1:=tmp1+1;
			elsif(d1=9) then
			    d1<="0000";
			    d2<=d2+1;
				tmp1:=tmp1+1;
			else
			    d1<=d1+1;
				tmp1:=tmp1+1;
			end if;
		else
		    tmp1:=0;
			 d43<=d4(3);
			 d43_1<=conv_integer(d43);
			 d42<=d4(2);
			 d42_1<=conv_integer(d42);
			 d41<=d4(1);
			 d41_1<=conv_integer(d41);
			 d40<=d4(0);
			 d40_1<=conv_integer(d40);
		     DataOut(2)<=(d43_1*8+d42_1*4+d41_1*2+d40_1);
			 
			 d33<=d3(3);
			 d33_1<=conv_integer(d33);
			 d32<=d3(2);
			 d32_1<=conv_integer(d32);
			 d31<=d3(1);
			 d31_1<=conv_integer(d31);
			 d30<=d3(0);
			 d30_1<=conv_integer(d30);
		     DataOut(1)<=(d33_1*8+d32_1*4+d31_1*2+d30_1);
			 
			 d23<=d2(3);
			 d23_1<=conv_integer(d23);
			 d22<=d2(2);
			 d22_1<=conv_integer(d22);
			 d21<=d2(1);
			 d21_1<=conv_integer(d21);
			 d20<=d2(0);
			 d20_1<=conv_integer(d20);
		     DataOut(0)<=(d23_1*8+d22_1*4+d21_1*2+d20_1);
			
			--DataOut(2)<=d4;
			--DataOut(1)<=d3;
			--DataOut(0)<=d2;
			
			 d13<=d1(3);
			 d13_1<=conv_integer(d13);
			 d12<=d1(2);
			 d12_1<=conv_integer(d12);
			 d11<=d1(1);
			 d11_1<=conv_integer(d11);
			 d10<=d1(0);
			 d10_1<=conv_integer(d10);
		     DataLastBit <=(d13_1*8+d12_1*4+d11_1*2+d10_1);
			
			
			d1<="0000";
			d2<="0000";
			d3<="0000";
			d4<="0000";
		end if;
	end if;
end process;
	  
end behavior;
