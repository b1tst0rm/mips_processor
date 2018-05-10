-- and2_1bit.vhd
-------------------------------------------------------------------------
-- DESCRIPTION: Contains an implementation of a 2-input, 1-bit AND gate.
-------------------------------------------------------------------------

library IEEE;
use IEEE.std_logic_1164.all;

entity and2_1bit is
  port(i_A          : in std_logic;
       i_B          : in std_logic;
       o_F          : out std_logic);
end and2_1bit;

architecture dataflow of and2_1bit is
begin

  o_F <= i_A and i_B;

end dataflow;
