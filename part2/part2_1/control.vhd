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
    port( i_Opcode         : in std_logic_vector(5 downto 0);   -- Instruction[31-26]
          i_Funct          : in std_logic_vector(5 downto 0); -- Instruction[5-0]
    --      o_RegDst         : out std_logic;   TODO: decide to implement when we find that we need this
          o_Mem_To_Reg     : out std_logic;                    -- 2-1 mux mem_or_reg
          o_ALUOP		   : out std_logic_vector(3 downto 0); -- alu32
          o_MemWrite       : out std_logic;                    -- mem
          o_ALUSrc         : out std_logic;                    -- 2-1 mux imm_or_reg
          o_RegWrite       : out std_logic );                   -- register file
end control;

--- Define the architecture ---
architecture dataflow of control is
begin
    process (i_Opcode, i_Funct)
    begin
        if i_Opcode = "000000" then
            -- R-type instruction
            if i_Funct = "000000" then
                -- SLL
                o_Mem_To_reg <= '1';
                o_ALUOP <= "1001";
                o_MemWrite <= '0';
                o_ALUSrc <= '0';
                o_RegWrite <= '1';
            end if;
        else
            -- I (or J)-type instruction

        end if;
    end process;
end dataflow;
