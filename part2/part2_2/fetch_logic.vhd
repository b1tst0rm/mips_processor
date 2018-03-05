-- fetch_logic.vhd
-------------------------------------------------------------------------
-- DESCRIPTION: Instruction fetch logic module using structural VHDL
-- NOTE: Reset needs to be pulsed to zero out the PC before starting during
--       a simulation.
-- AUTHORS: Vishal Joel & Daniel Limanowski
-------------------------------------------------------------------------

library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;

entity fetch_logic is
    port( i_Clock       : in std_logic;
          i_Reset       : in std_logic;
          o_Instruction : out std_logic_vector(31 downto 0) );
end fetch_logic;

--- Define the architecture ---
architecture structural of fetch_logic is
    --- Component Declaration ---
    component register_nbit is
        generic ( N : integer := 32 );
        port( i_CLK  : in std_logic;
              i_RST  : in std_logic;
              i_WD   : in std_logic_vector(N-1 downto 0);    -- WD = write data
              i_WE   : in std_logic;                         -- WE = write enable
              o_Q    : out std_logic_vector(N-1 downto 0) ); -- Output requested data
    end component;

    component mem is
    	generic ( DATA_WIDTH : natural := 32; ADDR_WIDTH : natural := 10 );
    	port ( clk	: in std_logic;
    		   addr	: in natural range 0 to 2**ADDR_WIDTH - 1;
    		   data	: in std_logic_vector((DATA_WIDTH-1) downto 0);
    		   we	: in std_logic := '1';
    		   q	: out std_logic_vector((DATA_WIDTH-1) downto 0) );
    end component;

    component full_adder_struct_nbit is
        generic(N : integer := 32);
        port( i_A    : in std_logic_vector(N-1 downto 0);
              i_B    : in std_logic_vector(N-1 downto 0);
              i_Cin  : in std_logic;
              o_Cout : out std_logic;
              o_S    : out std_logic_vector(N-1 downto 0) );
    end component;

    signal s_Reg_WE, s_Mem_WE, s_Cin, s_Cout : std_logic;
    signal s_Convert_Addr : std_logic_vector(29 downto 0); -- truncating the PC address to work with our mem module that is WORD addressed
    signal s_PC_Out, s_Add_Out, s_Four, s_MemData_Placehold : std_logic_vector(31 downto 0);
    signal s_convert_to_nat : natural range 0 to 2**10 - 1;

begin
    s_Four <= (2 => '1', others => '0'); -- hardcode "4" as argument to adder
    s_Cin <= '0'; -- hardcode a "0" carry in for adder
    s_Reg_WE <= '1'; -- we will always write to the register every clock cycle (as we increment pc)
    s_Mem_WE <= '0'; -- we will NEVER write to instruction memory
    s_MemData_Placehold <= (others => '0'); -- we won't be writing this to mem but we do need to provide a Signal
    s_Convert_Addr <= s_PC_Out(31 downto 2); -- chop off the 2 LSBs to conform to word addressing of mem module
    s_convert_to_nat <= to_integer(unsigned(s_Convert_Addr)); -- mem module needs a natural value

    increment: full_adder_struct_nbit
        port map (s_PC_Out, s_Four, s_Cin, s_Cout, s_Add_Out);

    pc: register_nbit
        port map (i_Clock, i_Reset, s_Add_Out, s_Reg_WE, s_PC_Out);

    instruc_mem: mem
        port map (i_Clock, s_convert_to_nat, s_MemData_Placehold, s_Mem_WE, o_Instruction);

end structural;
