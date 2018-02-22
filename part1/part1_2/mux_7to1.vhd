-- mux_7to1.vhd
-------------------------------------------------------------------------
-- DESCRIPTION: 9:1 multiplexor implementation using dataflow
-- VHDL

-- For use in MIPS32 ALU (selector is the ALUOP)

-- AUTHOR: Daniel Limanowski
-------------------------------------------------------------------------

library IEEE;
use IEEE.std_logic_1164.all;

entity mux_7to1 is
    port( i_SEL : in std_logic_vector(3 downto 0); -- 4 bit selector (ALUOP)
          i_0   : in std_logic_vector(31 downto 0); -- first of 9 inputs to mux
          i_1   : in std_logic_vector(31 downto 0);
          i_2   : in std_logic_vector(31 downto 0);
          i_3   : in std_logic_vector(31 downto 0);
          i_4   : in std_logic_vector(31 downto 0);
          i_5   : in std_logic_vector(31 downto 0);
          i_6   : in std_logic_vector(31 downto 0);
          o_F   : out std_logic_vector(31 downto 0) );  -- the selected output
end mux_7to1;

architecture dataflow of mux_7to1 is
begin

with i_SEL select
    o_F <= i_0  when "0000", -- add  (COMES FROM ADD/SUB UNIT)
           i_0  when "0001", -- addu (COMES FROM ADD/SUB UNIT)
           i_0  when "0010", -- sub  (COMES FROM ADD/SUB UNIT)
           i_0  when "0011", -- subu (COMES FROM ADD/SUB UNIT)
           i_1  when "0100", -- and
           i_2  when "0101", -- or
           i_3  when "0110", -- xor
           i_4  when "0111", -- nor
           i_5  when "1000", -- sll (COMES FROM BARREL SHIFTER)
           i_5  when "1001", -- srl (COMES FROM BARREL SHIFTER)
           i_5  when "1010", -- sra (COMES FROM BARREL SHIFTER)
           i_6  when "1011", -- slt
           (others => '0') when others;

end dataflow;