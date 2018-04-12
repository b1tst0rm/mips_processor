-- STAGE4_MEM.vhd
-------------------------------------------------------------------------
-- DESCRIPTION: Memory logic module for the pipeline processor.
-- This file represents all of the logic inside the fourth of five stages
-- in a pipelined MIPS processor.
--
-- AUTHOR: Daniel Limanowski
-------------------------------------------------------------------------

library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;

entity memory is
    port( i_Reset       : in std_logic;
          i_Clock       : in std_logic;
          i_PCPlus4     : in std_Logic_vector(31 downto 0);
          i_JAL         : in std_logic;
          i_ALUOut      : in std_logic_vector(31 downto 0);
          i_RD2         : in std_logic_vector(31 downto 0);
          i_WR          : in std_logic_vector(4 downto 0);
          i_Mem_To_Reg  : in std_logic;
          i_MemWrite    : in std_logic;
          i_RegWriteEn  : in std_logic;
          o_PCPlus4     : out std_logic_vector(31 downto 0);
          o_JAL         : out std_logic;
          o_ALUOut      : out std_logic_vector(31 downto 0);
          o_WR          : out std_logic_vector(4 downto 0);
          o_Mem_To_Reg  : out std_logic;
          o_RegWriteEn  : out std_logic;
          o_MemOut      : out std_logic_vector(31 downto 0) );
end memory;

architecture structural of memory is
    -- Note: this memory, used for 1) data and 2) instructions, is WORD
    -- addressed. As we submit a signal to the address, we need to first
    -- cut off the 2 Least Significant Bits (LSBs) and then convert the address
    -- to a "natural" number. All other parts of the processor are using BYTE
    -- addressing and modules expect this. Only at the addr ports of mem modules
    -- do we need to convert to word addressing.
    component mem is
    	generic ( DATA_WIDTH : natural := 32; ADDR_WIDTH : natural := 10 );
    	port ( clk	: in std_logic;
    		   addr	: in natural range 0 to 2**ADDR_WIDTH - 1;
    		   data	: in std_logic_vector((DATA_WIDTH-1) downto 0);
    		   we	: in std_logic := '1';
    		   q	: out std_logic_vector((DATA_WIDTH-1) downto 0) );
    end component;

    signal s_dmem_out : std_logic_vector(31 downto 0);
    signal s_dmem_addr : natural range 0 to 2**10 - 1;

begin
    -- Output signal assignments
    o_PCPlus4 <= i_PCPlus4;
    o_JAL <= i_JAL;
    o_ALUOut <= i_ALUOut;
    o_WR <= i_WR;
    o_Mem_To_Reg <= i_Mem_To_Reg;
    o_RegWriteEn <= i_RegWriteEn;
    o_MemOut <= s_dmem_out;

    -- Asychronous assignment of the memory address signal.
    -- Must chop off 2 LSBs and convert to a natural address to hand to mem module.
    s_dmem_addr <= to_integer(unsigned(i_ALUOut(11 downto 2)));

    data_mem: mem
        port map(i_Clock, s_dmem_addr, i_RD2, i_MemWrite, s_dmem_out);

end structural;
