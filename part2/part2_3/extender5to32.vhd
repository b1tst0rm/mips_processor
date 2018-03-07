library IEEE;
use IEEE.std_logic_1164.all;
use ieee.numeric_std.all;

entity extender5to32 is
port( input   : in std_logic_vector(4 downto 0);        -- 5 bit input
      sign    : in std_logic;                           -- 0 for unsigned, 1 for signed
      output  : out std_logic_vector(31 downto 0) );    -- 32 bit extended output
end entity extender5to32;

architecture dataflow of extender5to32 is
begin

    G1: for i in 0 to 4 generate
        output(i) <= input(i);
    end generate;

    G2: for i in 16 to 31 generate
        output(i) <= sign and input(15);
    end generate;

end dataflow;
