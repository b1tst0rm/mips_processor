-- control.vhd
-------------------------------------------------------------------------
-- DESCRIPTION: Control logic module using dataflow VHDL
-- Takes in the opcode and funct fields of a MIPS instruction and outputs
-- the proper settings for the modules in the processor (ALU, mux-s, register file, etc)
--
-- AUTHORS: Vishal Joel & Daniel Limanowski
-------------------------------------------------------------------------

library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;

entity control is
    port( i_Instruction    : in std_logic_vector(31 downto 0);
          o_Sel_ALU_A_Mux2 : out std_logic; -- set to 1 if ALUOP = 1001, 1000, or 1010
          o_RegDst         : out std_logic;
          o_Mem_To_Reg     : out std_logic;
          o_ALUOP		   : out std_logic_vector(3 downto 0);
          o_MemWrite       : out std_logic;
          o_ALUSrc         : out std_logic;
          o_RegWrite       : out std_logic;
          o_BEQ            : out std_logic;
          o_BNE            : out std_logic;
          o_J              : out std_logic;
          o_JAL            : out std_logic;
          o_JR             : out std_logic );
end control;

--- Define the architecture ---
architecture dataflow of control is
    signal op, funct : std_logic_vector(5 downto 0);
    signal all_outputs : std_logic_vector(8 downto 0); -- 9 bit ouput "array"

begin
    process (i_Instruction, op, funct)
    begin
        op <= i_Instruction(31 downto 26);
        funct <= i_Instruction(5 downto 0);
        o_Sel_ALU_A_Mux2 <= '0'; -- initialize to 0
        o_BEQ <= '0';
        o_BNE <= '0';
        o_J <= '0';
        o_JAL <= '0';
        o_JR <= '0';

        if op = "000000" then
        -- R-type
            if funct = "101010" then
                all_outputs <= "001110011"; -- slt
            elsif funct = "101011" then
                all_outputs <= "001110011"; -- sltu
            elsif funct = "100000" then
                all_outputs <= "000100011"; -- and
            elsif funct = "100001" then
                all_outputs <= "000100011"; -- addu
            elsif funct = "100100" then
                all_outputs <= "000000011"; -- and
            elsif funct = "100110" then
                all_outputs <= "011010011"; -- xor
            elsif funct = "100101" then
                all_outputs <= "000010011"; -- or
            elsif funct = "100111" then
                all_outputs <= "011000011"; -- nor
            elsif funct = "000000" then
                all_outputs <= "010010011"; -- sll
                o_Sel_ALU_A_Mux2 <= '1'; -- need SHAMT
            elsif funct = "000010" then
                all_outputs <= "010000011"; -- srl
                o_Sel_ALU_A_Mux2 <= '1'; -- need SHAMT
            elsif funct = "000011" then
                all_outputs <= "010100011"; -- sra
                o_Sel_ALU_A_Mux2 <= '1'; -- need SHAMT
            elsif funct = "000100" then
                all_outputs <= "010010011"; -- sllv
            elsif funct = "000110" then
                all_outputs <= "010000011"; -- srlv
            elsif funct = "000111" then
                all_outputs <= "010100011"; -- srav
            elsif funct = "100010" then
                all_outputs <= "001100011"; -- sub
            elsif funct = "100011" then
                all_outputs <= "001100011"; -- subu
            elsif funct = "001000" then
                all_outputs <= "000000000"; -- jr
                o_JR <= '1';
            else
                all_outputs <= "111111111"; -- THIS IS AN ISSUE!
            end if;
        else
        -- I-or-J-type
            if op = "001000" then
                all_outputs <= "000100110"; -- addi
            elsif op = "001001" then
                all_outputs <= "000100110"; -- addiu
            elsif op = "001100" then
                all_outputs <= "000000110"; -- andi
            elsif op = "001111" then
                all_outputs <= "010010110"; -- lui
                o_Sel_ALU_A_Mux2 <= '1'; -- need 16
            elsif op = "100011" then
                all_outputs <= "100100110"; -- lw
            elsif op = "001110" then
                all_outputs <= "011010110"; -- xori
            elsif op = "001101" then
                all_outputs <= "000010110"; -- ori
            elsif op = "001010" then
                all_outputs <= "001110110"; -- slti
            elsif op = "001011" then
                all_outputs <= "001110110"; -- sltiu
            elsif op = "101011" then
                all_outputs <= "100101100"; -- sw
            elsif op = "000100" then
                all_outputs <= "001100000"; -- beq
                o_BEQ <= '1';
            elsif op = "000101" then
                all_outputs <= "001100000"; -- bne
                o_BNE <= '1';
            elsif op = "000010" then
                all_outputs <= "000000000"; -- j
                o_J <= '1';
            elsif op = "000011" then
                all_outputs <= "000000000"; -- jal
                o_JAL <= '1';
            else
                all_outputs <= "111111110"; -- THIS IS AN ISSUE!
            end if;
        end if;

    end process;

    -- Then decomponse all_outputs to each output signal
    o_Mem_To_Reg <= all_outputs(8);
    o_ALUOP <= all_outputs(7 downto 4);
    o_MemWrite <= all_outputs(3);
    o_ALUSrc <= all_outputs(2);
    o_RegWrite <= '1' when (op = "000011") else -- jal (we need to write address at $31)
                         all_outputs(1);
    o_RegDst <= all_outputs(0);

end dataflow;
