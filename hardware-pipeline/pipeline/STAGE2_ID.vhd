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
    port( i_Reset            : in std_logic;
          i_Clock            : in std_logic;
          i_Forward_RS_Sel1  : in std_logic;
          i_Forward_RS_Sel2  : in std_logic;
          i_Forward_RT_Sel1  : in std_logic;
          i_Forward_RT_Sel2  : in std_logic;
          i_WB_Data          : in std_logic_vector(31 downto 0);
          i_EXMEM_ALUOut     : in std_logic_vector(31 downto 0);
          i_IDEX_MemRead     : in std_logic;
          i_IDEX_WriteReg    : in std_logic_vector(4 downto 0);
          i_EXMEM_WriteReg   : in std_logic_vector(4 downto 0);
          i_IFID_RS          : in std_logic_vector(4 downto 0);
          i_IFID_RT          : in std_logic_vector(4 downto 0);
          i_IDEX_RT          : in std_logic_vector(4 downto 0);
          i_Instruction      : in std_logic_vector(31 downto 0);
          i_PCPlus4          : in std_logic_vector(31 downto 0);
          i_WriteData        : in std_logic_vector(31 downto 0); -- comes from Writeback stage
          i_WriteReg         : in std_logic_vector(4 downto 0);  -- comes from Writeback stage
          i_RegWriteEn       : in std_logic;                     -- comes from Writeback stage
          i_JAL_WB           : in std_logic;                     -- comes from Writeback stage
          o_Instruction      : out std_logic_vector(31 downto 0); -- for hazard/forwarding (to get RS/RT)
          o_FLUSH_IFID       : out std_logic;
          o_FLUSH_IDEX       : out std_logic;
          o_STALL_IFID       : out std_logic;
          o_STALL_PC         : out std_logic;
          o_PCPlus4          : out std_logic_vector(31 downto 0);
          o_JAL              : out std_logic;
          o_SHAMT            : out std_logic_vector(31 downto 0);
          o_BJ_Address       : out std_logic_vector(31 downto 0);
          o_PCSrc            : out std_logic;
          o_Immediate        : out std_logic_vector(31 downto 0);
          o_WR               : out std_logic_vector(4 downto 0);
          o_RegWriteEn       : out std_logic;
          o_RD1              : out std_logic_vector(31 downto 0);
          o_RD2              : out std_logic_vector(31 downto 0);
          o_ALUOP            : out std_logic_vector(3 downto 0);
          o_Sel_Mux2         : out std_logic;
          o_Mem_To_Reg       : out std_logic;
          o_MemWrite         : out std_logic;
          o_ALUSrc           : out std_logic;
          o_Branch           : out std_logic; -- to be hooked up to forwarding
          o_JR               : out std_logic; -- to be immediately sent to forwarding in EX stage
          o_MemRead          : out std_logic ); -- to be sent thru idex
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
              o_PCSrc            : out std_logic;
              o_BranchTaken      : out std_logic;
              o_Branch           : out std_logic );
    end component;

    component control is
        port( i_Instruction    : in std_logic_vector(31 downto 0);
              o_Sel_ALU_A_Mux2 : out std_logic;
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
              o_JR             : out std_logic;
              o_MemRead        : out std_logic );
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
        port( i_input	: in std_logic_vector(15 downto 0);
              i_sign    : in std_logic;
              o_output  : out std_logic_vector(31 downto 0) );
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

    component hazard_detection is
        port( i_Branch           : in std_logic;
              i_BranchTaken      : in std_logic;
              i_J                : in std_logic;
              i_JAL              : in std_logic;
              i_JR               : in std_logic;
              i_IDEX_MemRead     : in std_logic;
              i_IDEX_WriteReg    : in std_logic_vector(4 downto 0);
              i_EXMEM_WriteReg   : in std_logic_vector(4 downto 0);
              i_IFID_RS          : in std_logic_vector(4 downto 0);
              i_IFID_RT          : in std_logic_vector(4 downto 0);
              i_IDEX_RT          : in std_logic_vector(4 downto 0);
              o_Flush_IFID       : out std_logic;
              o_Flush_IDEX       : out std_logic;
              o_Stall_IFID       : out std_logic;
              o_Stall_PC         : out std_logic );
    end component;

    component mux2to1_32bit is
        port( i_X   : in std_logic_vector(31 downto 0);
              i_Y   : in std_logic_vector(31 downto 0);
              i_SEL : in std_logic;
              o_OUT   : out std_logic_vector(31 downto 0) );
    end component;

    --- Intermediary Signals ---
    signal s_Sel_ALU_A_Mux2, s_RegDst, s_Mem_To_Reg, s_MemWrite,
           s_ALUSrc, s_RegWrite, s_BEQ, s_BNE, s_J, s_JAL, s_JR, s_PCSrc,
           s_Zero, s_MemRead, s_BranchTaken, s_Branch, s_FLUSH_IFID,
           s_FLUSH_IDEX, s_STALL_IFID, s_STALL_PC : std_logic;
    signal s_ALUOP : std_logic_vector(3 downto 0);
    signal s_Immediate, s_RD1, s_RD2, s_BJ_Addr, s_SHAMT, s_Forward_RS,
           s_Forward_RT, s_RS_Data_Final, s_RT_Data_Final : std_logic_vector(31 downto 0);
    signal s_ThirtyOne, s_WR_Passthru, s_WR : std_logic_vector(4 downto 0);

