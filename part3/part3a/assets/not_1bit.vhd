-- not_1bit.vhd
-------------------------------------------------------------------------
-- DESCRIPTION: This file contains an implementation of a 1-input NOT
-- gate using dataflow VHDL.
--
-- AUTHOR: Daniel Limanowski
-------------------------------------------------------------------------

library IEEE;
use IEEE.std_logic_1164.all;

entity not_1bit is
  port(i_A          : in std_logic;
       o_F          : out std_logic);
end not_1bit;

architecture dataflow of not_1bit is
begin

  o_F <= not i_A;

end dataflow;
