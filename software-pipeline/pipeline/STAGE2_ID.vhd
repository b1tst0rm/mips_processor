-- STAGE2_ID.vhd
-------------------------------------------------------------------------
-- DESCRIPTION: Instruction Decode logic module for the pipeline processor.
-- This file represents all of the logic inside the second of five stages
-- in a pipelined MIPS processor.
--
-- AUTHOR: Daniel Limanowski
-------------------------------------------------------------------------

library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;

entity instruction_decode is
    port( i_Reset         : in std_logic;
          i_Clock         : in std_logic;
          i_Instruction   : in std_logic_vector(31 downto 0);
          i_PCPlus4       : in std_logic_vector(31 downto 0);
          i_WriteData     : in std_logic_vector(31 downto 0); -- comes from Writeback stage
          i_WriteReg      : in std_logic_vector(4 downto 0);  -- comes from Writeback stage
          i_RegWriteEn    : in std_logic;                     -- comes from Writeback stage
          i_JAL_WB        : in std_logic;                     -- comes from Writeback stage
          o_PCPlus4       : out std_logic_vector(31 downto 0);
          o_JAL           : out std_logic;
          o_SHAMT         : out std_logic_vector(31 downto 0);
          o_BJ_Address    : out std_logic_vector(31 downto 0);
          o_PCSrc         : out std_logic;
          o_Immediate     : out std_logic_vector(31 downto 0);
          o_WR            : out std_logic_vector(4 downto 0);
          o_RegWriteEn    : out std_logic;
          o_RD1           : out std_logic_vector(31 downto 0);
          o_RD2           : out std_logic_vector(31 downto 0);
          o_ALUOP         : out std_logic_vector(3 downto 0);
          o_Sel_Mux2      : out std_logic;
          o_Mem_To_Reg    : out std_logic;
          o_MemWrite      : out std_logic;
          o_ALUSrc        : out std_logic );
end instruction_decode;

architecture structural of instruction_decode is
    component branch_jump_logic is
        port( i_BEQ              : in std_logic;
              i_BNE              : in std_logic;
              i_J                : in std_logic;
              i_JAL              : in std_logic;
              i_JR               : in std_logic;
              i_Zero_Flag        : in std_logic;
              i_Instruc_25to0    : in std_logic_vector(25 downto 0);
              i_RD1              : in std_logic_vector(31 downto 0);
              i_PCPlus4          : in std_logic_vector(31 downto 0);
              i_IMM              : in std_logic_vector(31 downto 0);
              o_BJ_Address       : out std_logic_vector(31 downto 0);
              o_PCSrc            : out std_logic );
    end component;

    component control is
        port( i_Instruction    : in std_logic_vector(31 downto 0);
              o_Sel_ALU_A_Mux2 : out std_logic; -- set to 1 if ALUOP = 1001, 1000, or 1010
              o_RegDst         : out std_logic;
              o_Mem_To_Reg     : out std_logic;
              o_ALUOP		   : out std_logic_vector(3 downto 0);
              o_MemWrite       : out std_logic;
              o_ALUSrc         : out std_logic;
              o_RegWrite       : out std_logic;
              o_BEQ            : out std_logic;
              o_BNE            : out std_logic;
              o_J              : out std_logic;
              o_JAL            : out std_logic;
              o_JR             : out std_logic );
    end component;

    component register_file is
        port( i_CLK       : in std_logic;
              i_RST       : in std_logic;
              i_WR        : in std_logic_vector(4 downto 0);
              i_WD        : in std_logic_vector(31 downto 0);
              i_REGWRITE  : in std_logic;
              i_RR1       : in std_logic_vector(4 downto 0);
              i_RR2       : in std_logic_vector(4 downto 0);
              o_RD1       : out std_logic_vector(31 downto 0);
              o_RD2       : out std_logic_vector(31 downto 0) );
    end component;

    component mux2to1_5bit is
        port( i_X   : in std_logic_vector(4 downto 0);
              i_Y   : in std_logic_vector(4 downto 0);
              i_SEL : in std_logic;
              o_OUT   : out std_logic_vector(4 downto 0) );
    end component;

    component extend_16to32bit is
        port( i_input	: in std_logic_vector(15 downto 0);    -- 16 bit input
              i_sign    : in std_logic;                        -- 0 for unsigned, 1 for signed
              o_output  : out std_logic_vector(31 downto 0) ); -- 32 bit extended o_output
    end component;

    component extend_5to32bit is
        port( i_input   : in std_logic_vector(4 downto 0);
              i_sign    : in std_logic;
              o_output  : out std_logic_vector(31 downto 0) );
    end component;

    component rd1_rd2_zero_detect is
        port( i_RD1       : in std_logic_vector(31 downto 0);
              i_RD2       : in std_Logic_vector(31 downto 0);
              o_Zero_Flag : out std_logic );
    end component;

    --- Intermediary Signals ---
    signal s_Sel_ALU_A_Mux2, s_RegDst, s_Mem_To_Reg, s_MemWrite,
               s_ALUSrc, s_RegWrite, s_BEQ, s_BNE, s_J, s_JAL, s_JR, s_PCSrc,
               s_Zero : std_logic;
    signal s_ALUOP : std_logic_vector(3 downto 0);
    signal s_Immediate, s_RD1, s_RD2, s_BJ_Addr, s_SHAMT : std_logic_vector(31 downto 0);
    signal s_ThirtyOne, s_WR_Passthru, s_WR : std_logic_vector(4 downto 0);

