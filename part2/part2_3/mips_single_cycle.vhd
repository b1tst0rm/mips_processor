-- mips_single_cycle.vhd
-------------------------------------------------------------------------
-- DESCRIPTION: MIPS Straight-Line Single-Cycle Processor (32 bit)
-- implementation using structural VHDL
--
-- Supports the following MIPS instructions:
-- add, addi, addiu, addu, and, andi, lui, lw, nor, xor, xori, or, ori,
-- slt, slti, sltiu, sltu, sll, srl, sra, sllv, srlv, srav, sw, sub, subu
--
-- AUTHOR: Daniel Limanowski
-------------------------------------------------------------------------

library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;

entity mips_single_cycle is
    port( i_reset       : in std_logic;  -- resets everything to initial state
          i_clock       : in std_logic;  -- processor clock
          o_CF          : out std_logic; -- carry flag
          o_OVF         : out std_logic; -- overflow flag
          o_ZF          : out std_logic ); -- zero flag
end mips_single_cycle;

architecture structure of mips_single_cycle is
    --- Component Declaration ---
    component register_file is
        port( i_CLK       : in std_logic;                         -- Clock
              i_RST       : in std_logic;                         -- Reset
              i_WR        : in std_logic_vector(4 downto 0);      -- Write Register
              i_WD        : in std_logic_vector(31 downto 0);     -- Write Data
              i_REGWRITE  : in std_logic;                         -- Write Enable
              i_RR1       : in std_logic_vector(4 downto 0);      -- Read Register 1
              i_RR2       : in std_logic_vector(4 downto 0);      -- Read Register 2
              o_RD1       : out std_logic_vector(31 downto 0);    -- Read Data 1
              o_RD2       : out std_logic_vector(31 downto 0) ); -- Read Data 2
    end component;

    component fetch_logic is
        port( i_Clock       : in std_logic;
              i_Reset       : in std_logic;
              o_Instruction : out std_logic_vector(31 downto 0) );
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
    port( input   : in std_logic_vector(4 downto 0);        -- 5 bit input
          sign    : in std_logic;                           -- 0 for unsigned, 1 for signed
          output  : out std_logic_vector(31 downto 0) );    -- 32 bit extended output
    end component;

    component sel_alu_a is
        port( i_ALUSrc : in std_logic; -- signal from control unit
              i_RD1    : in std_logic_vector(31 downto 0); -- signal from register file
              i_ALUOP  : in std_logic_vector(3 downto 0); -- signal from control unit
              i_shamt  : in std_logic_vector(31 downto 0); -- 32 bit shift amount
              o_data   : out std_logic_vector(31 downto 0) ); -- selected data
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

    component extender16to32 is
    port( input	: in std_logic_vector(15 downto 0);         -- 16 bit input
          sign    : in std_logic;                           -- 0 for unsigned, 1 for signed
          output  : out std_logic_vector(31 downto 0) );    -- 32 bit extended output
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
              o_OUT   : out std_logic_vector(N-1 downto 0) );
    end component;

    --- Internal Signal Declaration ---
    --TODO

begin
--TODO
end structure;
