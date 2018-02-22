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
    port( i_mux0   : in  std_logic_vector(31 downto 0);
          i_mux1   : in  std_logic_vector(31 downto 0);
          i_mux2   : in  std_logic_vector(31 downto 0);
          i_mux3   : in  std_logic_vector(31 downto 0);
          i_mux4   : in  std_logic_vector(31 downto 0);
          i_mux5   : in  std_logic_vector(31 downto 0);
          i_mux6   : in  std_logic_vector(31 downto 0);
          o_Zero   : out std_logic ); -- The zero flag result
end zero_detect;

architecture dataflow of zero_detect is
signal flag_result : std_logic_vector(31 downto 0);
begin
flag_result <= not (i_mux0 or i_mux1 or i_mux2 or i_mux3 or i_mux4 or i_mux5 or i_mux6);
o_Zero <= flag_result(0); -- zero flag set when all the mux inputs are zero
end dataflow;
