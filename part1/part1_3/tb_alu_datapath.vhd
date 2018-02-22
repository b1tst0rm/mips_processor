-- tb_alu_datapath.vhd
-------------------------------------------------------------------------
-- DESCRIPTION: This file contains a simple VHDL testbench for the
-- MIPS-like datapath with ALU and memory module in alu_datapath.vhd

-- AUTHOR: Daniel Limanowski
-------------------------------------------------------------------------
-- TODO: add an if statement in alu_datapath to only convert to natural
-- if we are using that value! (otherwise metavalue detected err pops up while simulating)

library IEEE;
use IEEE.std_logic_1164.all;

entity tb_alu_datapath is
    generic(gCLK_HPER   : time := 50 ns);
end tb_alu_datapath;

architecture behavior of tb_alu_datapath is
    -- Calculate the clock period as twice the half-period
    constant cCLK_PER  : time := gCLK_HPER * 2;

    component alu_datapath is
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
    end component;
    -- Temporary signals to connect to the datapath component
    signal s_Clock, s_Reg_WE, s_ALU_Src, s_Mem_WE, s_Mem_Reg_Sel : std_logic;
    signal s_ALUOP : std_logic_vector(3 downto 0);
    signal s_IMM : std_logic_vector(15 downto 0);
    signal s_RS, s_RT, s_RD : std_logic_vector(4 downto 0);
    signal s_CF, s_OVF, s_ZF : std_logic; -- flags (we don't alter these)

begin
    DUT: alu_datapath
        port map(s_RS, s_RT, s_RD, s_ALUOP, s_ALU_Src, s_Reg_WE, s_Clock,
                     s_Mem_WE, s_Mem_Reg_Sel, s_IMM, s_CF, s_OVF, s_ZF);

    -- This process sets the clock value (low for gCLK_HPER, then high
    -- for gCLK_HPER). Absent a "wait" command, processes restart
    -- at the beginning once they have reached the final statement.
    P_CLK: process
    begin
        s_Clock <= '0';
        wait for gCLK_HPER;
        s_Clock <= '1';
        wait for gCLK_HPER;
    end process;

    -- Testbench process
    P_TB: process
    begin
        wait until s_Clock = '0'; -- perform the command (test) on CLOCK LOW

        -- addi $25, $0 , 0 # Load &A into $25
        s_RS <= (others => '0'); -- RS = 0
        s_RT <= (others => '0'); -- Don't care for this op (using imm)
        s_RD <= (0 => '1', 3 => '1', 4 => '1', others => '0'); -- RD = 25
        s_ALUOP <= "0010"; -- addition
        s_ALU_Src <= '1'; -- select imm
        s_Reg_WE <= '1'; -- write value to register
        s_Mem_WE <= '0'; -- do not write to memory
        s_Mem_Reg_Sel <= '0'; -- select writing the immediate to the register
        s_IMM <= (others => '0'); -- immediate value = 0
        wait for cCLK_PER; -- wait a full clock cycle to start next command

        -- addi $24, $0 , 3 # Load 3 into $24
        s_RS <= (others => '0'); -- RS = 0
        s_RT <= (others => '0'); -- Don't care for this op (using imm)
        s_RD <= (3 => '1', 4 => '1', others => '0'); -- RD = 24
        s_ALUOP <= "0010"; -- addition
        s_ALU_Src <= '1'; -- select imm
        s_Reg_WE <= '1'; -- write value to register
        s_Mem_WE <= '0'; -- do not write to memory
        s_Mem_Reg_Sel <= '0'; -- select alu_out to write to register
        s_IMM <= (0 => '1', 1 => '1', others => '0'); -- immediate value = 3
        wait for cCLK_PER; -- wait a full clock cycle to start next command

        -- slt $23, $25, $24 # if $25 < $24, set slt to 1 (it should)
        s_RS <= (0 => '1', 3 => '1', 4 => '1', others => '0'); -- RS = 25
        s_RT <= (3 => '1', 4 => '1', others => '0'); -- RT = 24
        s_RD <= (0 => '1', 1 => '1', 2 => '1', 4 => '1', others => '0'); -- RD = 23
        s_ALUOP <= "0111"; -- set on less than (SLT)
        s_ALU_Src <= '0'; -- select reg 2
        s_Reg_WE <= '1'; -- write value to register
        s_Mem_WE <= '0'; -- do not write to memory
        s_Mem_Reg_Sel <= '0'; -- select alu_out to write to register
        s_IMM <= (others => '0'); -- don't care
        wait for cCLK_PER; -- wait a full clock cycle to start next command

    end process;
end behavior;
