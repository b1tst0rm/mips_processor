-- mips_pipeline_hazards.vhd
-------------------------------------------------------------------------
-- DESCRIPTION: MIPS Pipeline Processor implementation with hazard
-- detection/avoidance.
--
-- AUTHOR: Daniel Limanowski
-------------------------------------------------------------------------

-- Enter this command while simulating to load intruction memory (example .hex shown):
-- mem load -infile {filename}.hex -format hex /mips_pipeline_hazards/stage1/instruc_mem/ram

-- mem load -infile ../../part2/part2_7/mergesort/mergesort.hex -format hex /mips_pipeline_hazards/stage1/instruc_mem/ram

library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;

entity mips_pipeline_hazards is
    port( i_Reset       : in std_logic;    -- resets everything to initial state
          i_Clock       : in std_logic;    -- processor clock
          o_CF          : out std_logic;   -- carry flag
          o_OVF         : out std_logic;   -- overflow flag
          o_ZF          : out std_logic ); -- zero flag
end mips_pipeline_hazards;

architecture structure of mips_pipeline_hazards is
    component instruction_fetch is
        port( i_Reset         : in std_logic;
              i_Clock         : in std_logic;
              i_Stall_PC      : in std_logic;
              i_BranchJ_Addr  : in std_logic_vector(31 downto 0);
              i_Mux_Sel       : in std_logic;
              o_Instruction   : out std_logic_vector(31 downto 0);
              o_PCPlus4       : out std_logic_vector(31 downto 0) );
    end component;

    component register_IF_ID is
        port( i_Reset       : in std_logic;
              i_Clock       : in std_logic;
              i_Flush       : in std_logic;
              i_Stall       : in std_logic;
              i_Instruction : in std_logic_vector(31 downto 0);
              i_PCPlus4     : in std_logic_vector(31 downto 0);
              o_Instruction : out std_logic_vector(31 downto 0);
              o_PCPlus4     : out std_logic_vector(31 downto 0) );
    end component;

    component instruction_decode
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
              i_WriteData        : in std_logic_vector(31 downto 0);
              i_WriteReg         : in std_logic_vector(4 downto 0);
              i_RegWriteEn       : in std_logic;
              i_JAL_WB           : in std_logic;
              o_Instruction      : out std_logic_vector(31 downto 0);
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
              o_Branch           : out std_logic;
              o_JR               : out std_logic;
              o_MemRead          : out std_logic );
    end component;

    component register_ID_EX is
        port( i_Reset       : in std_logic;
              i_Clock       : in std_logic;
              i_Flush       : in std_logic;
              i_Stall       : in std_logic;
              i_MemRead     : in std_logic;
              i_PCPlus4     : in std_logic_vector(31 downto 0);
              i_JAL         : in std_logic;
              i_SHAMT       : in std_logic_vector(31 downto 0);
              i_RD1         : in std_logic_vector(31 downto 0);
              i_RD2         : in std_logic_vector(31 downto 0);
              i_IMM         : in std_logic_vector(31 downto 0);
              i_WR          : in std_logic_vector(4 downto 0);
              i_RegWriteEn  : in std_logic;
              i_ALUOP       : in std_logic_vector(3 downto 0);
              i_Sel_Mux2    : in std_logic;
              i_Mem_To_Reg  : in std_logic;
              i_MemWrite    : in std_logic;
              i_ALUSrc      : in std_logic;
              i_Instruction : in std_logic_vector(31 downto 0);
              o_Instruction : out std_logic_vector(31 downto 0);
              o_MemRead     : out std_logic;
              o_PCPlus4     : out std_logic_vector(31 downto 0);
              o_JAL         : out std_logic;
              o_SHAMT       : out std_logic_vector(31 downto 0);
              o_RD1         : out std_logic_vector(31 downto 0);
              o_RD2         : out std_logic_vector(31 downto 0);
              o_IMM         : out std_logic_vector(31 downto 0);
              o_WR          : out std_logic_vector(4 downto 0);
              o_RegWriteEn  : out std_logic;
              o_ALUOP       : out std_logic_vector(3 downto 0);
              o_Sel_Mux2    : out std_logic;
              o_Mem_To_Reg  : out std_logic;
              o_MemWrite    : out std_logic;
              o_ALUSrc      : out std_logic );
    end component;

    component execution is
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
    end component;

    component register_EX_MEM is
        port( i_Reset       : in std_logic;
              i_Clock       : in std_logic;
              i_Flush       : in std_logic;
              i_Stall       : in std_logic;
              i_PCPlus4     : in std_logic_vector(31 downto 0);
              i_JAL         : in std_logic;
              i_ALUOut      : in std_logic_vector(31 downto 0);
              i_RD2         : in std_logic_vector(31 downto 0);
              i_WR          : in std_logic_vector(4 downto 0);
              i_Mem_To_Reg  : in std_logic;
              i_MemWrite    : in std_logic;
              i_RegWriteEn  : in std_logic;
              i_Instruction : in std_logic_vector(31 downto 0);
              o_Instruction : out std_logic_vector(31 downto 0);
              o_PCPlus4     : out std_logic_vector(31 downto 0);
              o_JAL         : out std_logic;
              o_ALUOut      : out std_logic_vector(31 downto 0);
              o_RD2         : out std_logic_vector(31 downto 0);
              o_WR          : out std_logic_vector(4 downto 0);
              o_Mem_To_Reg  : out std_logic;
              o_MemWrite    : out std_logic;
              o_RegWriteEn  : out std_logic );
    end component;

    component memory is
        port( i_Reset       : in std_logic;
              i_Clock       : in std_logic;
              i_PCPlus4     : in std_Logic_vector(31 downto 0);
              i_JAL         : in std_logic;
              i_ALUOut      : in std_logic_vector(31 downto 0);
              i_RD2         : in std_logic_vector(31 downto 0);
              i_WR          : in std_logic_vector(4 downto 0);
              i_Mem_To_Reg  : in std_logic;
              i_MemWrite    : in std_logic;
              i_RegWriteEn  : in std_logic;
              o_PCPlus4     : out std_logic_vector(31 downto 0);
              o_JAL         : out std_logic;
              o_ALUOut      : out std_logic_vector(31 downto 0);
              o_WR          : out std_logic_vector(4 downto 0);
              o_Mem_To_Reg  : out std_logic;
              o_RegWriteEn  : out std_logic;
              o_MemOut      : out std_logic_vector(31 downto 0) );
    end component;

    component register_MEM_WB is
        port( i_Reset       : in std_logic;
              i_Clock       : in std_logic;
              i_Flush       : in std_logic;
              i_Stall       : in std_logic;
              i_PCPlus4     : in std_logic_vector(31 downto 0);
              i_JAL         : in std_logic;
              i_ALUOut      : in std_logic_vector(31 downto 0);
              i_WR          : in std_logic_vector(4 downto 0);
              i_Mem_To_Reg  : in std_logic;
              i_RegWriteEn  : in std_logic;
              i_MemOut      : in std_logic_vector(31 downto 0);
              o_PCPlus4     : out std_logic_vector(31 downto 0);
              o_JAL         : out std_logic;
              o_ALUOut      : out std_logic_vector(31 downto 0);
              o_WR          : out std_logic_vector(4 downto 0);
              o_Mem_To_Reg  : out std_logic;
              o_RegWriteEn  : out std_logic;
              o_MemOut      : out std_logic_vector(31 downto 0) );
    end component;

    component writeback is
        port( i_Reset       : in std_logic;
              i_Clock       : in std_logic;
              i_PCPlus4     : in std_logic_vector(31 downto 0);
              i_JAL         : in std_logic;
              i_ALUOut      : in std_logic_vector(31 downto 0);
              i_WR          : in std_logic_vector(4 downto 0);
              i_Mem_To_Reg  : in std_logic;
              i_RegWriteEn  : in std_logic;
              i_MemOut      : in std_logic_vector(31 downto 0);
              o_RegWriteEn  : out std_logic;
              o_WD          : out std_logic_vector(31 downto 0);
              o_WR          : out std_logic_vector(4 downto 0);
              o_JAL         : out std_logic );
    end component;


    --- Internal Signal Declaration ---
    signal s_OVF, s_ZF, s_CF : std_logic;

    -- FORWARDING/HAZARD --
    signal s_FLUSH_IDEX, s_FLUSH_IFID : std_logic;
    signal s_STALL_IFID, s_STALL_PC : std_logic;

    -- Stage 1
    signal s_branch_j_addr, s_Instruc_IFID_In, s_PCPlus4_IFID_In : std_logic_vector(31 downto 0);
    signal s_fetch_sel     : std_logic;
    -- End Stage 1 Intermediary Signals

    -- Reg 1/2
    signal s_Instruc_IFID_Out, s_PCPlus4_IFID_Out : std_logic_vector(31 downto 0);
    -- End Reg 1/2

    -- Stage 2
    signal s_WR_IDEX_In    : std_logic_vector(4 downto 0); -- see above
    signal s_PCPlus4_IDEX_In, s_RD1_IDEX_In, s_RD2_IDEX_In, s_Immediate_IDEX_In, s_SHAMT_IDEX_In, s_Instruc_IDEX_In : std_logic_vector(31 downto 0);
    signal s_ALUOP_IDEX_In : std_logic_vector(3 downto 0);
    signal s_Sel_Mux2_IDEX_In, s_Mem_To_Reg_IDEX_In, s_MemWrite_IDEX_In,
           s_ALUSrc_IDEX_In, s_RegWriteEn_IDEX_In, s_JAL_IDEX_In,
           s_Branch_Stage2, s_MemRead_IDEX_In, s_JR_Origin : std_logic;
    -- End Stage 2 Intermediary Signals

    -- Reg 2/3
    signal s_RD1_IDEX_Out, s_RD2_IDEX_Out, s_Immediate_IDEX_Out, s_SHAMT_IDEX_Out, s_PCPlus4_IDEX_Out, s_Instruc_IDEX_Out : std_logic_vector(31 downto 0);
    signal s_WR_IDEX_Out : std_logic_vector(4 downto 0);
    signal s_ALUOP_IDEX_Out : std_logic_vector(3 downto 0);
    signal s_RegWriteEn_IDEX_Out, s_Sel_Mux2_IDEX_Out, s_Mem_To_Reg_IDEX_Out,
           s_MemWrite_IDEX_Out, s_ALUSrc_IDEX_Out, s_JAL_IDEX_Out, s_MemRead_IDEX_Out : std_logic;
    -- End Reg 2/3

    -- Stage 3
    signal s_ALUOut_EXMEM_In, s_RD2_EXMEM_In, s_PCPlus4_EXMEM_In, s_Instruc_EXMEM_In : std_logic_vector(31 downto 0);
    signal s_WR_EXMEM_In : std_logic_vector(4 downto 0);
    signal s_Mem_To_Reg_EXMEM_In, s_MemWrite_EXMEM_In, s_RegWriteEn_EXMEM_In, s_JAL_EXMEM_In,
           s_Forward_RS_Sel1, s_Forward_RS_Sel2, s_Forward_RT_Sel1, s_Forward_RT_Sel2 : std_logic;
    -- End Stage 3 Intermediary Signals

    -- Reg 3/4
    signal s_ALUOut_EXMEM_Out, s_RD2_EXMEM_Out, s_PCPlus4_EXMEM_Out, s_Instruc_EXMEM_Out : std_logic_vector(31 downto 0);
    signal s_WR_EXMEM_Out : std_logic_vector(4 downto 0);
    signal s_Mem_To_Reg_EXMEM_Out, s_MemWrite_EXMEM_Out, s_RegWriteEn_EXMEM_Out, s_JAL_EXMEM_Out : std_logic;
    -- End Reg 3/4

    -- Stage 4
    signal s_ALUOut_MEMWB_In, s_MemOut_MEMWB_In, s_PCPlus4_MEMWB_In : std_logic_vector(31 downto 0);
    signal s_WR_MEMWB_In : std_logic_vector(4 downto 0);
    signal s_Mem_To_Reg_MEMWB_In, s_RegWriteEn_MEMWB_In, s_JAL_MEMWB_In : std_logic;
    -- End Stage 4 Intermediary Signals

    -- Reg 4/5
    signal s_ALUOut_MEMWB_Out, s_MemOut_MEMWB_Out, s_PCPlus4_MEMWB_Out : std_logic_vector(31 downto 0);
    signal s_WR_MEMWB_Out : std_logic_vector(4 downto 0);
    signal s_Mem_To_Reg_MEMWB_Out, s_RegWriteEn_MEMWB_Out, s_JAL_MEMWB_Out : std_logic;
    --End Reg 4/5

    -- Stage 5
    signal s_WriteData_WB_Out   : std_logic_vector(31 downto 0);
    signal s_WriteReg_WB_Out    : std_logic_vector(4 downto 0);
    signal s_RegWriteEn_WB_Out, s_JAL_WB_Out  : std_logic;
    -- End Stage 5 Intermediary Signals

