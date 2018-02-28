-- control.vhd
-------------------------------------------------------------------------
-- DESCRIPTION: Control logic module
--
-- AUTHOR: Vishal Joel
-------------------------------------------------------------------------

library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;

entity control_module is
    port( i_Instr              : in  std_logic_vector (31 downto 0);      -- Instruction
          o_RegDst             : out std_logic;
          o_Jump               : out std_logic;
          o_Branch             : out std_logic;
          o_Mem_Read           : out std_logic;
          o_Mem_To_Reg         : out std_logic;
          o_ALUOP		           : out std_logic_vector(3 downto 0);
          o_MemWrite           : out std_logic;
          o_ALUSrc             : out std_logic;
          o_RegWrite           : out std_logic);
    );
end control_module;
