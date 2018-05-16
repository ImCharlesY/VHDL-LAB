library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_unsigned.all;
use ieee.std_logic_arith.all;
use work.my_data_types.all;

entity ConvertToDecimal is
port(
    Data: in std_logic_vector(15 downto 0);
	clk: in std_logic;
	DataOut: out rational_number(1 downto 0)
	--DataOut_integer: out integer;
	--DataOut_decimal: out integer;
	);
end entity;

architecture behavior of ConvertToDecimal is
------signal declaration
signal tmp: integer :=0;
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

--signal Data1: integer :=0;

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

      tmp <=((Data10_1)*1024+(Data9_1)*512+(Data8_1)*256+(Data7_1)*128+(Data6_1)*64+Data5_1*32+Data4_1*16+Data3_1*8+Data2_1*4+Data1_1*2+Data0_1);
      DataOut_integer<=(Data10_1*64+Data9_1*32+Data8_1*16+Data7_1*8+Data6_1*4+Data5_1*2+Data4_1);
	  DataOut_decimal<=(Data3_1*5000+Data2_1*2500+Data1_1*1250+Data0_1*625);
    end if;
end process;

----dataout
process(clk)
begin
    if(clk'event and clk='1') then
	  DataOut(1)<=DataOut_integer;
	  DataOut(0)<=DataOut_decimal;
	 end if;
end process;

end behavior;