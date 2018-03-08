-- tb_control.vhd
-------------------------------------------------------------------------
-- DESCRIPTION: This file contains a testbench for the structural control
-- unit implementation
--
-- TESTS THE FOLLOWING FILES:
--   control.vhd
--
-- AUTHOR: Daniel Limanowski
-------------------------------------------------------------------------

library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;

entity tb_control is
end tb_control;

--- Define the architecture ---
architecture structure of tb_control is
--- Component Declaration ---
    -- Control unit
    component control is
        port( i_Instruction    : in std_logic_vector(31 downto 0);
              o_RegDst         : out std_logic;
              o_Mem_To_Reg     : out std_logic;
              o_ALUOP		   : out std_logic_vector(3 downto 0);
              o_MemWrite       : out std_logic;
              o_ALUSrc         : out std_logic;
              o_RegWrite       : out std_logic );
    end component;

    signal s_in       : std_logic_vector(31 downto 0);  -- instruction to test against (our only input)
    signal s_RegDst,
     s_Mem_To_Reg,
     s_MemWrite,
     s_ALUSrc,
     s_RegWrite       : std_logic;                      -- output signals to verify
    signal s_ALUOP    : std_logic_vector(3 downto 0);   -- another output signal to verify

begin
------------- testbench for the control unit ----------
    ctl_unit: control
        port map(s_in, s_RegDst, s_Mem_To_Reg, s_ALUOP, s_MemWrite, s_ALUSrc, s_RegWrite);

    process -- inside a process all statements are executed sequentially
    begin

        ------------- TEST ---------------
        report "Beginning SLT test";
        -- zero out the instruction
        s_in <= std_logic_vector(to_unsigned(0, s_in'length));

        wait for 100 ns;
        s_in(31 downto 26) <= "000000";
        s_in(5 downto 0) <= "101010";

        wait for 100 ns;

        assert s_RegDst = '1' report "RegDst incorrect." severity failure;
        assert s_Mem_To_Reg = '0' report "o_Mem_To_Reg incorrect." severity failure;
        assert s_ALUOP = "0111" report "ALUOp incorrect." severity failure;
        assert s_MemWrite = '0' report "MemWrite incorrect." severity failure;
        assert s_ALUSrc = '0' report "ALUSrc incorrect." severity failure;
        assert s_RegWrite = '1' report "RegWrite incorrect." severity failure;
        ------------- END TEST ------------

        ------------- TEST ---------------
        report "Beginning ADD test";
        wait for 100 ns;
        s_in <= "00000001010010110100100000100000";
        wait for 100 ns;

        assert s_RegDst = '1' report "RegDst incorrect." severity failure;
        assert s_Mem_To_Reg = '0' report "o_Mem_To_Reg incorrect." severity failure;
        assert s_ALUOP = "0010" report "ALUOp incorrect." severity failure;
        assert s_MemWrite = '0' report "MemWrite incorrect." severity failure;
        assert s_ALUSrc = '0' report "ALUSrc incorrect." severity failure;
        assert s_RegWrite = '1' report "RegWrite incorrect." severity failure;
        ------------- END TEST ------------

        ------------- TEST ---------------
        report "Beginning ADDI test";
        -- zero out the instruction
        s_in <= std_logic_vector(to_unsigned(0, s_in'length));

        wait for 100 ns;
        s_in <= "00100000000000000000000000000000";

        wait for 400 ns;

        assert s_RegDst = '0' report "RegDst incorrect." severity failure;
        assert s_Mem_To_Reg = '0' report "o_Mem_To_Reg incorrect." severity failure;
        assert s_ALUOP = "0010" report "ALUOp incorrect." severity failure;
        assert s_MemWrite = '0' report "MemWrite incorrect." severity failure;
        assert s_ALUSrc = '1' report "ALUSrc incorrect." severity failure;
        assert s_RegWrite = '1' report "RegWrite incorrect." severity failure;
        ------------- END TEST ------------

        ------------- TEST ---------------
        report "Beginning ADDIU test";
        -- zero out the instruction
        s_in <= std_logic_vector(to_unsigned(0, s_in'length));

        wait for 100 ns;
        s_in(31 downto 26) <= "001001";
        s_in(5 downto 0) <= "------";

        wait for 100 ns;

        assert s_RegDst = '0' report "RegDst incorrect." severity failure;
        assert s_Mem_To_Reg = '0' report "o_Mem_To_Reg incorrect." severity failure;
        assert s_ALUOP = "0010" report "ALUOp incorrect." severity failure;
        assert s_MemWrite = '0' report "MemWrite incorrect." severity failure;
        assert s_ALUSrc = '1' report "ALUSrc incorrect." severity failure;
        assert s_RegWrite = '1' report "RegWrite incorrect." severity failure;
        ------------- END TEST ------------

        ------------- TEST ---------------
        report "Beginning ADDU test";
        -- zero out the instruction
        s_in <= std_logic_vector(to_unsigned(0, s_in'length));

        wait for 100 ns;
        s_in(31 downto 26) <= "000000";
        s_in(5 downto 0) <= "100001";

        wait for 100 ns;

        assert s_RegDst = '1' report "RegDst incorrect." severity failure;
        assert s_Mem_To_Reg = '0' report "o_Mem_To_Reg incorrect." severity failure;
        assert s_ALUOP = "0010" report "ALUOp incorrect." severity failure;
        assert s_MemWrite = '0' report "MemWrite incorrect." severity failure;
        assert s_ALUSrc = '0' report "ALUSrc incorrect." severity failure;
        assert s_RegWrite = '1' report "RegWrite incorrect." severity failure;
        ------------- END TEST ------------

        ------------- TEST ---------------
        report "Beginning AND test";
        -- zero out the instruction
        s_in <= std_logic_vector(to_unsigned(0, s_in'length));

        wait for 100 ns;
        s_in(31 downto 26) <= "000000";
        s_in(5 downto 0) <= "100100";

        wait for 100 ns;

        assert s_RegDst = '1' report "RegDst incorrect." severity failure;
        assert s_Mem_To_Reg = '0' report "o_Mem_To_Reg incorrect." severity failure;
        assert s_ALUOP = "0000" report "ALUOp incorrect." severity failure;
        assert s_MemWrite = '0' report "MemWrite incorrect." severity failure;
        assert s_ALUSrc = '0' report "ALUSrc incorrect." severity failure;
        assert s_RegWrite = '1' report "RegWrite incorrect." severity failure;
        ------------- END TEST ------------

        ------------- TEST ---------------
        report "Beginning ANDI test";
        -- zero out the instruction
        s_in <= std_logic_vector(to_unsigned(0, s_in'length));

        wait for 100 ns;
        s_in(31 downto 26) <= "001100";
        s_in(5 downto 0) <= "------";

        wait for 100 ns;

        assert s_RegDst = '0' report "RegDst incorrect." severity failure;
        assert s_Mem_To_Reg = '0' report "o_Mem_To_Reg incorrect." severity failure;
        assert s_ALUOP = "0000" report "ALUOp incorrect." severity failure;
        assert s_MemWrite = '0' report "MemWrite incorrect." severity failure;
        assert s_ALUSrc = '1' report "ALUSrc incorrect." severity failure;
        assert s_RegWrite = '1' report "RegWrite incorrect." severity failure;
        ------------- END TEST ------------

        ------------- TEST ---------------
        report "Beginning LUI test";
        -- zero out the instruction
        s_in <= std_logic_vector(to_unsigned(0, s_in'length));

        wait for 100 ns;
        s_in(31 downto 26) <= "001111";
        s_in(5 downto 0) <= "------";

        wait for 100 ns;

        assert s_RegDst = '0' report "RegDst incorrect." severity failure;
        assert s_Mem_To_Reg = '0' report "o_Mem_To_Reg incorrect." severity failure;
        assert s_ALUOP = "1001" report "ALUOp incorrect." severity failure;
        assert s_MemWrite = '0' report "MemWrite incorrect." severity failure;
        assert s_ALUSrc = '1' report "ALUSrc incorrect." severity failure;
        assert s_RegWrite = '1' report "RegWrite incorrect." severity failure;
        ------------- END TEST ------------

        ------------- TEST ---------------
        report "Beginning LW test";
        -- zero out the instruction
        s_in <= std_logic_vector(to_unsigned(0, s_in'length));

        wait for 100 ns;
        s_in(31 downto 26) <= "100011";
        s_in(5 downto 0) <= "------";

        wait for 100 ns;

        assert s_RegDst = '0' report "RegDst incorrect." severity failure;
        assert s_Mem_To_Reg = '1' report "o_Mem_To_Reg incorrect." severity failure;
        assert s_ALUOP = "0000" report "ALUOp incorrect." severity failure;
        assert s_MemWrite = '0' report "MemWrite incorrect." severity failure;
        assert s_ALUSrc = '1' report "ALUSrc incorrect." severity failure;
        assert s_RegWrite = '1' report "RegWrite incorrect." severity failure;
        ------------- END TEST ------------

        ------------- TEST ---------------
        report "Beginning NOR test";
        -- zero out the instruction
        s_in <= std_logic_vector(to_unsigned(0, s_in'length));

        wait for 100 ns;
        s_in(31 downto 26) <= "100111";
        s_in(5 downto 0) <= "------";

        wait for 100 ns;

        assert s_RegDst = '1' report "RegDst incorrect." severity failure;
        assert s_Mem_To_Reg = '0' report "o_Mem_To_Reg incorrect." severity failure;
        assert s_ALUOP = "1100" report "ALUOp incorrect." severity failure;
        assert s_MemWrite = '0' report "MemWrite incorrect." severity failure;
        assert s_ALUSrc = '0' report "ALUSrc incorrect." severity failure;
        assert s_RegWrite = '1' report "RegWrite incorrect." severity failure;
        ------------- END TEST ------------

        ------------- TEST ---------------
        report "Beginning XOR test";
        -- zero out the instruction
        s_in <= std_logic_vector(to_unsigned(0, s_in'length));

        wait for 100 ns;
        s_in(31 downto 26) <= "000000";
        s_in(5 downto 0) <= "100110";

        wait for 100 ns;

        assert s_RegDst = '1' report "RegDst incorrect." severity failure;
        assert s_Mem_To_Reg = '0' report "o_Mem_To_Reg incorrect." severity failure;
        assert s_ALUOP = "1101" report "ALUOp incorrect." severity failure;
        assert s_MemWrite = '0' report "MemWrite incorrect." severity failure;
        assert s_ALUSrc = '0' report "ALUSrc incorrect." severity failure;
        assert s_RegWrite = '1' report "RegWrite incorrect." severity failure;
        ------------- END TEST ------------

        ------------- TEST ---------------
        report "Beginning XORI test";
        -- zero out the instruction
        s_in <= std_logic_vector(to_unsigned(0, s_in'length));

        wait for 100 ns;
        s_in(31 downto 26) <= "001110";
        s_in(5 downto 0) <= "------";

        wait for 100 ns;

        assert s_RegDst = '0' report "RegDst incorrect." severity failure;
        assert s_Mem_To_Reg = '0' report "o_Mem_To_Reg incorrect." severity failure;
        assert s_ALUOP = "1101" report "ALUOp incorrect." severity failure;
        assert s_MemWrite = '0' report "MemWrite incorrect." severity failure;
        assert s_ALUSrc = '1' report "ALUSrc incorrect." severity failure;
        assert s_RegWrite = '1' report "RegWrite incorrect." severity failure;
        ------------- END TEST ------------

        ------------- TEST ---------------
        report "Beginning OR test";
        -- zero out the instruction
        s_in <= std_logic_vector(to_unsigned(0, s_in'length));

        wait for 100 ns;
        s_in(31 downto 26) <= "000000";
        s_in(5 downto 0) <= "100101";

        wait for 100 ns;

        assert s_RegDst = '1' report "RegDst incorrect." severity failure;
        assert s_Mem_To_Reg = '0' report "o_Mem_To_Reg incorrect." severity failure;
        assert s_ALUOP = "0001" report "ALUOp incorrect." severity failure;
        assert s_MemWrite = '0' report "MemWrite incorrect." severity failure;
        assert s_ALUSrc = '0' report "ALUSrc incorrect." severity failure;
        assert s_RegWrite = '1' report "RegWrite incorrect." severity failure;
        ------------- END TEST ------------

        ------------- TEST ---------------
        report "Beginning ORI test";
        -- zero out the instruction
        s_in <= std_logic_vector(to_unsigned(0, s_in'length));

        wait for 100 ns;
        s_in(31 downto 26) <= "001101";
        s_in(5 downto 0) <= "------";

        wait for 100 ns;

        assert s_RegDst = '0' report "RegDst incorrect." severity failure;
        assert s_Mem_To_Reg = '0' report "o_Mem_To_Reg incorrect." severity failure;
        assert s_ALUOP = "0001" report "ALUOp incorrect." severity failure;
        assert s_MemWrite = '0' report "MemWrite incorrect." severity failure;
        assert s_ALUSrc = '1' report "ALUSrc incorrect." severity failure;
        assert s_RegWrite = '1' report "RegWrite incorrect." severity failure;
        ------------- END TEST ------------

        ------------- TEST ---------------
        report "Beginning SLTI test";
        -- zero out the instruction
        s_in <= std_logic_vector(to_unsigned(0, s_in'length));

        wait for 100 ns;
        s_in(31 downto 26) <= "001010";
        s_in(5 downto 0) <= "------";

        wait for 100 ns;

        assert s_RegDst = '0' report "RegDst incorrect." severity failure;
        assert s_Mem_To_Reg = '0' report "o_Mem_To_Reg incorrect." severity failure;
        assert s_ALUOP = "0111" report "ALUOp incorrect." severity failure;
        assert s_MemWrite = '0' report "MemWrite incorrect." severity failure;
        assert s_ALUSrc = '1' report "ALUSrc incorrect." severity failure;
        assert s_RegWrite = '1' report "RegWrite incorrect." severity failure;
        ------------- END TEST ------------

        ------------- TEST ---------------
        report "Beginning SLTIU test";
        -- zero out the instruction
        s_in <= std_logic_vector(to_unsigned(0, s_in'length));

        wait for 100 ns;
        s_in(31 downto 26) <= "001011";
        s_in(5 downto 0) <= "------";

        wait for 100 ns;

        assert s_RegDst = '0' report "RegDst incorrect." severity failure;
        assert s_Mem_To_Reg = '0' report "o_Mem_To_Reg incorrect." severity failure;
        assert s_ALUOP = "0111" report "ALUOp incorrect." severity failure;
        assert s_MemWrite = '0' report "MemWrite incorrect." severity failure;
        assert s_ALUSrc = '1' report "ALUSrc incorrect." severity failure;
        assert s_RegWrite = '1' report "RegWrite incorrect." severity failure;
        ------------- END TEST ------------

        ------------- TEST ---------------
        report "Beginning SLL test";
        -- zero out the instruction
        s_in <= std_logic_vector(to_unsigned(0, s_in'length));

        wait for 100 ns;
        s_in(31 downto 26) <= "000000";
        s_in(5 downto 0) <= "000000";

        wait for 100 ns;

        assert s_RegDst = '1' report "RegDst incorrect." severity failure;
        assert s_Mem_To_Reg = '0' report "o_Mem_To_Reg incorrect." severity failure;
        assert s_ALUOP = "1001" report "ALUOp incorrect." severity failure;
        assert s_MemWrite = '0' report "MemWrite incorrect." severity failure;
        assert s_ALUSrc = '0' report "ALUSrc incorrect." severity failure;
        assert s_RegWrite = '1' report "RegWrite incorrect." severity failure;
        ------------- END TEST ------------

        ------------- TEST ---------------
        report "Beginning SRL test";
        -- zero out the instruction
        s_in <= std_logic_vector(to_unsigned(0, s_in'length));

        wait for 100 ns;
        s_in(31 downto 26) <= "000000";
        s_in(5 downto 0) <= "000010";

        wait for 100 ns;

        assert s_RegDst = '1' report "RegDst incorrect." severity failure;
        assert s_Mem_To_Reg = '0' report "o_Mem_To_Reg incorrect." severity failure;
        assert s_ALUOP = "1000" report "ALUOp incorrect." severity failure;
        assert s_MemWrite = '0' report "MemWrite incorrect." severity failure;
        assert s_ALUSrc = '0' report "ALUSrc incorrect." severity failure;
        assert s_RegWrite = '1' report "RegWrite incorrect." severity failure;
        ------------- END TEST ------------

        ------------- TEST ---------------
        report "Beginning SRA test";
        -- zero out the instruction
        s_in <= std_logic_vector(to_unsigned(0, s_in'length));

        wait for 100 ns;
        s_in(31 downto 26) <= "000000";
        s_in(5 downto 0) <= "000011";

        wait for 100 ns;

        assert s_RegDst = '1' report "RegDst incorrect." severity failure;
        assert s_Mem_To_Reg = '0' report "o_Mem_To_Reg incorrect." severity failure;
        assert s_ALUOP = "1010" report "ALUOp incorrect." severity failure;
        assert s_MemWrite = '0' report "MemWrite incorrect." severity failure;
        assert s_ALUSrc = '0' report "ALUSrc incorrect." severity failure;
        assert s_RegWrite = '1' report "RegWrite incorrect." severity failure;
        ------------- END TEST ------------

        ------------- TEST ---------------
        report "Beginning SLLV test";
        -- zero out the instruction
        s_in <= std_logic_vector(to_unsigned(0, s_in'length));

        wait for 100 ns;
        s_in(31 downto 26) <= "000000";
        s_in(5 downto 0) <= "000100";

        wait for 100 ns;

        assert s_RegDst = '1' report "RegDst incorrect." severity failure;
        assert s_Mem_To_Reg = '0' report "o_Mem_To_Reg incorrect." severity failure;
        assert s_ALUOP = "1001" report "ALUOp incorrect." severity failure;
        assert s_MemWrite = '0' report "MemWrite incorrect." severity failure;
        assert s_ALUSrc = '0' report "ALUSrc incorrect." severity failure;
        assert s_RegWrite = '1' report "RegWrite incorrect." severity failure;
        ------------- END TEST ------------

        ------------- TEST ---------------
        report "Beginning SRLV test";
        -- zero out the instruction
        s_in <= std_logic_vector(to_unsigned(0, s_in'length));

        wait for 100 ns;
        s_in(31 downto 26) <= "000000";
        s_in(5 downto 0) <= "000110";

        wait for 100 ns;

        assert s_RegDst = '1' report "RegDst incorrect." severity failure;
        assert s_Mem_To_Reg = '0' report "o_Mem_To_Reg incorrect." severity failure;
        assert s_ALUOP = "1000" report "ALUOp incorrect." severity failure;
        assert s_MemWrite = '0' report "MemWrite incorrect." severity failure;
        assert s_ALUSrc = '0' report "ALUSrc incorrect." severity failure;
        assert s_RegWrite = '1' report "RegWrite incorrect." severity failure;
        ------------- END TEST ------------

        ------------- TEST ---------------
        report "Beginning SRAV test";
        -- zero out the instruction
        s_in <= std_logic_vector(to_unsigned(0, s_in'length));

        wait for 100 ns;
        s_in(31 downto 26) <= "000111";
        s_in(5 downto 0) <= "------";

        wait for 100 ns;

        assert s_RegDst = '1' report "RegDst incorrect." severity failure;
        assert s_Mem_To_Reg = '0' report "o_Mem_To_Reg incorrect." severity failure;
        assert s_ALUOP = "1010" report "ALUOp incorrect." severity failure;
        assert s_MemWrite = '0' report "MemWrite incorrect." severity failure;
        assert s_ALUSrc = '0' report "ALUSrc incorrect." severity failure;
        assert s_RegWrite = '1' report "RegWrite incorrect." severity failure;
        ------------- END TEST ------------

        ------------- TEST ---------------
        report "Beginning SW test";
        -- zero out the instruction
        s_in <= std_logic_vector(to_unsigned(0, s_in'length));

        wait for 100 ns;
        s_in(31 downto 26) <= "101011";
        s_in(5 downto 0) <= "------";

        wait for 100 ns;

        assert s_RegDst = '0' or s_RegDst = '1' report "RegDst incorrect." severity failure;
        assert s_Mem_To_Reg = '0' or  s_Mem_To_Reg = '1' report "o_Mem_To_Reg incorrect." severity failure;
        assert s_ALUOP = "0000" report "ALUOp incorrect." severity failure;
        assert s_MemWrite = '1' report "MemWrite incorrect." severity failure;
        assert s_ALUSrc = '1' report "ALUSrc incorrect." severity failure;
        assert s_RegWrite = '0' report "RegWrite incorrect." severity failure;
        ------------- END TEST ------------

        ------------- TEST ---------------
        report "Beginning SUB test";
        -- zero out the instruction
        s_in <= std_logic_vector(to_unsigned(0, s_in'length));

        wait for 100 ns;
        s_in(31 downto 26) <= "000000";
        s_in(5 downto 0) <= "100010";

        wait for 100 ns;

        assert s_RegDst = '1' report "RegDst incorrect." severity failure;
        assert s_Mem_To_Reg = '0' report "o_Mem_To_Reg incorrect." severity failure;
        assert s_ALUOP = "0110" report "ALUOp incorrect." severity failure;
        assert s_MemWrite = '0' report "MemWrite incorrect." severity failure;
        assert s_ALUSrc = '0' report "ALUSrc incorrect." severity failure;
        assert s_RegWrite = '1' report "RegWrite incorrect." severity failure;
        ------------- END TEST ------------

        ------------- TEST ---------------
        report "Beginning SUBU test";
        -- zero out the instruction
        s_in <= std_logic_vector(to_unsigned(0, s_in'length));

        wait for 100 ns;
        s_in(31 downto 26) <= "000000";
        s_in(5 downto 0) <= "100011";

        wait for 100 ns;

        assert s_RegDst = '1' report "RegDst incorrect." severity failure;
        assert s_Mem_To_Reg = '0' report "o_Mem_To_Reg incorrect." severity failure;
        assert s_ALUOP = "0110" report "ALUOp incorrect." severity failure;
        assert s_MemWrite = '0' report "MemWrite incorrect." severity failure;
        assert s_ALUSrc = '0' report "ALUSrc incorrect." severity failure;
        assert s_RegWrite = '1' report "RegWrite incorrect." severity failure;
        ------------- END TEST ------------
    end process;
end structure;
