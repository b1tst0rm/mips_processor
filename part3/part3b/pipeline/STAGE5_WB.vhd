-- STAGE5_WB.vhd
-------------------------------------------------------------------------
-- DESCRIPTION: Write-back logic module for the pipeline processor.
-- This file represents all of the logic inside the last of five stages
-- in a pipelined MIPS processor.
--
-- AUTHOR: Daniel Limanowski
-------------------------------------------------------------------------

library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;

entity writeback is
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
end writeback;

architecture structural of writeback is
    component mux2to1_32bit is
        port( i_X   : in std_logic_vector(31 downto 0);
              i_Y   : in std_logic_vector(31 downto 0);
              i_SEL : in std_logic;
              o_OUT   : out std_logic_vector(31 downto 0) );
    end component;

    component fulladder_32bit is
        port( i_A    : in std_logic_vector(31 downto 0);
              i_B    : in std_logic_vector(31 downto 0);
              i_Cin  : in std_logic;
              o_Cout : out std_logic;
              o_S    : out std_logic_vector(31 downto 0) );
    end component;

    signal s_mux_mem_out, s_mux_wb_out : std_logic_vector(31 downto 0);

begin

    o_RegWriteEn <= i_RegWriteEn;
    o_WD <= s_mux_wb_out;
    o_WR <= i_WR;
    o_JAL <= i_JAL;

    mux_mem: mux2to1_32bit
        port map(i_ALUOut, i_MemOut, i_Mem_To_Reg, s_mux_mem_out);

    mux_wb_final: mux2to1_32bit
        port map(s_mux_mem_out, i_PCPlus4, i_JAL, s_mux_wb_out);

end structural;
