-- STAGE3_EX.vhd
-------------------------------------------------------------------------
-- DESCRIPTION: Execute logic module for the pipeline processor.
-- This file represents all of the logic inside the third of five stages
-- in a pipelined MIPS processor.
--
--
-- AUTHOR: Daniel Limanowski
-------------------------------------------------------------------------

library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;

entity execution is
    port( i_Reset       : in std_logic;
          i_Clock       : in std_logic;
          i_RD1         : in std_logic_vector(31 downto 0);
          i_RD2         : in std_logic_vector(31 downto 0);
          i_IMM         : in std_logic_vector(31 downto 0);
          i_SHAMT       : in std_Logic_vector(31 downto 0);
          i_WR          : in std_logic_vector(4 downto 0);
          i_RegWriteEn  : in std_logic;
          i_ALUOP       : in std_logic_vector(3 downto 0);
          i_Sel_Mux2    : in std_logic;
          i_Mem_To_Reg  : in std_logic;
          i_MemWrite    : in std_logic;
          i_ALUSrc      : in std_logic );
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

    signal s_a_operand : std_logic_vector(31 downto 0);

begin

    select_a_operand: sel_alu_a
        port map(i_ALUSrc, i_RD1, i_ALUOP, i_SHAMT, i_Sel_Mux2, s_a_operand);

end structural;
