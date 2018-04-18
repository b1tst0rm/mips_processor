-- ones_comp_32bit.vhd
-------------------------------------------------------------------------
-- DESCRIPTION: This file contains an implementation of a one's
-- complementer using structural modeling.
--
-- AUTHOR: Daniel Limanowski
-------------------------------------------------------------------------

library IEEE;
use IEEE.std_logic_1164.all;

entity ones_comp_32bit is
    port( i_Bits     : in std_logic_vector(31 downto 0);
          o_OnesComp : out std_logic_vector(31 downto 0) );
end ones_comp_32bit;

architecture structure of ones_comp_32bit is
    component not_1bit is
      port(i_A          : in std_logic;
           o_F          : out std_logic);
    end component;

begin

-- Generic for loop goes through each individual signal and inverts it.
GENFOR: for i in 0 to 31 generate
    inv_i: not_1bit
        port map(i_Bits(i), o_OnesComp(i));
end generate;

end structure;
