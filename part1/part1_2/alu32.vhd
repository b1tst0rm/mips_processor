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
              o_F        : out std_logic_vector(31 downto 0); -- Result
              o_CarryOut : out std_logic;                     -- carry out flag
              o_Overflow : out std_logic;                     -- overflow flag
              o_Zero     : out std_logic );                   -- zero flag
end alu32;

--- Define the architecture ---
architecture structure of alu32 is
    --- Component Declaration ---
    component and_32 is
        port( i_A : in  std_logic_vector(31 downto 0);
              i_B : in  std_logic_vector(31 downto 0);
              o_F : out std_logic_vector(31 downto 0));
    end component;

    component or_32 is
        port( i_A : in  std_logic_vector(31 downto 0);
              i_B : in  std_logic_vector(31 downto 0);
              o_F : out std_logic_vector(31 downto 0));
    end component;

    component addsub_struct_nbit is
        generic(N : integer := 4);
        port( i_A         : in std_logic_vector(N-1 downto 0);
              i_B         : in std_logic_vector(N-1 downto 0);
              i_nAdd_Sub  : in std_logic;
              o_Cout      : out std_logic;
              o_S         : out std_logic_vector(N-1 downto 0) );
    end component;

    component slt32 is
        port( i_SubF    : in std_logic_vector(31 downto 0); -- result from A-B
              i_OVF     : in std_logic; -- carry from add/sub
              o_F       : out std_logic_vector(31 downto 0) );
    end component;

    component barrel_shifter is
        port( i_data   : in std_logic_vector(31 downto 0);
              i_type   : in std_logic; -- 0 = logical, 1 = arithmetic
              i_dir    : in std_logic; -- 0 = right, 1 = left
              i_shamt  : in std_logic_vector(4 downto 0); -- shift amount
              o_data   : out std_logic_vector(31 downto 0) );
    end component;

    component nor_32 is
        port( i_A : in  std_logic_vector(31 downto 0);
              i_B : in  std_logic_vector(31 downto 0);
              o_F : out std_logic_vector(31 downto 0));
    end component;

    component xor_32 is
        port( i_A : in  std_logic_vector(31 downto 0);
              i_B : in  std_logic_vector(31 downto 0);
              o_F : out std_logic_vector(31 downto 0));
    end component;

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

    component ovf_detect is
        port( i_MSB_A      : in  std_logic; -- A's most significant bit
              i_MSB_B      : in  std_logic; -- B's most significant bit
              i_MSB_AddSub : in  std_logic; -- AbbSub result's most significant bit
              o_OVF        : out std_logic ); -- The overflow flag result
    end component;

    component zero_detect is
        port( i_mux0   : in  std_logic_vector(31 downto 0);
              i_mux1   : in  std_logic_vector(31 downto 0);
              i_mux2   : in  std_logic_vector(31 downto 0);
              i_mux3   : in  std_logic_vector(31 downto 0);
              i_mux4   : in  std_logic_vector(31 downto 0);
              i_mux5   : in  std_logic_vector(31 downto 0);
              i_mux6   : in  std_logic_vector(31 downto 0);
              o_Zero   : out std_logic ); -- The zero flag result
    end component;

    -- Intermediate signals fed into 7-1 ALUOP mux
    signal mux0_in, mux1_in, mux2_in, mux3_in, mux4_in, mux5_in, mux6_in
        : std_logic_vector(31 downto 0);

    signal s_ovf, s_zero, s_carry : std_logic; -- intermediate flag signals

begin

    AND_OP: and_32
        port map (i_A, i_B, mux0_in);

    OR_OP: or_32
        port map (i_A, i_B, mux1_in);

    ARITH_OP: addsub_struct_nbit
        generic map (32)
        port map (i_A, i_B, i_ALUOP(2), s_carry, mux2_in);

    -- Calculate the overflow flag
    OVF_FLAG: ovf_detect
        port map (i_A(31), i_B(31), mux2_in(31), s_ovf);

    SLT_OP: slt32
        port map (mux2_in, s_ovf, mux3_in);

    SHIFT_OP: barrel_shifter
        port map (i_B, i_ALUOP(1), i_ALUOP(0), i_A(4 downto 0), mux4_in);

    NOR_OP: nor_32
        port map (i_A, i_B, mux5_in);

    XOR_OP: xor_32
        port map (i_A, i_B, mux6_in);

    -- Calculate the zero flag
    ZERO_FLAG: zero_detect
        port map(mux0_in, mux1_in, mux2_in, mux3_in, mux4_in, mux5_in, mux6_in, s_zero);

    SELECT_OPERATION: mux_7to1
        port map (i_ALUOP, mux0_in, mux1_in, mux2_in, mux3_in, mux4_in, mux5_in, mux6_in,
            o_F);

    -- set the final flag values
    o_Overflow <= s_ovf;
    o_Zero <= s_zero;
    o_CarryOut <= s_carry;

end structure;
