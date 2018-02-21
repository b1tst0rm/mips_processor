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
              i_ALUOP    : in  std_logic_vector(3  downto 0); -- minimum-wdith control
              i_SHAMT    : in  std_logic_vector(3 downto 0);  -- Shift amount for barrel shifter
              o_F        : out std_logic_vector(31 downto 0); -- Result
              o_CarryOut : out std_logic;                     -- carry out flag
              o_Overflow : out std_logic;                     -- overflow flag
              o_Zero     : out std_logic );                   -- zero flag
end alu32;

--- Define the architecture ---
architecture structure of alu32 is
    --- Component Declaration ---
    component mux_7to1 is
        port( i_SEL : in std_logic_vector(3 downto 0); -- 4 bit selector (ALUOP)
              i_0   : in std_logic_vector(31 downto 0); -- first of 9 inputs to mux
              i_1   : in std_logic_vector(31 downto 0);
              i_2   : in std_logic_vector(31 downto 0);
              i_3   : in std_logic_vector(31 downto 0);
              i_4   : in std_logic_vector(31 downto 0);
              i_5   : in std_logic_vector(31 downto 0);
              i_6   : in std_logic_vector(31 downto 0);
              o_F   : out std_logic_vector(31 downto 0) );  -- the selected output
    end component;

    component addsub_struct_nbit is
        generic(N : integer := 4);
        port( i_A         : in std_logic_vector(N-1 downto 0);
              i_B         : in std_logic_vector(N-1 downto 0);
              i_nAdd_Sub  : in std_logic;
              o_Cout      : out std_logic;
              o_S         : out std_logic_vector(N-1 downto 0) );
    end component;

    signal s_mux_0_in : std_logic_vector(31 downto 0);

begin

    ADD_SUB: addsub_struct_nbit
        GENERIC MAP (32)
        PORT MAP(i_A, i_B, i_ALUOP(1), o_CarryOut, s_mux_0_in);

  --  SELECT_OPERATION: mux_7to1
        --port map (i_ALUOP)

end structure;