begin

    o_PCPlus4 <= i_PCPlus4;
    o_JAL <= s_JAL;
    o_SHAMT <= s_SHAMT;
    o_BJ_Address <= s_BJ_Addr;
    o_PCSrc <= s_PCSrc;
    o_Immediate <= s_Immediate;
    o_WR <= s_WR_Passthru;
    o_RegWriteEn <= s_RegWrite;
    o_RD1 <= s_RD1;
    o_RD2 <= s_RD2;
    o_ALUOP <= s_ALUOP;
    o_Sel_Mux2 <= s_Sel_ALU_A_Mux2;
    o_Mem_To_Reg <= s_Mem_To_Reg;
    o_MemWrite <= s_MemWrite;
    o_ALUSrc <= s_ALUSrc;

    s_ThirtyOne <= (others => '1'); -- hardcoded to 31 in binary

    control_logic: control
        port map (i_Instruction, s_Sel_ALU_A_Mux2, s_RegDst, s_Mem_To_Reg, s_ALUOP,
                  s_MemWrite, s_ALUSrc, s_RegWrite, s_BEQ, s_BNE, s_J, s_JAL, s_JR);

    bj_logic: branch_jump_logic
        port map (s_BEQ, s_BNE, s_J, s_JAL, s_JR, s_Zero, i_Instruction(25 downto 0),
                  s_RD1, i_PCPlus4, s_Immediate, s_BJ_Addr, s_PCSrc);

    mux_WR_Pre: mux2to1_5bit
        port map (i_Instruction(20 downto 16), i_Instruction(15 downto 11), s_RegDst, s_WR_Passthru);

    mux_WR_Final: mux2to1_5bit
        port map (i_WriteReg, s_ThirtyOne, i_JAL_WB, s_WR);

    rf: register_file
        port map (i_clock, i_reset, s_WR, i_WriteData, i_RegWriteEn,
                  i_Instruction(25 downto 21), i_Instruction(20 downto 16), s_RD1, s_RD2);

    extend_imm: extend_16to32bit
        port map (i_Instruction(15 downto 0), '1', s_Immediate); -- sign-extend immediate

    extend_shamt: extend_5to32bit
        port map (i_Instruction(10 downto 6), '1', s_SHAMT); -- sign-extend shift amount

    rd1_rd2_zero : rd1_rd2_zero_detect
        port map (s_RD1, s_RD2, s_Zero);

end structural;
