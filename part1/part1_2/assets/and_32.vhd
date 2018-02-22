-- and_32.vhd
-------------------------------------------------------------------------
-- DESCRIPTION: This file contains a 32 bit AND gate.

-- AUTHOR: Vishal Joel
-------------------------------------------------------------------------

library IEEE;
use IEEE.std_logic_1164.all;

entity and_32 is
    port( i_A : in  STD_LOGIC_VECTOR (31 downto 0);
          i_B : in  STD_LOGIC_VECTOR (31 downto 0);
          o_F : out  STD_LOGIC_VECTOR (31 downto 0));
end and_32;

architecture dataflow of and_32 is
begin
    o_F <= i_A and i_B;
end dataflow;
