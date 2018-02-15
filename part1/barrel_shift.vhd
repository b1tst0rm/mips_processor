-- barrel_shift.vhd
-------------------------------------------------------------------------
-- DESCRIPTION: 32-bit (MIPS word) Barrel shifter implementation
-- using structural VHDL
--
-- need 5 stages of 2-1 muxes, each stage has a select signal
-- stage 1 (first set of muxes) is 1 bit shift
-- stage 2 is 2 bit shift
-- stage 3 is 4 bit shift
-- stage 4 is 8 bit shift
-- stage 5 is 16 bit shift
-------------------------------------------------------------------------

library IEEE;
use IEEE.std_logic_1164.all;

entity barrel_shifter is
    constant select_width : integer := 5;
    port( i_data   : in std_logic_vector(31 downto 0);
          o_data   : out std_logic_vector(31 downto 0);
          i_type   : in std_logic; -- 0 = arithmetic, 1 = logical
          i_dir    : in std_logic; -- 0 = right, 1 = left
          i_shamt  : out std_logic_vector(4 downto 0) ); -- shift amount
end barrel_shifter;

--- Define the architecture ---
architecture structure of barrel_shifter is
    --- Component Declaration ---
    component mux_2_1_struct is
        generic(N : integer := 32);
        port( i_X   : in std_logic_vector(N-1 downto 0);
              i_Y   : in std_logic_vector(N-1 downto 0);
              i_SEL : in std_logic;
              o_OUT : out std_logic_vector(N-1 downto 0) );
    end component;

    signal mux_out_1, mux_out_2, mux_out_3, mux_out_4 std_logic_vector(N-1 downto 0);
    signal s_zero std_logic;

begin
    -- force zero signal to 0
    s_zero <= '0';

    -- use five for loops, one for each cascade level

    -- CASCADE LEVEL 1
    level_gen_1: for i in 0 to 2**select_width - 1 generate
    begin
        if (i < 1) then
            -- modelsim name convention will apply variable i to name below
            -- so tmp_mux_i will become tmp_mux_1, tmp_mux_2, etc.
            tmp_mux_i: mux_2_1_struct generic map (1)
                port map(s_zero, i_data(i), i_shamt(0), mux_out_1(i));
        else
            tmp_mux_i: mux_2_1_struct generic map (1)
                port map(i_data(i), i_data(i + 1), i_shamt(0), mux_out_1(i));
        end if;

    -- CASCADE LEVEL 2
    level_gen_2: for i in 0 to 2**select_width - 1 generate
    begin
        if (i < 2) then
            -- modelsim name convention will apply variable i to name below
            -- so tmp_mux_i will become tmp_mux_1, tmp_mux_2, etc.
            tmp_mux_i: mux_2_1_struct generic map (1)
                port map(s_zero, mux_out_1(i), i_shamt(1), mux_out_2(i));
        else
            tmp_mux_i: mux_2_1_struct generic map (1)
                port map(mux_out_1(i), mux_out_1(i + 1), i_shamt(1), mux_out_2(i));
        end if;


end structure;
