-- alu32.vhd
-------------------------------------------------------------------------
-- DESCRIPTION: 32-bit (MIPS word) Arithmetic-Logical-Unit (ALU)
-- using structural VHDL
--
-- A multiplexor selects between several different instructions
-- ALUOP is the selector for the muxes
-- OPS supported: add/sub (signed and unsigned), slt, and, or, xor, nor, sll, srl, and sra.
-- AUTHOR: Daniel Limanowski
-------------------------------------------------------------------------

library IEEE;
use IEEE.std_logic_1164.all;

entity alu32 is
        port( i_A        : in  std_logic_vector(31 downto 0); -- Operand A
              i_B        : in  std_logic_vector(31 downto 0); -- Operand B
              i_ALUOP    : in  std_logic_vector(2  downto 0); -- minimum-wdith control
              o_F        : out std_logic_vector(31 downto 0); -- Result
              o_CarryOut : out std_logic;                     -- carry out flag
              o_Overflow : out std_logic;                     -- overflow flag
              o_Zero     : out std_logic );                   -- zero flag
end alu32;

--- Define the architecture ---
architecture structure of alu32 is
    --- Component Declaration ---
    component mux_12to1 is
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
    end component;

begin

-- PLAN: do NOT implement one bit ALUs
-- Have 12-1 mux to select between the 12 different 32-bit operations and set F (Result)
-- to the output of the mux.

-- How to do addu vs add????????????

    --SELECT_OPERATION: mux_12to1
    --    port map();

end structure;
