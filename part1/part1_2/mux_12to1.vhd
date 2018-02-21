-- mux_12to1.vhd
-------------------------------------------------------------------------
-- DESCRIPTION: 12:1 multiplexor implementation using dataflow
-- VHDL

-- For use in MIPS32 ALU (selecting the ALUOP)

-- AUTHOR: Daniel Limanowski
-------------------------------------------------------------------------

library IEEE;
use IEEE.std_logic_1164.all;

entity mux_12to1 is
    port( i_SEL : in std_logic_vector(3 downto 0); -- 4 bit selector
          i_0   : in std_logic_vector(31 downto 0); -- first of 12 inputs to mux
          i_1   : in std_logic_vector(31 downto 0);
          i_2   : in std_logic_vector(31 downto 0);
          i_3   : in std_logic_vector(31 downto 0);
          i_4   : in std_logic_vector(31 downto 0);
          i_5   : in std_logic_vector(31 downto 0);
          i_6   : in std_logic_vector(31 downto 0);
          i_7   : in std_logic_vector(31 downto 0);
          i_8   : in std_logic_vector(31 downto 0);
          i_9   : in std_logic_vector(31 downto 0);
          i_10  : in std_logic_vector(31 downto 0);
          i_11  : in std_logic_vector(31 downto 0);
          o_F   : out std_logic_vector(31 downto 0) );  -- the selected output
end mux_12to1;

architecture dataflow of mux_12to1 is
begin

with i_SEL select
    o_F <= i_0  when "0000",
           i_1  when "0001",
           i_2  when "0010",
           i_3  when "0011",
           i_4  when "0100",
           i_5  when "0101",
           i_6  when "0110",
           i_7  when "0111",
           i_8  when "1000",
           i_9  when "1001",
           i_10 when "1010",
           i_11 when "1011",
           (others => '0') when others;

end dataflow;
