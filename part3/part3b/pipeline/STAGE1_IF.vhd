-- STAGE1_IF.vhd
-------------------------------------------------------------------------
-- DESCRIPTION: Instruction fetch logic module for the pipeline processor.
-- This file represents all of the logic inside the first of five stages
-- in a pipelined MIPS processor.
--
-- NOTE: Reset needs to be pulsed to zero out the PC before starting during
-- a simulation.
--
-- AUTHOR: Daniel Limanowski
-------------------------------------------------------------------------

library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;

entity instruction_fetch is
    port( i_Reset         : in std_logic;
          i_Clock         : in std_logic;
          i_Stall_PC      : in std_logic;
          i_BranchJ_Addr  : in std_logic_vector(31 downto 0);
          i_Mux_Sel       : in std_logic;
          o_Instruction   : out std_logic_vector(31 downto 0);
          o_PCPlus4       : out std_logic_vector(31 downto 0) );
end instruction_fetch;

architecture structural of instruction_fetch is
    component register_32bit_hazards is
        port( i_CLK  : in std_logic;
              i_RST  : in std_logic;
              i_WD   : in std_logic_vector(31 downto 0);
              i_WE   : in std_logic;
              o_Q    : out std_logic_vector(31 downto 0) );
    end component;

    component mem is
    	generic ( DATA_WIDTH : natural := 32; ADDR_WIDTH : natural := 10 );
    	port ( clk	: in std_logic;
    		   addr	: in natural range 0 to 2**ADDR_WIDTH - 1;
    		   data	: in std_logic_vector((DATA_WIDTH-1) downto 0);
    		   we	: in std_logic := '1';
    		   q	: out std_logic_vector((DATA_WIDTH-1) downto 0) );
    end component;

    component fulladder_32bit is
        port( i_A    : in std_logic_vector(31 downto 0);
              i_B    : in std_logic_vector(31 downto 0);
              i_Cin  : in std_logic;
              o_Cout : out std_logic;
              o_S    : out std_logic_vector(31 downto 0) );
    end component;

    component mux2to1_32bit is
        port( i_X   : in std_logic_vector(31 downto 0);
              i_Y   : in std_logic_vector(31 downto 0);
              i_SEL : in std_logic;
              o_OUT   : out std_logic_vector(31 downto 0) );
    end component;

    signal s_Cout_PC4, s_stall_reg : std_logic; -- Placeholder that we never read
    signal s_convert_addr : std_logic_vector(29 downto 0); -- truncating the PC address to work with our mem module that is WORD addressed
    signal s_PC_Out, s_AddPC4_Out, s_Four, s_MemData_Placehold, s_Mux_Out : std_logic_vector(31 downto 0);
    signal s_convert_to_nat : natural range 0 to 2**10 - 1;

begin
    s_Four <= (2 => '1', others => '0'); -- hardcode "4" as argument to adder
    s_MemData_Placehold <= (others => '0'); -- we won't be writing this to mem but we do need to provide a signal
    s_convert_addr <= "00000000000000000000" & s_PC_Out(11 downto 2); -- chop off the 2 LSBs to conform to word addressing of mem module
    s_convert_to_nat <= to_integer(unsigned(s_Convert_Addr)); -- mem module needs a natural value
    s_stall_reg <= not i_Stall_PC;
    o_PCPlus4 <= s_AddPC4_Out;

    add_PC4: fulladder_32bit
        port map (s_PC_Out, s_Four, '0', s_Cout_PC4, s_AddPC4_Out);

    mux: mux2to1_32bit
        port map (s_AddPC4_Out, i_BranchJ_Addr, i_Mux_Sel, s_Mux_Out);

    pc: register_32bit_hazards
        port map (i_Clock, i_Reset, s_Mux_Out, s_stall_reg, s_PC_Out);

    instruc_mem: mem
        port map (i_Clock, s_convert_to_nat, s_MemData_Placehold, '0', o_Instruction);

end structural;
