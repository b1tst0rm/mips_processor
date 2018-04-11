-- mips_pipeline.vhd
-------------------------------------------------------------------------
-- DESCRIPTION: MIPS Pipeline Processor implementation with NO hazard
-- detection/avoidance
--
-- AUTHOR: Daniel Limanowski
-------------------------------------------------------------------------

-- Enter this command while simulating to load intruction memory (example .hex shown):
-- mem load -infile {filename}.hex -format hex /mips_pipeline/fetch_instruc/instruc_mem/ram

-- TODO: The plan for the organization of this top-level-entity (TLE) is to
-- separate all stage logic and intermediary pipe registers into their own files
-- NAMING SCHEME: STAGEN_NAME, REGISTER_NAME_NAME

library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;

entity mips_pipeline is
    port( i_Reset       : in std_logic;    -- resets everything to initial state
          i_Clock       : in std_logic;    -- processor clock
          o_CF          : out std_logic;   -- carry flag
          o_OVF         : out std_logic;   -- overflow flag
          o_ZF          : out std_logic ); -- zero flag
end mips_pipeline;

architecture structure of mips_pipeline is
    component instruction_fetch is
        port( i_Reset         : in std_logic;
              i_Clock         : in std_logic;
              i_BranchJ_Addr  : in std_logic_vector(31 downto 0);
              i_Mux_Sel       : in std_logic;
              o_Instruction   : out std_logic_vector(31 downto 0);
              o_PCPlus4       : out std_logic_vector(31 downto 0) );
    end component;

    component register_IF_ID is
        port( i_Clock       : in std_logic;
              i_Reset       : in std_logic;
              i_Instruction : in std_logic_vector(31 downto 0);
              i_PCPlus4     : in std_logic_vector(31 downto 0);
              o_Instruction : out std_logic_vector(31 downto 0);
              o_PCPlus4     : out std_logic_vector(31 downto 0) );
    end component;

    component instruction_decode is
        port( i_Reset         : in std_logic;
              i_Clock         : in std_logic;
              i_Instruction   : in std_logic_vector(31 downto 0);
              i_PCPlus4       : in std_logic_vector(31 downto 0);
              i_WriteData     : in std_logic_vector(31 downto 0); -- comes from Writeback stage
              i_WriteReg      : in std_logic_vector(4 downto 0);  -- comes from Writeback stage
              i_RegWriteEn    : in std_logic;                     -- see above
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
    end component;

    component register_ID_EX is
        port( i_Reset       : in std_logic;
              i_Clock       : in std_logic;
              i_RD1         : in std_logic_vector(31 downto 0);
              i_RD2         : in std_logic_vector(31 downto 0);
              i_IMM         : in std_logic_vector(31 downto 0);
              i_WR          : in std_logic_vector(4 downto 0);
              i_RegWriteEn  : in std_logic;
              i_ALUOP       : in std_logic_vector(3 downto 0);
              i_Sel_Mux2    : in std_logic; -- for sel_a for feeding into the alu
              i_Mem_To_Reg  : in std_logic;
              i_MemWrite    : in std_logic;
              i_ALUSrc      : in std_logic;
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

    --- Internal Signal Declaration ---
    -- TEMPORARY FLAGS (TODO: place in proper area when finished)
    signal s_OVF, s_ZF, s_CF : std_logic;

    -- Stage 1
    signal s_branch_j_addr, s_Instruc_IFID_In, s_PCPlus4_IFID_In : std_logic_vector(31 downto 0);
    signal s_fetch_sel     : std_logic;
    -- End Stage 1 Intermediary Signals

    -- Reg 1/2
    signal s_Instruc_IFID_Out, s_PCPlus4_IFID_Out : std_logic_vector(31 downto 0);
    -- End Reg 1/2

    -- Stage 2
    signal s_WriteData_IDEX_In   : std_logic_vector(31 downto 0); -- TODO: this will eventually come from WB stage
    signal s_WR_IDEX_In    : std_logic_vector(4 downto 0); -- see above
    signal s_RD1_IDEX_In, s_RD2_IDEX_In, s_Immediate_IDEX_In : std_logic_vector(31 downto 0);
    signal s_ALUOP_IDEX_In : std_logic_vector(3 downto 0);
    signal s_Sel_Mux2_IDEX_In, s_Mem_To_Reg_IDEX_In, s_MemWrite_IDEX_In, s_ALUSrc_IDEX_In, s_RegWriteEn_IDEX_In : std_logic;
    -- End Stage 2 Intermediary Signals

    -- Reg 2/3
    signal s_RD1_IDEX_Out, s_RD2_IDEX_Out, s_Immediate_IDEX_Out : std_logic_vector(31 downto 0);
    signal s_WR_IDEX_Out : std_logic_vector(4 downto 0);
    signal s_ALUOP_IDEX_Out : std_logic_vector(3 downto 0);
    signal s_RegWriteEn_IDEX_Out, s_Sel_Mux2_IDEX_Out, s_Mem_To_Reg_IDEX_Out,
           s_MemWrite_IDEX_Out, s_ALUSrc_IDEX_Out : std_logic;
    -- End Reg 2/3

    -- Stage 5
    signal s_WriteData_WB_Out   : std_logic_vector(31 downto 0); -- TODO: this will eventually come from WB stage
    signal s_WriteReg_WB_Out    : std_logic_vector(4 downto 0); -- see above
    signal s_RegWriteEn_WB_Out  : std_logic;
    -- End Stage 5 Intermediary Signals

begin

    o_ZF <= s_ZF;
    o_CF <= s_CF;
    o_OVF <= s_OVF;

-------------------------------- IF Stage 1 ------------------------------------
    stage1: instruction_fetch
        port map (i_Reset, i_Clock, s_branch_j_addr, s_fetch_sel,
                  s_Instruc_IFID_In, s_PCPlus4_IFID_In);
-------------------------------- End IF Stage 1---------------------------------

------------------------------ IF/ID Register ----------------------------------
    reg_1_2: register_IF_ID
        port map (i_Reset, i_Clock, s_Instruc_IFID_In, s_PCPlus4_IFID_In,
                  s_Instruc_IFID_Out, s_PCPlus4_IFID_Out);
----------------------------- End IF/ID Register -------------------------------

-------------------------------- ID Stage 2 ------------------------------------
    stage2: instruction_decode
        port map (i_Reset, i_Clock, s_Instruc_IFID_Out, s_PCPlus4_IFID_Out,
                  s_WriteData_WB_Out, s_WriteReg_WB_Out, s_RegWriteEn_WB_Out,
                  s_branch_j_addr, s_fetch_sel, s_Immediate_IDEX_In,
                  s_WR_IDEX_In, s_RegWriteEn_IDEX_In, s_RD1_IDEX_In,
                  s_RD2_IDEX_In, s_ALUOP_IDEX_In, s_Sel_Mux2_IDEX_In,
                  s_Mem_To_Reg_IDEX_In, s_MemWrite_IDEX_In, s_ALUSrc_IDEX_In);
-------------------------------- End ID Stage 2 --------------------------------

------------------------------ ID/EX Register ----------------------------------
    reg_2_3: register_ID_EX
        port map(i_Reset, i_Clock, s_RD1_IDEX_In, s_RD2_IDEX_In,
                 s_Immediate_IDEX_In, s_WR_IDEX_In, s_RegWriteEn_IDEX_In, s_ALUOP_IDEX_In,
                 s_Sel_Mux2_IDEX_In, s_Mem_To_Reg_IDEX_In, s_MemWrite_IDEX_In,
                 s_ALUSrc_IDEX_In, s_RD1_IDEX_Out, s_RD2_IDEX_Out,
                 s_Immediate_IDEX_Out, s_WR_IDEX_Out, s_RegWriteEn_IDEX_Out, s_ALUOP_IDEX_Out,
                 s_Sel_Mux2_IDEX_Out, s_Mem_To_Reg_IDEX_Out,
                 s_MemWrite_IDEX_Out, s_ALUSrc_IDEX_Out);
----------------------------- End ID/EX Register -------------------------------

-------------------------------- EX Stage 3 ------------------------------------
-- TODO
-------------------------------- End EX Stage 3 --------------------------------

------------------------------ EX/MEM Register ---------------------------------
-- TODO
----------------------------- End EX/MEM Register ------------------------------

------------------------------- MEM Stage 4 ------------------------------------
-- TODO
------------------------------- End MEM Stage 4 --------------------------------

------------------------------ MEM/WB Register ---------------------------------
-- TODO
----------------------------- End MEM/WB Register ------------------------------

------------------------------- WB Stage 5 -------------------------------------
-- TODO
------------------------------- End WB Stage 5 ---------------------------------

end structure;
