-- hazard_detection.vhd
-------------------------------------------------------------------------
-- DESCRIPTION: Unit that detects and deals with various hazards in a
-- MIPS pipelined processor. Sits in the ID stage (2).
--
-- AUTHOR: Daniel Limanowski
-------------------------------------------------------------------------

library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;

entity hazard_detection is
    port( i_Branch           : in std_logic; -- this is an OR between BEQ and BNE
          i_BranchTaken      : in std_logic; -- 0 if branch not taken, 1 if branch taken (ie., beq evaluates to be equal)
          i_J                : in std_logic;
          i_JAL              : in std_logic;
          i_JR               : in std_logic;
          i_IDEX_MemRead     : in std_logic;
          i_IDEX_WriteReg    : in std_logic_vector(4 downto 0);
          i_EXMEM_WriteReg   : in std_logic_vector(4 downto 0);
          i_IFID_RS          : in std_logic_vector(4 downto 0);
          i_IFID_RT          : in std_logic_vector(4 downto 0);
          i_IDEX_RT          : in std_logic_vector(4 downto 0);
          o_Flush_IFID       : out std_logic;
          o_Flush_IDEX       : out std_logic;
          o_Stall_IFID       : out std_logic;
          o_Stall_PC         : out std_logic );
end hazard_detection;

architecture structural of hazard_detection is

begin


    process (i_Branch, i_BranchTaken, i_J, i_JAL, i_JR, i_IDEX_MemRead,
             i_IDEX_WriteReg, i_EXMEM_WriteReg, i_IFID_RS, i_IFID_RT, i_IDEX_RT)
    begin
        o_Flush_IFID <= '0';
        o_Flush_IDEX <= '0';
        o_Stall_IFID <= '0';
        o_Stall_PC   <= '0'; -- reset all outputs each cycle to prevent them from being inferred as latches
        if (((i_IFID_RT = i_IDEX_RT) or (i_IDEX_RT = i_IFID_RS)) and (i_IDEX_MemRead = '1')) then
            -- Load-use hazard detected
            o_Flush_IDEX <= '1';
            o_Stall_IFID <= '1';
            o_Stall_PC <= '1';
        elsif ((i_JAL ='1') or (i_J = '1') or (i_BranchTaken = '1')) then
            -- A Jump-and-link Jump command has been detected OR a branch was
            -- taken, so we need to flush IF/ID register
            o_Flush_IFID <= '1';
        elsif ((i_IFID_RS = i_IDEX_WriteReg) and (i_JR = '1')) then
            -- Jump-Return (data) hazard detected
            o_Flush_IDEX <= '1';
            o_Stall_PC <= '1';
            o_Stall_IFID <= '1';
        elsif ((i_IDEX_WriteReg /= "00000") and (i_Branch = '1') and
        ((i_IDEX_WriteReg = i_IFID_RS) or (i_IDEX_WriteReg = i_IFID_RT))) then
            -- Branch instruction detected, need to insert a "bubble"
            o_Stall_PC <= '1';
            o_Stall_IFID <= '1';
            o_Flush_IDEX <= '1';
        else
            -- No conditions taken, reset all signals to 0
            o_Flush_IFID <= '0';
            o_Flush_IDEX <= '0';
            o_Stall_IFID <= '0';
            o_Stall_PC <= '0';
        end if;

    end process;

end structural;
