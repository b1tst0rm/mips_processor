-- xor2_1bit.vhd
-------------------------------------------------------------------------
-- DESCRIPTION: This file contains an implementation of a 2-input, 1-bit
-- XOR gate.
-------------------------------------------------------------------------

library IEEE;
use IEEE.std_logic_1164.all;

entity xor2_1bit is
  port( i_A          : in std_logic;
        i_B          : in std_logic;
        o_F          : out std_logic );
end xor2_1bit;

architecture dataflow of xor2_1bit is

begin

  o_F <= i_A xor i_B;

end dataflow;
