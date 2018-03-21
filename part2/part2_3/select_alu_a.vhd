-- select_alu_a.vhd
-------------------------------------------------------------------------
-- DESCRIPTION: Using structural VHDL, this module selects the proper
-- value to be fed into the ALU's "a" argument. It chooses between
-- RD1 (from register file), a static value of 0d16 (for LUI), and
-- SHAMT (from Instruction(10 downto 6)) depending on the current values of
-- ALUOP, ALUSRC, and the function code (Instruction 5 downto 0)
--
-- AUTHOR: Daniel Limanowski
-------------------------------------------------------------------------

library IEEE;
use IEEE.std_logic_1164.all;

entity sel_alu_a is
    port( i_ALUSrc   : in std_logic;                        -- signal from control unit
          i_RD1      : in std_logic_vector(31 downto 0);    -- signal from register file
          i_ALUOP    : in std_logic_vector(3 downto 0);     -- signal from control unit
          i_shamt    : in std_logic_vector(31 downto 0);    -- 32 bit shift amount
          i_mux2_sel : in std_logic;                        -- selector for the second 2-1 mux that gets set in control unit
          o_data     : out std_logic_vector(31 downto 0) ); -- selected data
end sel_alu_a;

--- Define the architecture ---
architecture structure of sel_alu_a is
    --- Component Declaration ---
    component mux_2_1_struct is
        generic(N : integer := 32);
        port( i_X   : in std_logic_vector(N-1 downto 0);
              i_Y   : in std_logic_vector(N-1 downto 0);
              i_SEL : in std_logic;
              o_OUT   : out std_logic_vector(N-1 downto 0) );
    end component;

    signal s_const_16, s_mux1_out : std_logic_vector(31 downto 0);
    signal s_and2_out, s_and1_out, s_not_out, s_or_out : std_logic;

begin
    s_const_16 <= (4 => '1', others => '0'); -- set to 0d16

    mux1: mux_2_1_struct
        port map(i_shamt, s_const_16, i_ALUSrc, s_mux1_out);

    mux2: mux_2_1_struct
        port map(i_RD1, s_mux1_out, i_mux2_sel, o_data);

end structure;