begin
    -- Dummy output ports to help with debugging during simulation and also to
    -- provide outputs for help with Quartus synthesizing.
    o_ZF <= s_ZF;
    o_CF <= s_CF;
    o_OVF <= s_OVF;

-------------------------------- IF Stage 1 ------------------------------------
    stage1: instruction_fetch
      port map ( i_Reset         => i_Reset,
                 i_Clock         => i_Clock,
                 i_Stall_PC      => s_STALL_PC,
                 i_BranchJ_Addr  => s_branch_j_addr,
                 i_Mux_Sel       => s_fetch_sel,
                 o_Instruction   => s_Instruc_IFID_In,
                 o_PCPlus4       => s_PCPlus4_IFID_In );
-------------------------------- End IF Stage 1---------------------------------

------------------------------ IF/ID Register ----------------------------------
    reg_1_2: register_IF_ID
      port map (i_Reset       => i_Reset,
                i_Clock       => i_Clock,
                i_Flush       => s_FLUSH_IFID,
                i_Stall       => s_STALL_IFID,
                i_Instruction => s_Instruc_IFID_In,
                i_PCPlus4     => s_PCPlus4_IFID_In,
                o_Instruction => s_Instruc_IFID_Out,
                o_PCPlus4     => s_PCPlus4_IFID_Out );
