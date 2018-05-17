library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_unsigned.all;

package my_data_types is
    type rational_number is array( natural range<>) of std_logic_vector(3 downto 0);
	type integer_number is array(natural range<>) of integer;
	
end my_data_types;