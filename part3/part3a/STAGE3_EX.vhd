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
    port( i_Reset         : in std_logic;
          i_Clock         : in std_logic;
          -- TODO
          o_PCPlus4       : out std_logic_vector(31 downto 0) );
end execution;

architecture structural of execution is


begin

-- TODO

end structural;