----------------------------- End IF/ID Register -------------------------------

-------------------------------- ID Stage 2 ------------------------------------
    stage2: instruction_decode
      port map (i_Reset            => i_Reset,
                i_Clock            => i_Clock,
                i_Forward_RS_Sel1  => s_Forward_RS_Sel1,
                i_Forward_RS_Sel2  => s_Forward_RS_Sel2,
                i_Forward_RT_Sel1  => s_Forward_RT_Sel1,
                i_Forward_RT_Sel2  => s_Forward_RT_Sel2,
                i_WB_Data          => s_WriteData_WB_Out,
                i_EXMEM_ALUOut     => s_ALUOut_EXMEM_Out,
                i_IDEX_MemRead     => s_MemRead_IDEX_Out,
                i_IDEX_WriteReg    => s_WR_IDEX_Out,
                i_EXMEM_WriteReg   => s_WR_EXMEM_Out,
                i_IFID_RS          => s_Instruc_IFID_Out(25 downto 21),
                i_IFID_RT          => s_Instruc_IFID_Out(20 downto 16),
                i_IDEX_RT          => s_Instruc_IDEX_Out(20 downto 16),
                i_Instruction      => s_Instruc_IFID_Out,
                i_PCPlus4          => s_PCPlus4_IFID_Out,
                i_WriteData        => s_WriteData_WB_Out,
                i_WriteReg         => s_WriteReg_WB_Out,
                i_RegWriteEn       => s_RegWriteEn_WB_Out,
                i_JAL_WB           => s_JAL_WB_Out,
                o_Instruction      => s_Instruc_IDEX_In,
                o_FLUSH_IFID       => s_FLUSH_IFID,
                o_FLUSH_IDEX       => s_FLUSH_IDEX,
                o_STALL_IFID       => s_STALL_IFID,
                o_STALL_PC         => s_STALL_PC,
                o_PCPlus4          => s_PCPlus4_IDEX_In,
                o_JAL              => s_JAL_IDEX_In,
                o_SHAMT            => s_SHAMT_IDEX_In,
                o_BJ_Address       => s_branch_j_addr,
                o_PCSrc            => s_fetch_sel,
                o_Immediate        => s_Immediate_IDEX_In,
                o_WR               => s_WR_IDEX_In,
                o_RegWriteEn       => s_RegWriteEn_IDEX_In,
                o_RD1              => s_RD1_IDEX_In,
                o_RD2              => s_RD2_IDEX_In,
                o_ALUOP            => s_ALUOP_IDEX_In,
                o_Sel_Mux2         => s_Sel_Mux2_IDEX_In,
                o_Mem_To_Reg       => s_Mem_To_Reg_IDEX_In,
                o_MemWrite         => s_MemWrite_IDEX_In,
                o_ALUSrc           => s_ALUSrc_IDEX_In,
                o_Branch           => s_Branch_Stage2,
                o_JR               => s_JR_Origin,
                o_MemRead          => s_MemRead_IDEX_In );
