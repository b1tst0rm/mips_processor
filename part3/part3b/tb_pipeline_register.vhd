-- tb_pipeline_register.vhd
-------------------------------------------------------------------------
-- DESCRIPTION: Pipeline register test to show stalling and flushing.
--
-- AUTHOR: Daniel Limanowski
-------------------------------------------------------------------------

library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;

entity tb_pipeline_register is
    port( i_Reset       : in std_logic;    -- resets everything to initial state
          i_Clock       : in std_logic;    -- processor clock
          i_WD_Test     : in std_logic_vector(31 downto 0); -- pc plus 4 test value for tb
          i_IFID_Stall  : in std_logic;
          i_IDEX_Stall  : in std_logic;
          i_EXMEM_Stall : in std_logic;
          i_MEMWB_Stall : in std_logic;
          i_IFID_Flush  : in std_logic;
          i_IDEX_Flush  : in std_logic;
          i_EXMEM_Flush : in std_logic;
          i_MEMWB_Flush : in std_logic );
end tb_pipeline_register;

architecture structure of tb_pipeline_register is
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
              o_PCPlus4     : out std_logic_vector(31 downto 0);
              o_JAL         : out std_logic;
              o_ALUOut      : out std_logic_vector(31 downto 0);
              o_RD2         : out std_logic_vector(31 downto 0);
              o_WR          : out std_logic_vector(4 downto 0);
              o_Mem_To_Reg  : out std_logic;
              o_MemWrite    : out std_logic;
              o_RegWriteEn  : out std_logic );
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

    --- Internal Signal Declaration ---
    -- reg12
    signal s_PCPlus4_IFID_Out : std_logic_vector(31 downto 0);

    -- reg23
    signal s_hold_in, s_hold_out : std_logic := '0';
    signal s_hold32_in, s_hold32_out : std_logic_vector(31 downto 0) := "00000000000000000000000000000000";


begin


------------------------------ IF/ID Register ----------------------------------
    reg_1_2: register_IF_ID
        port map (i_Reset, i_Clock, i_IFID_Flush, i_IFID_Stall,
                  s_hold32_in, i_WD_Test,
                  -- BEGIN OUTPUTS
                  s_hold32_out, s_PCPlus4_IFID_Out);
----------------------------- End IF/ID Register -------------------------------

-- Please refer to the mips_pipeline_hazards for a working demonstration of all
-- registers together.

end structure;
