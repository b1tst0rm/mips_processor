-- branch_jump_logic.vhd
-------------------------------------------------------------------------
-- DESCRIPTION: Branch/Jump logic module using structural VHDL
--
-- AUTHOR: Daniel Limanowski
-------------------------------------------------------------------------

library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;

entity branch_jump_logic is
    port( i_BEQ              : in std_logic;
          i_BNE              : in std_logic;
          i_J                : in std_logic;
          i_JAL              : in std_logic;
          i_JR               : in std_logic;
          i_Zero_Flag        : in std_logic;
          i_Instruc_25to0    : in std_logic_vector(25 downto 0); -- the current instruction
          i_RD1              : in std_logic_vector(31 downto 0); -- for JR
          i_PCPlus4          : in std_logic_vector(31 downto 0);
          i_IMM              : in std_logic_vector(31 downto 0); -- Instruction(25 downto 0) sign-extended
          o_BJ_Address       : out std_logic_vector(31 downto 0);
          o_PCSrc            : out std_logic;
          o_BranchTaken      : out std_logic; -- 1 when branch (beq or bne) is taken, 0 if not taken
          o_Branch           : out std_logic );  -- 1 if the instruction is currently beq OR bne
end branch_jump_logic;

architecture structural of branch_jump_logic is
    component fulladder_32bit is
        port( i_A    : in std_logic_vector(31 downto 0);
              i_B    : in std_logic_vector(31 downto 0);
              i_Cin  : in std_logic;
              o_Cout : out std_logic;
              o_S    : out std_logic_vector(31 downto 0) );
    end component;

    component mux2to1_32bit is
        port( i_X   : in std_logic_vector(31 downto 0);
              i_Y   : in std_logic_vector(31 downto 0);
              i_SEL : in std_logic;
              o_OUT   : out std_logic_vector(31 downto 0) );
    end component;

    component or2_1bit is
      port(i_A          : in std_logic;
           i_B          : in std_logic;
           o_F          : out std_logic);
    end component;

    component and2_1bit is
      port(i_A          : in std_logic;
           i_B          : in std_logic;
           o_F          : out std_logic);
    end component;

    component sel_BEQ_BNE is
        port( i_Zero_Flag : in std_logic;
              i_Select    : in std_logic_vector(1 downto 0);
              o_F         : out std_logic );
    end component;

    signal s_Cout_IMM, s_AND_Out, s_OR_J, s_OR_BEQBNE, s_sel_br_out : std_logic;
    signal s_AddIMM_Out, s_Mux1_Out, s_Mux2_Out, s_Mux3_Out : std_logic_vector(31 downto 0);
    signal s_IMM_Shift, s_j_addr : std_logic_vector(31 downto 0);
    signal s_instruc_sl2 : std_logic_vector(27 downto 0);
    signal s_BEQBNE : std_logic_vector(1 downto 0);

begin

    s_IMM_Shift <= i_IMM(29 downto 0) & "00"; -- shift i_IMM left by 2 bits
    s_BEQBNE <= i_BEQ & i_BNE; -- selector for sel_BEQ_BNE
    s_instruc_sl2 <= i_Instruc_25to0 & "00"; -- shift left 2 bits
    s_j_addr <= i_PCPlus4(31 downto 28) & s_instruc_sl2; -- 32 bit signal via concatentation

    o_BJ_Address <= s_Mux3_Out;
    o_PCSrc <= '1' when (i_BEQ = '1' or i_BNE = '1' or i_JAL = '1' or i_J = '1' or i_JR = '1') else
               '0';

    o_BranchTaken <= s_AND_Out; -- when the AND_Out value is 1, this means we have branched.
    o_Branch <= s_OR_BEQBNE;

    add_IMM: fulladder_32bit
        port map (i_PCPlus4, s_IMM_Shift, '0', s_Cout_IMM, s_AddIMM_Out);

    mux1: mux2to1_32bit
        port map (i_PCPlus4, s_AddIMM_Out, s_AND_Out, s_Mux1_Out);

    mux2: mux2to1_32bit
        port map (s_Mux1_Out, s_j_addr, s_OR_J, s_Mux2_Out);

    mux3: mux2to1_32bit
        port map (s_Mux2_Out, i_RD1, i_JR, s_Mux3_Out);

    or_BEQ_BNE: or2_1bit
        port map (i_BEQ, i_BNE, s_OR_BEQBNE);

    and_Z: and2_1bit
        port map (s_OR_BEQBNE, s_sel_br_out, s_AND_Out);

    selBEQBNE: sel_BEQ_BNE
        port map (i_Zero_Flag, s_BEQBNE, s_sel_br_out);

    or_J: or2_1bit
        port map (i_J, i_JAL, s_OR_J);

end structural;
