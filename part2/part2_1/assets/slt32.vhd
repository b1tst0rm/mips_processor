-- slt32.vhd
-------------------------------------------------------------------------
-- DESCRIPTION: Set-On-Less-Than logic implementation
-- using dataflow VHDL
---
-- AUTHOR: Daniel Limanowski
-------------------------------------------------------------------------

library IEEE;
use IEEE.std_logic_1164.all;

entity slt32 is
    port( i_SubF    : in std_logic_vector(31 downto 0); -- result from A-B
          i_OVF     : in std_logic; -- carry from add/sub
          o_F       : out std_logic_vector(31 downto 0) );
end slt32;

architecture dataflow of slt32 is
begin
-- Set on less than is true when operand A - operand B is negative.
-- This occurs in two cases: 1) Overflow flag is set to zero and MSB of the
--                               subtraction result is 1 (negative)
--                           2) Overflow flag is set to one (result is negative)
-- To account for OVF, we XOR the flag with the MSB of the subtraction output
-- to see if our arithmetic is "right"...if not, we need to account for this
o_F(0) <= i_SubF(31) XOR i_OVF;

o_F(31 downto 1) <= (others => '0'); -- set all other bits to '0' always
end dataflow;
