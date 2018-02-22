-- alu_datapath.vhd
-------------------------------------------------------------------------
-- DESCRIPTION: MIPS datapath implementation with ALU and a memory module
-- utilizing structural VHDL
--
-- Allows for add/sub (i,u), lw, sw, xor, and, or, slt, slr, sll, sra, nor
--
-- AUTHOR: Daniel Limanowski
-------------------------------------------------------------------------

-- TODO: Implement a 2-1 mux to select between using RD/RT as dest register
-- See page 9 here: http://db.cs.duke.edu/courses/fall11/cps104/lects/mips.pdf
-- "Datapath for load operations"

-- NOTE: imm serves as the offset in lw/sw ops

-- NOTE: To use the memory module, you must load it into modelsim using the
-- following command during simulation
-- mem load -infile dmem.hex -format hex
-- ENSURE that dmex.hex sits in the same directory as the directory listed when
-- you type pwd in the simulation window

library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;

entity alu_datapath is
    port( i_RS          : in std_logic_vector(4 downto 0);
          i_RT          : in std_logic_vector(4 downto 0);
          i_RD          : in std_logic_vector(4 downto 0);
          i_ALUOP       : in std_logic_vector(3 downto 0); -- see mux7-1 for alu opcodes
          i_ALU_Src     : in std_logic; -- 0 to select 2nd register arg, 1 to select imm
          i_RegWrite_En : in std_logic; -- Enable writing to register file
          i_clock       : in std_logic;
          i_Mem_En      : in std_logic; -- Enable writing to memory unit
          i_Mem_Reg_Sel : in std_logic; -- select alu_out (0) or mem_out (1) to get written into register file
          i_IMM         : in std_logic_vector(15 downto 0);  -- 16 bit immediate value
          o_CF          : out std_logic; -- carry flag
          o_OVF         : out std_logic; -- overflow flag
          o_ZF          : out std_logic ); -- zero flag
end alu_datapath;

architecture structure of alu_datapath is
    --- Component Declaration ---
    component mux_2_1_struct is
        generic(N : integer := 32);
        port( i_X   : in std_logic_vector(N-1 downto 0);
              i_Y   : in std_logic_vector(N-1 downto 0);
              i_SEL : in std_logic;
              o_OUT : out std_logic_vector(N-1 downto 0) );
    end component;

    component register_file is
        port( i_CLK       : in std_logic;                         -- Clock
              i_RST       : in std_logic;                         -- Reset
              i_WR        : in std_logic_vector(4 downto 0);      -- Write Register
              i_WD        : in std_logic_vector(31 downto 0);     -- Write Data
              i_REGWRITE  : in std_logic;                         -- Write Enable
              i_RR1       : in std_logic_vector(4 downto 0);      -- Read Register 1
              i_RR2       : in std_logic_vector(4 downto 0);      -- Read Register 2
              o_RD1       : out std_logic_vector(31 downto 0);    -- Read Data 1
              o_RD2       : out std_logic_vector(31 downto 0) );  -- Read Data 2
    end component;

    component alu32 is
            port( i_A        : in  std_logic_vector(31 downto 0); -- Operand A
                  i_B        : in  std_logic_vector(31 downto 0); -- Operand B
                  i_ALUOP    : in  std_logic_vector(3  downto 0); -- minimum-wdith control
                  o_F        : out std_logic_vector(31 downto 0); -- Result
                  o_CarryOut : out std_logic;                     -- carry out flag
                  o_Overflow : out std_logic;                     -- overflow flag
                  o_Zero     : out std_logic );                   -- zero flag
    end component;

    component mem is
    	generic(DATA_WIDTH : natural := 32; ADDR_WIDTH : natural := 10);
    	port( clk	: in std_logic;
    		  addr	: in natural range 0 to 2**ADDR_WIDTH - 1;
    	      data	: in std_logic_vector((DATA_WIDTH-1) downto 0);
              we	: in std_logic := '1';
              q		: out std_logic_vector((DATA_WIDTH -1) downto 0) );
    end component;

    component extender16to32 is
        port( input	: in std_logic_vector(15 downto 0);         -- 16 bit input
              sign    : in std_logic;                           -- 0 for unsigned, 1 for signed
              output  : out std_logic_vector(31 downto 0) );    -- 32 bit extended output
    end component;

    --- Internal Signal Declaration ---
    signal s_alu_out : std_logic_vector(31 downto 0);
    signal s_regA_data, s_regB_data : std_logic_vector(31 downto 0);
    signal alu_B_value : std_logic_vector(31 downto 0);
    signal s_carry_out, s_reset : std_logic; -- carry out bit from add/sub operation
    signal s_imm_extended : std_logic_vector(31 downto 0);
    signal s_mem_out : std_logic_vector(31 downto 0);
    signal s_final_reg_out : std_logic_vector(31 downto 0);
    signal s_convert_to_nat : natural range 0 to 2**10 - 1;

begin
s_reset <= '0'; -- reset will always be at 0 for now
--- Component Instantiation ---
reg_file_32bit: register_file
    port map(i_clock, s_reset, i_RD, s_final_reg_out, i_RegWrite_En, i_RS, i_RT, s_regA_data, s_regB_data);

extend: extender16to32
    port map(i_IMM, '0', s_imm_extended); -- zero-extended to 32bit

imm_or_reg: mux_2_1_struct
    generic map (32) -- ";" not needed
    port map(s_regB_data, s_imm_extended, i_ALU_Src, alu_B_value);

ALU: alu32
    port map(s_regA_data, alu_B_value, i_ALUOP, s_alu_out, o_CF, o_OVF, o_ZF);

--This sometimes gives errors when s_alu_out is negative
s_convert_to_nat <= 0 when i_Mem_Reg_Sel = '0' else
                     to_integer(unsigned(s_alu_out)); -- must convert to a natural address to hand to mem module
memory_unit: mem
    generic map (32, 10)
    port map(i_clock, s_convert_to_nat, s_regB_data, i_Mem_En, s_mem_out);

mem_or_reg: mux_2_1_struct
    generic map (32)
    port map(s_alu_out, s_mem_out, i_Mem_Reg_Sel, s_final_reg_out);

end structure;
