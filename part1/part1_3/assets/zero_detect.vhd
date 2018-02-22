-- zero_detect.vhd
-------------------------------------------------------------------------
-- DESCRIPTION: Zero flag detection implementation
-- using dataflow VHDL
---
-- AUTHOR: Daniel Limanowski
-------------------------------------------------------------------------

library IEEE;
use IEEE.std_logic_1164.all;

entity zero_detect is
    port( i_F    : in  std_logic_vector(31 downto 0); -- result selected from mux
          o_Zero : out std_logic ); -- The zero flag result
end zero_detect;

architecture dataflow of zero_detect is
begin
o_Zero <= '1' when i_F = "00000000000000000000000000000000" else
               '0'; -- sets signal to 1 if i_F = 0b0
end dataflow;
