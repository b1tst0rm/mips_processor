-- STAGE3_EX.vhd
-------------------------------------------------------------------------
-- DESCRIPTION: Execute logic module for the pipeline processor.
-- This file represents all of the logic inside the third of five stages
-- in a pipelined MIPS processor.
--
-- AUTHOR: Daniel Limanowski
-------------------------------------------------------------------------

library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;

entity execution is
    port( i_Reset              : in std_logic;
          i_Clock              : in std_logic;
          i_WB_Data            : in std_logic_vector(31 downto 0);
          i_EXMEM_ALUOut       : in std_logic_vector(31 downto 0);
          i_Branch             : in std_logic;
          i_JR                 : in std_logic;
          i_MemRead            : in std_logic;
          i_EXMEM_RegWriteEn   : in std_logic;
          i_MEMWB_RegWriteEn   : in std_logic;
          i_EXMEM_WriteReg     : in std_logic_vector(4 downto 0);
          i_MEMWB_WriteReg     : in std_logic_vector(4 downto 0);
          i_IFID_RS            : in std_logic_vector(4 downto 0);
          i_IDEX_RS            : in std_logic_vector(4 downto 0);
          i_IFID_RT            : in std_logic_vector(4 downto 0);
          i_IDEX_RT            : in std_logic_vector(4 downto 0);
          i_EXMEM_RT           : in std_logic_vector(4 downto 0);
          i_PCPlus4            : in std_logic_vector(31 downto 0);
          i_JAL                : in std_logic;
          i_RD1                : in std_logic_vector(31 downto 0);
          i_RD2                : in std_logic_vector(31 downto 0);
          i_IMM                : in std_logic_vector(31 downto 0);
          i_SHAMT              : in std_Logic_vector(31 downto 0);
          i_WR                 : in std_logic_vector(4 downto 0);
          i_RegWriteEn         : in std_logic;
          i_ALUOP              : in std_logic_vector(3 downto 0);
          i_Sel_Mux2           : in std_logic;
          i_Mem_To_Reg         : in std_logic;
          i_MemWrite           : in std_logic;
          i_ALUSrc             : in std_logic;
          i_Instruction        : in std_logic_vector(31 downto 0);
          o_Instruction        : out std_logic_vector(31 downto 0);
          o_PCPlus4            : out std_logic_vector(31 downto 0);
          o_JAL                : out std_logic;
          o_ALUOut             : out std_logic_vector(31 downto 0);
          o_RD2                : out std_logic_vector(31 downto 0);
          o_WR                 : out std_logic_vector(4 downto 0);
          o_Mem_To_Reg         : out std_logic;
          o_MemWrite           : out std_logic;
          o_RegWriteEn         : out std_logic;
          o_OVF                : out std_logic;
          o_ZF                 : out std_logic;
          o_CF                 : out std_logic;
          o_Forward_RS_Sel1    : out std_logic;
          o_Forward_RS_Sel2    : out std_logic;
          o_Forward_RT_Sel1    : out std_logic;
          o_Forward_RT_Sel2    : out std_logic );
end execution;

