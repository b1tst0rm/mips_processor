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

    --- Internal Signal Declaration ---


begin


end structure;
