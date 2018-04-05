-- and2_32bit.vhd
-------------------------------------------------------------------------
-- DESCRIPTION: This file contains a 2-input, 32 bit AND gate.

-- AUTHOR: Vishal Joel
-------------------------------------------------------------------------

library IEEE;
use IEEE.std_logic_1164.all;

entity and2_32bit is
    port( i_A : in  std_logic_vector(31 downto 0);
          i_B : in  std_logic_vector(31 downto 0);
          o_F : out std_logic_vector(31 downto 0) );
end and2_32bit;

architecture dataflow of and2_32bit is
begin

    o_F <= i_A and i_B;

end dataflow;
