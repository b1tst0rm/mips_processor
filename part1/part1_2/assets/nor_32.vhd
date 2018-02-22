-- and32.vhd
-------------------------------------------------------------------------
-- DESCRIPTION: This file contains a 32 bit NOR gate.

-- AUTHOR: Vishal Joel
-------------------------------------------------------------------------

library IEEE;
use IEEE.std_logic_1164.all;

entity nor_32 is
    port( i_A : in  STD_LOGIC_VECTOR (31 downto 0);
          i_B : in  STD_LOGIC_VECTOR (31 downto 0);
          o_F : out  STD_LOGIC_VECTOR (31 downto 0));
end nor_32;

architecture dataflow of nor_32 is
begin
    o_F <= i_A nor i_B;
end dataflow;