-------------------------------- End ID Stage 2 --------------------------------

------------------------------ ID/EX Register ----------------------------------
     reg_2_3: register_ID_EX
        port map(i_Reset       => i_Reset,
                 i_Clock       => i_Clock,
                 i_Flush       => s_FLUSH_IDEX,
                 i_Stall       => '0', -- do NOT need to stall this reg @ any time
                 i_MemRead     => s_MemRead_IDEX_In,
                 i_PCPlus4     => s_PCPlus4_IDEX_In,
                 i_JAL         => s_JAL_IDEX_In,
                 i_SHAMT       => s_SHAMT_IDEX_In,
                 i_RD1         => s_RD1_IDEX_In,
                 i_RD2         => s_RD2_IDEX_In,
                 i_IMM         => s_Immediate_IDEX_In,
                 i_WR          => s_WR_IDEX_In,
                 i_RegWriteEn  => s_RegWriteEn_IDEX_In,
                 i_ALUOP       => s_ALUOP_IDEX_In,
                 i_Sel_Mux2    => s_Sel_Mux2_IDEX_In,
                 i_Mem_To_Reg  => s_Mem_To_Reg_IDEX_In,
                 i_MemWrite    => s_MemWrite_IDEX_In,
                 i_Instruction => s_Instruc_IDEX_In,
                 i_ALUSrc      => s_ALUSrc_IDEX_In,
                 o_Instruction => s_Instruc_IDEX_Out,
                 o_MemRead     => s_MemRead_IDEX_Out,
                 o_PCPlus4     => s_PCPlus4_IDEX_Out,
                 o_JAL         => s_JAL_IDEX_Out,
                 o_SHAMT       => s_SHAMT_IDEX_Out,
                 o_RD1         => s_RD1_IDEX_Out,
                 o_RD2         => s_RD2_IDEX_Out,
                 o_IMM         => s_Immediate_IDEX_Out,
                 o_WR          => s_WR_IDEX_Out,
                 o_RegWriteEn  => s_RegWriteEn_IDEX_Out,
                 o_ALUOP       => s_ALUOP_IDEX_Out,
                 o_Sel_Mux2    => s_Sel_Mux2_IDEX_Out,
                 o_Mem_To_Reg  => s_Mem_To_Reg_IDEX_Out,
                 o_MemWrite    => s_MemWrite_IDEX_Out,
                 o_ALUSrc      => s_ALUSrc_IDEX_Out );