architecture structural of execution is
    component sel_alu_a is
        port( i_ALUSrc   : in std_logic;
              i_RD1      : in std_logic_vector(31 downto 0);
              i_ALUOP    : in std_logic_vector(3 downto 0);
              i_shamt    : in std_logic_vector(31 downto 0);
              i_mux2_sel : in std_logic;
              o_data     : out std_logic_vector(31 downto 0) );
    end component;

    component alu_32bit is
            port( i_A        : in  std_logic_vector(31 downto 0);
                  i_B        : in  std_logic_vector(31 downto 0);
                  i_ALUOP    : in  std_logic_vector(3  downto 0);
                  o_F        : out std_logic_vector(31 downto 0);
                  o_CarryOut : out std_logic;
                  o_Overflow : out std_logic;
                  o_Zero     : out std_logic );
    end component;

    component mux2to1_32bit is
        port( i_X   : in std_logic_vector(31 downto 0);
              i_Y   : in std_logic_vector(31 downto 0);
              i_SEL : in std_logic;
              o_OUT   : out std_logic_vector(31 downto 0) );
    end component;

    component forwarding_logic is
        port( i_Branch             : in std_logic;
              i_JR                 : in std_logic;
              i_EXMEM_RegWriteEn   : in std_logic;
              i_MEMWB_RegWriteEn   : in std_logic;
              i_EXMEM_WriteReg     : in std_logic_vector(4 downto 0);
              i_MEMWB_WriteReg     : in std_logic_vector(4 downto 0);
              i_IFID_RS            : in std_logic_vector(4 downto 0);
              i_IDEX_RS            : in std_logic_vector(4 downto 0);
              i_IFID_RT            : in std_logic_vector(4 downto 0);
              i_IDEX_RT            : in std_logic_vector(4 downto 0);
              i_EXMEM_RT           : in std_logic_vector(4 downto 0);
              o_Forward_ALU_A_Sel1 : out std_logic;
              o_Forward_ALU_A_Sel2 : out std_logic;
              o_Forward_ALU_B_Sel1 : out std_logic;
              o_Forward_ALU_B_Sel2 : out std_logic;
              o_Forward_RS_Sel1    : out std_logic;
              o_Forward_RS_Sel2    : out std_logic;
              o_Forward_RT_Sel1    : out std_logic;
              o_Forward_RT_Sel2    : out std_logic );
    end component;

    signal s_alu_out, s_Forward_A, s_Forward_B, s_Normal_A, s_Normal_B, s_Final_A,
           s_Final_B: std_logic_vector(31 downto 0);
    signal s_cf, s_ovf, s_zero, s_Forward_ALU_A_Sel1, s_Forward_ALU_A_Sel2,
           s_Forward_ALU_B_Sel1, s_Forward_ALU_B_Sel2, s_Forward_RS_Sel1,
           s_Forward_RS_Sel2, s_Forward_RT_Sel1, s_Forward_RT_Sel2 : std_logic;

begin

    o_PCPlus4 <= i_PCPlus4;
    o_JAL <= i_JAL;
    o_ALUOut <= s_alu_out;
    o_RD2 <= i_RD2;
    o_WR <= i_WR;
    o_Mem_To_Reg <= i_Mem_To_Reg;
    o_MemWrite <= i_MemWrite;
    o_RegWriteEn <= i_RegWriteEn;
    o_OVF <= s_ovf;
    o_ZF <= s_zero;
    o_CF <= s_cf;
    o_Instruction <= i_Instruction;
    o_Forward_RS_Sel1 <= s_Forward_RS_Sel1;
    o_Forward_RS_Sel2 <= s_Forward_RS_Sel2;
    o_Forward_RT_Sel1 <= s_Forward_RT_Sel1;
    o_Forward_RT_Sel2 <= s_Forward_RT_Sel2;

    select_normal_a: sel_alu_a
        port map(i_ALUSrc, i_RD1, i_ALUOP, i_SHAMT, i_Sel_Mux2, s_Normal_A);

    select_normal_b: mux2to1_32bit
        port map(i_RD2, i_IMM, i_ALUSrc, s_Normal_B);

    mux_a_fwd: mux2to1_32bit
        port map(i_WB_Data, i_EXMEM_ALUOut, s_Forward_ALU_A_Sel2, s_Forward_A);

    mux_b_fwd: mux2to1_32bit
        port map(i_WB_Data, i_EXMEM_ALUOut, s_Forward_ALU_B_Sel2, s_Forward_B);

    final_mux_a: mux2to1_32bit
        port map(s_Normal_A, s_Forward_A, s_Forward_ALU_A_Sel1, s_Final_A);

    final_mux_b: mux2to1_32bit
        port map(s_Normal_B, s_Forward_B, s_Forward_ALU_B_Sel1, s_Final_B);

    alu: alu_32bit
        port map(s_Final_A, s_Final_B, i_ALUOp, s_alu_out, s_cf, s_ovf, s_zero);

    forward: forwarding_logic
        port map(i_Branch, i_JR, i_EXMEM_RegWriteEn, i_MEMWB_RegWriteEn,
                 i_EXMEM_WriteReg, i_MEMWB_WriteReg, i_IFID_RS, i_IDEX_RS,
                 i_IFID_RT, i_IDEX_RT, i_EXMEM_RT, s_Forward_ALU_A_Sel1,
                 s_Forward_ALU_A_Sel2, s_Forward_ALU_B_Sel1, s_Forward_ALU_B_Sel2,
                 s_Forward_RS_Sel1, s_Forward_RS_Sel2, s_Forward_RT_Sel1, s_Forward_RT_Sel2);

end structural;
