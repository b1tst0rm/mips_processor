-- extend_5to32bit.vhd
-------------------------------------------------------------------------
-- DESCRIPTION: Extends a 5 bit signal to a 32 bit signal depending on sign.
-- Uses dataflow VHDL.

-- AUTHOR: Daniel Limanowski
-------------------------------------------------------------------------

library IEEE;
use IEEE.std_logic_1164.all;
use ieee.numeric_std.all;

entity extend_5to32bit is
port( i_input   : in std_logic_vector(4 downto 0);     -- 5 bit input
      i_sign    : in std_logic;                        -- 0 for unsigned, 1 for signed
      o_output  : out std_logic_vector(31 downto 0) ); -- 32 bit extended output
end extend_5to32bit;

architecture dataflow of extend_5to32bit is

begin
    G1: for i in 0 to 4 generate
        o_output(i) <= i_input(i);
    end generate;

    G2: for i in 5 to 31 generate
        o_output(i) <= i_sign and i_input(4);
    end generate;

end dataflow;