begin

    o_FLUSH_IFID <= s_FLUSH_IFID;
    o_FLUSH_IDEX <= s_FLUSH_IDEX;
    o_STALL_IFID <= s_STALL_IFID;
    o_STALL_PC <= s_STALL_PC;
    o_PCPlus4 <= i_PCPlus4;
    o_JAL <= s_JAL;
    o_SHAMT <= s_SHAMT;
    o_BJ_Address <= s_BJ_Addr;
    o_PCSrc <= s_PCSrc;
    o_Immediate <= s_Immediate;
    o_WR <= s_WR_Passthru;
    o_RegWriteEn <= s_RegWrite;
    o_RD1 <= s_RS_Data_Final;
    o_RD2 <= s_RT_Data_Final;
    o_ALUOP <= s_ALUOP;
    o_Sel_Mux2 <= s_Sel_ALU_A_Mux2;
    o_Mem_To_Reg <= s_Mem_To_Reg;
    o_MemWrite <= s_MemWrite;
    o_ALUSrc <= s_ALUSrc;
    o_Branch <= s_Branch;
    o_JR <= s_JR;
    o_MemRead <= s_MemRead;
    o_Instruction <= i_Instruction;

    s_ThirtyOne <= (others => '1'); -- hardcoded to 31 in binary

    control_logic: control
        port map (i_Instruction, s_Sel_ALU_A_Mux2, s_RegDst, s_Mem_To_Reg, s_ALUOP,
                  s_MemWrite, s_ALUSrc, s_RegWrite, s_BEQ, s_BNE, s_J, s_JAL, s_JR, s_MemRead);

    bj_logic: branch_jump_logic
        port map (s_BEQ, s_BNE, s_J, s_JAL, s_JR, s_Zero, i_Instruction(25 downto 0),
                  s_RD1, i_PCPlus4, s_Immediate, s_BJ_Addr, s_PCSrc, s_BranchTaken, s_Branch);

    mux_WR_Pre: mux2to1_5bit
        port map (i_Instruction(20 downto 16), i_Instruction(15 downto 11), s_RegDst, s_WR_Passthru);

    mux_WR_Final: mux2to1_5bit
        port map (i_WriteReg, s_ThirtyOne, i_JAL_WB, s_WR);

    -- RD1 = RS | RD2 = RT
    rf: register_file
        port map (i_clock, i_reset, s_WR, i_WriteData, i_RegWriteEn,
                  i_Instruction(25 downto 21), i_Instruction(20 downto 16), s_RD1, s_RD2);

    -- Now we determine if we pass along actual RD1/RD2 or their forwarded counterparts using muxes:
    mux_Forward_RS: mux2to1_32bit
        port map(i_WB_Data, i_EXMEM_ALUOut, i_Forward_RS_Sel2, s_Forward_RS);

    mux_Forward_RT: mux2to1_32bit
        port map(i_WB_Data, i_EXMEM_ALUOut, i_Forward_RT_Sel2, s_Forward_RT);

    mux_Final_RS: mux2to1_32bit
        port map(s_RD1, s_Forward_RS, i_Forward_RS_Sel1, s_RS_Data_Final);

    mux_Final_RT: mux2to1_32bit
        port map(s_RD2, s_Forward_RT, i_Forward_RT_Sel1, s_RT_Data_Final);

    extend_imm: extend_16to32bit
        port map (i_Instruction(15 downto 0), '1', s_Immediate); -- sign-extend immediate

    extend_shamt: extend_5to32bit
        port map (i_Instruction(10 downto 6), '1', s_SHAMT); -- sign-extend shift amount

    rd1_rd2_zero : rd1_rd2_zero_detect
        port map (s_RS_Data_Final, s_RT_Data_Final, s_Zero); -- TODO: should be RS or RD1?

    hazards: hazard_detection
        port map(s_Branch, s_BranchTaken, s_J, s_JAL, s_JR, i_IDEX_MemRead,
                 i_IDEX_WriteReg, i_EXMEM_WriteReg, i_IFID_RS, i_IFID_RT,
                 i_IDEX_RT, s_FLUSH_IFID, s_FLUSH_IDEX, s_STALL_IFID, s_STALL_PC);

end structural;