----------------------------- End ID/EX Register -------------------------------

-------------------------------- EX Stage 3 ------------------------------------
    stage3: execution
       port map(i_Reset              => i_Reset,
                i_Clock              => i_Clock,
                i_WB_Data            => s_WriteData_WB_Out,
                i_EXMEM_ALUOut       => s_ALUOut_EXMEM_Out,
                i_Branch             => s_Branch_Stage2,
                i_JR                 => s_JR_Origin,
                i_MemRead            => s_MemRead_IDEX_Out,
                i_EXMEM_RegWriteEn   => s_RegWriteEn_EXMEM_Out,
                i_MEMWB_RegWriteEn   => s_RegWriteEn_MEMWB_Out,
                i_EXMEM_WriteReg     => s_WR_EXMEM_Out,
                i_MEMWB_WriteReg     => s_WR_MEMWB_Out,
                i_IFID_RS            => s_Instruc_IFID_Out(25 downto 21),
                i_IDEX_RS            => s_Instruc_IDEX_Out(25 downto 21),
                i_IFID_RT            => s_Instruc_IFID_Out(20 downto 16),
                i_IDEX_RT            => s_Instruc_IDEX_Out(20 downto 16),
                i_EXMEM_RT           => s_Instruc_EXMEM_Out(20 downto 16),
                i_PCPlus4            => s_PCPlus4_IDEX_Out,
                i_JAL                => s_JAL_IDEX_Out,
                i_RD1                => s_RD1_IDEX_Out,
                i_RD2                => s_RD2_IDEX_Out,
                i_IMM                => s_Immediate_IDEX_Out,
                i_SHAMT              => s_SHAMT_IDEX_Out,
                i_WR                 => s_WR_IDEX_Out,
                i_RegWriteEn         => s_RegWriteEn_IDEX_Out,
                i_ALUOP              => s_ALUOP_IDEX_Out,
                i_Sel_Mux2           => s_Sel_Mux2_IDEX_Out,
                i_Mem_To_Reg         => s_Mem_To_Reg_IDEX_Out,
                i_MemWrite           => s_MemWrite_IDEX_Out,
                i_ALUSrc             => s_ALUSrc_IDEX_Out,
                i_Instruction        => s_Instruc_IDEX_Out,
                o_Instruction        => s_Instruc_EXMEM_In,
                o_PCPlus4            => s_PCPlus4_EXMEM_In,
                o_JAL                => s_JAL_EXMEM_In,
                o_ALUOut             => s_ALUOut_EXMEM_In,
                o_RD2                => s_RD2_EXMEM_In,
                o_WR                 => s_WR_EXMEM_In,
                o_Mem_To_Reg         => s_Mem_To_Reg_EXMEM_In,
                o_MemWrite           => s_MemWrite_EXMEM_In,
                o_RegWriteEn         => s_RegWriteEn_EXMEM_In,
                o_OVF                => s_OVF,
                o_ZF                 => s_ZF,
                o_CF                 => s_CF,
                o_Forward_RS_Sel1    => s_Forward_RS_Sel1,
                o_Forward_RS_Sel2    => s_Forward_RS_Sel2,
                o_Forward_RT_Sel1    => s_Forward_RT_Sel1,
                o_Forward_RT_Sel2    => s_Forward_RT_Sel2 );
