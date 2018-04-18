-- forwarding_logic.vhd
-------------------------------------------------------------------------
-- DESCRIPTION: Unit that processes forwarding for data hazard avoidance.
-- This unit sits in the EX (Execute) stage of a MIPS Pipelined processor.
--
-------------------------------------------------------------------------

library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;

entity forwarding_logic is
    port( i_Branch             : in std_logic; -- this is an OR between BEQ and BNE
          i_JR                 : in std_logic;
          i_EXMEM_RegWriteEn   : in std_logic;
          i_MEMWB_RegWriteEn   : in std_logic;
          i_EXMEM_WriteReg     : in std_logic_vector(4 downto 0);
          i_MEMWB_WriteReg     : in std_logic_vector(4 downto 0);
          i_IFID_RS            : in std_logic_vector(4 downto 0);
          i_IDEX_RS            : in std_logic_vector(4 downto 0);
          i_IFID_RT            : in std_logic_vector(4 downto 0);
          i_IDEX_RT            : in std_logic_vector(4 downto 0);
          i_EXMEM_RT           : in std_logic_vector(4 downto 0);
          o_Forward_ALU_A_Sel1 : out std_logic;
          o_Forward_ALU_A_Sel2 : out std_logic;
          o_Forward_ALU_B_Sel1 : out std_logic;
          o_Forward_ALU_B_Sel2 : out std_logic;
          o_Forward_RS_Sel1    : out std_logic;
          o_Forward_RS_Sel2    : out std_logic;
          o_Forward_RT_Sel1    : out std_logic;
          o_Forward_RT_Sel2    : out std_logic );
end forwarding_logic;

architecture structural of forwarding_logic is

    -- Intermediary signals that are initialized to 0
    signal s_Forward_ALU_A_Sel1, s_Forward_ALU_A_Sel2, s_Forward_ALU_B_Sel1,
           s_Forward_ALU_B_Sel2, s_Forward_RS_Sel1, s_Forward_RS_Sel2,
           s_Forward_RT_Sel1, s_Forward_RT_Sel2 : std_logic := '0';

begin

    -- Forwarding logic unit (FLU) checks the inputs against various conditions
    -- and forwards the proper data.
    process (i_Branch, i_JR, i_EXMEM_RegWriteEn, i_MEMWB_RegWriteEn,
             i_EXMEM_WriteReg, i_MEMWB_WriteReg, i_IFID_RS, i_IDEX_RS, i_IFID_RT,
             i_IDEX_RT, i_EXMEM_RT) -- sensitivity list of inputs
    begin -- the process of evaluating if the inputs deem forwarding

        -- ALU INPUT A
        if ((i_EXMEM_WriteReg /= "00000") and (i_EXMEM_RegWriteEn = '1') and
        (i_EXMEM_WriteReg = i_IDEX_RS)) then
            -- EX HAZARD
            s_Forward_ALU_A_Sel1 <= '1';
            s_Forward_ALU_A_Sel2 <= '1';
        elsif ((i_MEMWB_WriteReg /= "00000") and (i_MEMWB_RegWriteEn = '1') and
        (i_MEMWB_WriteReg = i_IDEX_RS)) then
            -- MEM HAZARD
            s_Forward_ALU_A_Sel1 <= '1';
            s_Forward_ALU_A_Sel2 <= '0';
        else
            s_Forward_ALU_A_Sel1 <= '0';
            s_Forward_ALU_A_Sel2 <= '0';
        end if;

        -- ALU INPUT B
        if ((i_EXMEM_WriteReg /= "00000") and (i_EXMEM_RegWriteEn = '1') and
        (i_EXMEM_WriteReg = i_IDEX_RT)) then
            -- EX HAZARD
            s_Forward_ALU_B_Sel1 <= '1';
            s_Forward_ALU_B_Sel2 <= '1';
        elsif ((i_MEMWB_WriteReg /= "00000") and (i_MEMWB_RegWriteEn = '1') and
        (i_MEMWB_WriteReg = i_IDEX_RT)) then
            -- MEM HAZARD
            s_Forward_ALU_B_Sel1 <= '1';
            s_Forward_ALU_B_Sel2 <= '0';
        else
            s_Forward_ALU_B_Sel1 <= '0';
            s_Forward_ALU_B_Sel2 <= '0';
        end if;

        -- BRANCH W/ RS
        if ((i_EXMEM_WriteReg /= "00000") and ((i_JR = '1') or (i_Branch = '1')) and
        (i_EXMEM_WriteReg = i_IFID_RS)) then
            s_Forward_RS_Sel1 <= '1';
            s_Forward_RS_Sel2 <= '1';
        elsif ((i_MEMWB_WriteReg /= "00000") and ((i_JR = '1') or (i_Branch = '1')) and
        (i_MEMWB_WriteReg = i_IFID_RS)) then
            s_Forward_RS_Sel1 <= '1';
            s_Forward_RS_Sel2 <= '0';
        else
            s_Forward_RS_Sel1 <= '0';
            s_Forward_RS_Sel2 <= '0';
        end if;

        -- BRANCH W/ RT
        if ((i_EXMEM_WriteReg /= "00000") and (i_Branch = '1') and
        (i_EXMEM_WriteReg = i_IFID_RT)) then
            s_Forward_RS_Sel1 <= '1';
            s_Forward_RS_Sel2 <= '1';
        elsif ((i_MEMWB_WriteReg /= "00000") and (i_Branch = '1') and
        (i_MEMWB_WriteReg = i_IFID_RT)) then
            s_Forward_RS_Sel1 <= '1';
            s_Forward_RS_Sel2 <= '0';
        else
            s_Forward_RS_Sel1 <= '0';
            s_Forward_RS_Sel2 <= '0';
        end if;

    end process;

    o_Forward_ALU_A_Sel1 <= s_Forward_ALU_A_Sel1;
    o_Forward_ALU_A_Sel2 <= s_Forward_ALU_A_Sel2;
    o_Forward_ALU_B_Sel1 <= s_Forward_ALU_B_Sel1;
    o_Forward_ALU_B_Sel2 <= s_Forward_ALU_B_Sel2;
    o_Forward_RS_Sel1 <= s_Forward_RS_Sel1;
    o_Forward_RS_Sel2 <= s_Forward_RS_Sel2;
    o_Forward_RT_Sel1 <= s_Forward_RT_Sel1;
    o_Forward_RT_Sel2 <= s_Forward_RT_Sel2;

end structural;
