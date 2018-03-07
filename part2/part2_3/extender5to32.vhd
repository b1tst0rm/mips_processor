-- extender5to32.vhd
-------------------------------------------------------------------------
-- DESCRIPTION: Extends a 5 bit signal to a 32 bit signal depending on sign
-- Uses dataflow VHDL.

-- AUTHOR: Daniel Limanowski
-------------------------------------------------------------------------

library IEEE;
use IEEE.std_logic_1164.all;
use ieee.numeric_std.all;

entity extender5to32 is
port( input   : in std_logic_vector(4 downto 0);        -- 5 bit input
      sign    : in std_logic;                           -- 0 for unsigned, 1 for signed
      output  : out std_logic_vector(31 downto 0) );    -- 32 bit extended output
end extender5to32;

architecture dataflow of extender5to32 is
begin

    G1: for i in 0 to 4 generate
        output(i) <= input(i);
    end generate;

    G2: for i in 5 to 31 generate
        output(i) <= sign and input(4);
    end generate;

end dataflow;
