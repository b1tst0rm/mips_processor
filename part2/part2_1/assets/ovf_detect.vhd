-- ovf_detect.vhd
-------------------------------------------------------------------------
-- DESCRIPTION: Overflow (OVF) flag detection implementation
-- using dataflow VHDL
---
-- AUTHOR: Daniel Limanowski
-------------------------------------------------------------------------

library IEEE;
use IEEE.std_logic_1164.all;

entity ovf_detect is
    port( i_MSB_A      : in  std_logic; -- A's most significant bit
          i_MSB_B      : in  std_logic; -- B's most significant bit
          i_MSB_AddSub : in  std_logic; -- AbbSub result's most significant bit
          o_OVF        : out std_logic ); -- The overflow flag result
end ovf_detect;

architecture dataflow of ovf_detect is
begin
-- Simply put, overflow occurs when the MSB of A and B equal each other but do
-- NOT equal the MSB of the result of the arithmetic op (add/sub)
o_OVF <= '1' when (i_MSB_A = i_MSB_B) and (i_MSB_A /= i_MSB_AddSub) else
         '0';
end dataflow;