-------------------------------- End EX Stage 3 --------------------------------

------------------------------ EX/MEM Register ---------------------------------
    reg_3_4: register_EX_MEM
      port map(i_Reset       => i_Reset,
               i_Clock       => i_Clock,
               i_Flush       => '0',      -- We do not have to flush nor stall
               i_Stall       => '0',      -- this register at any time.
               i_PCPlus4     => s_PCPlus4_EXMEM_In,
               i_JAL         => s_JAL_EXMEM_In,
               i_ALUOut      => s_ALUOut_EXMEM_In,
               i_RD2         => s_RD2_EXMEM_In,
               i_WR          => s_WR_EXMEM_In,
               i_Mem_To_Reg  => s_Mem_To_Reg_EXMEM_In,
               i_MemWrite    => s_MemWrite_EXMEM_In,
               i_RegWriteEn  => s_RegWriteEn_EXMEM_In,
               i_Instruction => s_Instruc_EXMEM_In,
               o_Instruction => s_Instruc_EXMEM_Out,
               o_PCPlus4     => s_PCPlus4_EXMEM_Out,
               o_JAL         => s_JAL_EXMEM_Out,
               o_ALUOut      => s_ALUOut_EXMEM_Out,
               o_RD2         => s_RD2_EXMEM_Out,
               o_WR          => s_WR_EXMEM_Out,
               o_Mem_To_Reg  => s_Mem_To_Reg_EXMEM_Out,
               o_MemWrite    => s_MemWrite_EXMEM_Out,
               o_RegWriteEn  => s_RegWriteEn_EXMEM_Out );
