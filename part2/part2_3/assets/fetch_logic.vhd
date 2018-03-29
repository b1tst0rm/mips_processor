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
    port( i_Clock        : in std_logic;
          i_Reset        : in std_logic;
          i_IMM          : in std_logic_vector(31 downto 0);
          i_Instruc_Curr : in std_logic_vector(25 downto 0);
          i_BEQ          : in std_logic;
          i_BNE          : in std_logic;
          i_J            : in std_logic;
          i_JAL          : in std_logic;
          i_JR           : in std_logic;
          i_RD1          : in std_logic_vector(31 downto 0);
          i_Zero_Flag    : in std_logic;
          o_Instruction  : out std_logic_vector(31 downto 0);
          o_PC           : out std_logic_vector(31 downto 0) );
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

    component mux_2_1_struct is
        generic(N : integer := 32);
        port( i_X   : in std_logic_vector(N-1 downto 0);
              i_Y   : in std_logic_vector(N-1 downto 0);
              i_SEL : in std_logic;
              o_OUT   : out std_logic_vector(N-1 downto 0) );
    end component;

    component or2_MS is
      port(i_A          : in std_logic;
           i_B          : in std_logic;
           o_F          : out std_logic);
    end component;

    component and2_MS is
      port(i_A          : in std_logic;
           i_B          : in std_logic;
           o_F          : out std_logic);
    end component;

    component inv is -- aka NOT
      port(i_A          : in std_logic;
           o_F          : out std_logic);
    end component;

    component sel_BEQ_BNE is
        port( i_Zero_Flag : in std_logic;
              i_Select    : in std_logic_vector(1 downto 0);
              o_F         : out std_logic );
    end component;

    signal s_Cout_PC4, s_Cout_IMM, s_AND_Out, s_OR_J, s_OR_BEQBNE, s_sel_br_out : std_logic;
    signal s_Convert_Addr : std_logic_vector(29 downto 0); -- truncating the PC address to work with our mem module that is WORD addressed
    signal s_PC_Out, s_AddPC4_Out, s_AddIMM_Out, s_Four, s_MemData_Placehold, s_Mux1_Out, s_Mux2_Out, s_Mux3_Out : std_logic_vector(31 downto 0);
    signal s_convert_to_nat : natural range 0 to 2**10 - 1;
    signal s_IMM_Shift, s_concat_pc_instruc : std_logic_vector(31 downto 0);
    signal s_instruc_sl2 : std_logic_vector(27 downto 0);
    signal s_BEQBNE : std_logic_vector(1 downto 0);

begin
    s_Four <= (2 => '1', others => '0'); -- hardcode "4" as argument to adder
    s_MemData_Placehold <= (others => '0'); -- we won't be writing this to mem but we do need to provide a Signal
    s_Convert_Addr <= "00000000000000000000" & s_PC_Out(11 downto 2); -- chop off the 2 LSBs to conform to word addressing of mem module
    s_convert_to_nat <= to_integer(unsigned(s_Convert_Addr)); -- mem module needs a natural value
    s_IMM_Shift <= i_IMM(29 downto 0) & "00"; -- shift i_IMM left by 2 bits
    s_BEQBNE <= i_BEQ & i_BNE; -- selector for sel_BEQ_BNE

    s_instruc_sl2 <= i_Instruc_Curr & "00"; -- shift left 2 bits
    s_concat_pc_instruc <= s_AddPC4_Out(31 downto 28) & s_instruc_sl2; -- 32 bit signal

    o_PC <= s_PC_Out; -- to provide an out signal for testing/simulation

    add_PC4: full_adder_struct_nbit
        port map (s_PC_Out, s_Four, '0', s_Cout_PC4, s_AddPC4_Out);

    add_IMM: full_adder_struct_nbit
        port map (s_AddPC4_Out, s_IMM_Shift, '0', s_Cout_IMM, s_AddIMM_Out);

    mux1: mux_2_1_struct
        port map (s_AddPC4_Out, s_AddIMM_Out, s_AND_Out, s_Mux1_Out);

    mux2: mux_2_1_struct
        port map (s_Mux1_Out, s_concat_pc_instruc, s_OR_J, s_Mux2_Out);

    mux3: mux_2_1_struct
        port map (s_Mux2_Out, i_RD1, i_JR, s_Mux3_Out);

    or_BEQ_BNE: or2_MS
        port map (i_BEQ, i_BNE, s_OR_BEQBNE);

    and_Z: and2_MS
        port map (s_OR_BEQBNE, s_sel_br_out, s_AND_Out);

    selBEQBNE: sel_BEQ_BNE
        port map (i_Zero_Flag, s_BEQBNE, s_sel_br_out);

    or_J: or2_MS
        port map (i_J, i_JAL, s_OR_J);

    pc: register_nbit
        port map (i_Clock, i_Reset, s_Mux3_Out, '1', s_PC_Out);

    instruc_mem: mem
        port map (i_Clock, s_convert_to_nat, s_MemData_Placehold, '0', o_Instruction);

end structural;
