-- or2_1bit.vhd
-------------------------------------------------------------------------
-- DESCRIPTION: This file contains an implementation of a 1 bit, 2-input
-- OR gate.
-------------------------------------------------------------------------

library IEEE;
use IEEE.std_logic_1164.all;

entity or2_1bit is
  port(i_A          : in std_logic;
       i_B          : in std_logic;
       o_F          : out std_logic);
end or2_1bit;

architecture dataflow of or2_1bit is
begin

  o_F <= i_A or i_B;

end dataflow;