----------------------------- End EX/MEM Register ------------------------------

------------------------------- MEM Stage 4 ------------------------------------
    stage4: memory
       port map(i_Reset       => i_Reset,
                i_Clock       => i_Clock,
                i_PCPlus4     => s_PCPlus4_EXMEM_Out,
                i_JAL         => s_JAL_EXMEM_Out,
                i_ALUOut      => s_ALUOut_EXMEM_Out,
                i_RD2         => s_RD2_EXMEM_Out,
                i_WR          => s_WR_EXMEM_Out,
                i_Mem_To_Reg  => s_Mem_To_Reg_EXMEM_Out,
                i_MemWrite    => s_MemWrite_EXMEM_Out,
                i_RegWriteEn  => s_RegWriteEn_EXMEM_Out,
                o_PCPlus4     => s_PCPlus4_MEMWB_In,
                o_JAL         => s_JAL_MEMWB_In,
                o_ALUOut      => s_ALUOut_MEMWB_In,
                o_WR          => s_WR_MEMWB_In,
                o_Mem_To_Reg  => s_Mem_To_Reg_MEMWB_In,
                o_RegWriteEn  => s_RegWriteEn_MEMWB_In,
                o_MemOut      => s_MemOut_MEMWB_In );
------------------------------- End MEM Stage 4 --------------------------------

------------------------------ MEM/WB Register ---------------------------------
    reg_4_5: register_MEM_WB
       port map(i_Reset       => i_Reset,
                i_Clock       => i_Clock,
                i_Flush       => '0',      -- We do not have to flush nor stall
                i_Stall       => '0',      -- this register at any time.
                i_PCPlus4     => s_PCPlus4_MEMWB_In,
                i_JAL         => s_JAL_MEMWB_In,
                i_ALUOut      => s_ALUOut_MEMWB_In,
                i_WR          => s_WR_MEMWB_In,
                i_Mem_To_Reg  => s_Mem_To_Reg_MEMWB_In,
                i_RegWriteEn  => s_RegWriteEn_MEMWB_In,
                i_MemOut      => s_MemOut_MEMWB_In,
                o_PCPlus4     => s_PCPlus4_MEMWB_Out,
                o_JAL         => s_JAL_MEMWB_Out,
                o_ALUOut      => s_ALUOut_MEMWB_Out,
                o_WR          => s_WR_MEMWB_Out,
                o_Mem_To_Reg  => s_Mem_To_Reg_MEMWB_Out,
                o_RegWriteEn  => s_RegWriteEn_MEMWB_Out,
                o_MemOut      => s_MemOut_MEMWB_Out );
----------------------------- End MEM/WB Register ------------------------------

------------------------------- WB Stage 5 -------------------------------------
    stage5: writeback
        port map(i_Reset       => i_Reset,
                 i_Clock       => i_Clock,
                 i_PCPlus4     => s_PCPlus4_MEMWB_Out,
                 i_JAL         => s_JAL_MEMWB_Out,
                 i_ALUOut      => s_ALUOut_MEMWB_Out,
                 i_WR          => s_WR_MEMWB_Out,
                 i_Mem_To_Reg  => s_Mem_To_Reg_MEMWB_Out,
                 i_RegWriteEn  => s_RegWriteEn_MEMWB_Out,
                 i_MemOut      => s_MemOut_MEMWB_Out,
                 o_RegWriteEn  => s_RegWriteEn_WB_Out,
                 o_WD          => s_WriteData_WB_Out,
                 o_WR          => s_WriteReg_WB_Out,
                 o_JAL         => s_JAL_WB_Out );
------------------------------- End WB Stage 5 ---------------------------------

end structure;
