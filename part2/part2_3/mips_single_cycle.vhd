-- mips_single_cycle.vhd
-------------------------------------------------------------------------
-- DESCRIPTION: MIPS Straight-Line Single-Cycle Processor (32 bit)
-- implementation using structural VHDL
--
-- Supports all of the data-handling MIPS instructions:
-- add, addi, addiu, addu, and, andi, lui, lw, nor, xor, xori, or, ori,
-- slt, slti, sltiu, sltu, sll, srl, sra, sllv, srlv, srav, sw, sub, subu
--
-- AUTHOR: Daniel Limanowski
-------------------------------------------------------------------------

-- Enter this command while simulating to load intruction memory:
-- mem load -infile instruction_mem.hex -format hex /mips_single_cycle/fetch_instruc/instruc_mem/ram

library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;

entity mips_single_cycle is
    port( i_reset       : in std_logic;    -- resets everything to initial state
          i_clock       : in std_logic;    -- processor clock
          o_CF          : out std_logic;   -- carry flag
          o_OVF         : out std_logic;   -- overflow flag
          o_ZF          : out std_logic;    -- zero flag
          o_PC          : out std_logic_vector(29 downto 0) ); -- program counter (PC)
end mips_single_cycle;

architecture structure of mips_single_cycle is
    --- Component Declaration ---
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

    component fetch_logic is
        port ( i_Clock       : in std_logic;
               i_Reset       : in std_logic;
               o_Instruction : out std_logic_vector(31 downto 0);
               o_PC          : out std_logic_vector(29 downto 0) );
    end component;

    component control is
        port( i_Instruction    : in std_logic_vector(31 downto 0);
              o_RegDst         : out std_logic;
              o_Mem_To_Reg     : out std_logic;
              o_ALUOP		   : out std_logic_vector(3 downto 0);
              o_MemWrite       : out std_logic;
              o_ALUSrc         : out std_logic;
              o_RegWrite       : out std_logic );
    end component;

    component extender5to32 is
    port( input   : in std_logic_vector(4 downto 0);
          sign    : in std_logic;
          output  : out std_logic_vector(31 downto 0) );
    end component;

    component sel_alu_a is
        port( i_ALUSrc : in std_logic;
              i_RD1    : in std_logic_vector(31 downto 0);
              i_ALUOP  : in std_logic_vector(3 downto 0);
              i_shamt  : in std_logic_vector(31 downto 0);
              o_data   : out std_logic_vector(31 downto 0) );
    end component;

    component alu32 is
            port( i_A        : in  std_logic_vector(31 downto 0);
                  i_B        : in  std_logic_vector(31 downto 0);
                  i_ALUOP    : in  std_logic_vector(3  downto 0);
                  o_F        : out std_logic_vector(31 downto 0);
                  o_CarryOut : out std_logic;
                  o_Overflow : out std_logic;
                  o_Zero     : out std_logic );
    end component;

    component extender16to32 is
    port( input   : in std_logic_vector(15 downto 0);
          sign    : in std_logic;
          output  : out std_logic_vector(31 downto 0) );
    end component;

    component mem is
    	generic ( DATA_WIDTH : natural := 32; ADDR_WIDTH : natural := 10 );
    	port ( clk	: in std_logic;
    		   addr	: in natural range 0 to 2**ADDR_WIDTH - 1;
    		   data	: in std_logic_vector((DATA_WIDTH-1) downto 0);
    		   we	: in std_logic := '1';
    		   q	: out std_logic_vector((DATA_WIDTH-1) downto 0) );
    end component;

    component mux_2_1_struct is
        generic(N : integer := 32);
        port( i_X   : in std_logic_vector(N-1 downto 0);
              i_Y   : in std_logic_vector(N-1 downto 0);
              i_SEL : in std_logic;
              o_OUT : out std_logic_vector(N-1 downto 0) );
    end component;

    --- Internal Signal Declaration ---
    signal s_RegDst, s_Mem_To_Reg, s_MemWrite, s_ALUSrc, s_RegWrite : std_logic;
    signal s_ALUOp : std_logic_vector(3 downto 0);
    signal s_Instruc, s_SHAMT, s_WD, s_RD1, s_RD2, s_IMM, s_ALU_B, s_ALU_A, s_ALU_Out, s_DMem_Out : std_logic_vector(31 downto 0);
    signal s_WR : std_logic_vector(4 downto 0);
    signal s_mem_addr : natural range 0 to 2**10 - 1;

begin
    --This needs to be here otherwise we sometimes get out of bounds fatal errors....
    s_mem_addr <= 0 when (s_MemWrite = '0' or s_Mem_To_Reg = '0') else
                         to_integer(unsigned(s_Alu_Out)); -- must convert to a natural address to hand to mem module

    fetch_instruc: fetch_logic
        port map (i_clock, i_reset, s_Instruc, o_PC);

    control_logic: control
        port map (s_Instruc, s_RegDst, s_Mem_To_Reg, s_ALUOp, s_MemWrite, s_ALUSrc, s_RegWrite);

    mux_WR: mux_2_1_struct
        generic map (N => 5)
        port map (s_Instruc(20 downto 16), s_Instruc(15 downto 11), s_RegDst, s_WR);

    rf: register_file
        port map (i_clock, i_reset, s_WR, s_WD, s_RegWrite,
                  s_Instruc(25 downto 21), s_Instruc(20 downto 16), s_RD1, s_RD2);

    extend_imm: extender16to32
        port map (s_Instruc(15 downto 0), '1', s_IMM);

    mux_RD2_IMM: mux_2_1_struct
        port map (s_RD2, s_IMM, s_ALUSrc, s_ALU_B);

    extend_shamt: extender5to32
        port map (s_Instruc(10 downto 6), '1', s_SHAMT); -- 32 bit extend the shift amount

    sel_a: sel_alu_a
        port map (s_ALUSrc, s_RD1, s_ALUOp, s_SHAMT, s_ALU_A);

    alu: alu32
        port map (s_ALU_A, s_ALU_B, s_ALUOp, s_ALU_Out, o_CF, o_OVF, o_ZF);

    data_mem: mem
        port map (i_clock, s_mem_addr, s_RD2, s_MemWrite, s_DMem_Out);

    mux_Mem_To_Reg: mux_2_1_struct
        port map (s_ALU_Out, s_DMem_Out, s_Mem_To_Reg, s_WD);

end structure;
