-- reverse order.vhd
-------------------------------------------------------------------------
-- DESCRIPTION: 32-bit (MIPS word) order reverser.
-- Takes in 32 bit vector and outputs o_data(i) = i_data(31 - i)
--
-- AUTHOR: Daniel Limanowski
-------------------------------------------------------------------------

library IEEE;
use IEEE.std_logic_1164.all;

entity reverse_order is
    port( i_data   : in std_logic_vector(31 downto 0);
          o_data   : out std_logic_vector(31 downto 0) );
end reverse_order;

architecture structure of reverse_order is

begin

    process (i_data)
    begin
        for i in 0 to 31 loop
            o_data(i) <= i_data(31 - i);
        end loop;
    end process;

end structure;
