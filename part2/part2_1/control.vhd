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
    port( i_Opcode         : in std_logic_vector(5 downto 0);  -- Instruction[31-26]
          i_Funct          : in std_logic_vector(5 downto 0);  -- Instruction[5-0]
          o_RegDst         : out std_logic;                    -- TODO: What is this for?
          o_Mem_To_Reg     : out std_logic;                    -- 2-1 mux mem_or_reg
          o_ALUOP		   : out std_logic_vector(3 downto 0); -- alu32
          o_MemWrite       : out std_logic;                    -- mem
          o_ALUSrc         : out std_logic;                    -- 2-1 mux imm_or_reg
          o_RegWrite       : out std_logic );                  -- register file
end control;

--- Define the architecture ---
architecture dataflow of control is
    signal all_in : std_logic_vector(11 downto 0);
    signal all_outputs : std_logic_vector(8 downto 0); -- 9 bit ouput "array"
    -- all_outputs[0]  = o_Mem_To_Reg
    -- all_outputs[1-4] = o_ALUOP
    -- all_ouputs[5] = o_MemWrite
    -- all_ouputs[6]   = o_ALUSrc
    -- all_outputs[7]  = o_RegWrite
    -- all_outputs[8]  = o_RegDst

begin
    all_in <= i_Opcode & i_Funct;
    with all_in select
        all_outputs <= "000100011" when "000000100000", -- add
                      "000100110" when "001000------", -- addi
                      "000100110" when "001001------", -- addiu
                      "000100011" when "000000100001", -- addu
                      "000000011" when "000000100100", -- and
                      -- TODO: FINISH
                      (others => '0') when others;

    -- Then decomponse all_outputs to each output signal
    o_Mem_To_Reg <= all_outputs(8);
    o_ALUOP <= all_outputs(7 downto 4);
    o_MemWrite <= all_outputs(3);
    o_ALUSrc <= all_outputs(2);
    o_RegWrite <= all_outputs(1);
    o_RegDst <= all_outputs(0);

    -- TODO: FINISH

end dataflow;
