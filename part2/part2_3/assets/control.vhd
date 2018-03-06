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
          o_RegDst         : out std_logic;
          o_Mem_To_Reg     : out std_logic;
          o_ALUOP		   : out std_logic_vector(3 downto 0);
          o_MemWrite       : out std_logic;
          o_ALUSrc         : out std_logic;
          o_RegWrite       : out std_logic );
end control;

--- Define the architecture ---
architecture dataflow of control is
    signal all_in : std_logic_vector(11 downto 0);
    signal all_outputs : std_logic_vector(8 downto 0); -- 9 bit ouput "array"

begin
    -- instruction[31-26] == binary opcode
    -- instruction[5-0]   == funct/function code
    all_in <= i_Instruction(31 downto 26) & i_Instruction(5 downto 0);
    with all_in select
        all_outputs <= "000100011" when "000000100000", -- add
                       "000100110" when "001000------", -- addi
                       "000100110" when "001001------", -- addiu
                       "000100011" when "000000100001", -- addu
                       "000000011" when "000000100100", -- and
                       "000000110" when "001100------", -- andi
                       "010010110" when "001111------", -- lui
                       "100000110" when "100011------", -- lw
                       "011000011" when "100111------", -- nor
                       "011010011" when "000000100110", -- xor
                       "011010110" when "001110------", -- xori
                       "000010011" when "000000100101", -- or
                       "000010110" when "001101------", -- ori
                       "001110011" when "000000------", -- slt
                       "001110110" when "001010------", -- slti
                       "001110110" when "001011------", -- sltiu
                       "010010011" when "000000000000", -- sll
                       "010000011" when "000000000010", -- srl
                       "010100011" when "000000000011", -- sra
                       "010010011" when "000000000100", -- sllv
                       "010000011" when "000000000110", -- srlv
                       "010100011" when "000111------", -- srav
                       "-0000110-" when "101011------", -- sw
                       "001100011" when "000000100010", -- sub
                       "001100011" when "000000100011", -- subu
                      (others => '0') when others;

    -- Then decomponse all_outputs to each output signal
    o_Mem_To_Reg <= all_outputs(8);
    o_ALUOP <= all_outputs(7 downto 4);
    o_MemWrite <= all_outputs(3);
    o_ALUSrc <= all_outputs(2);
    o_RegWrite <= all_outputs(1);
    o_RegDst <= all_outputs(0);

end dataflow;
