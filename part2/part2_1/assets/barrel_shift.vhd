-- barrel_shift.vhd
-------------------------------------------------------------------------
-- DESCRIPTION: 32-bit (MIPS word) Barrel Shifter implementation
-- using structural VHDL
--
-- need 5 stages of 2-1 muxes, each stage has a select signal
-- stage 1 (first set of muxes) is 1 bit shift
-- stage 2 is 2 bit shift
-- stage 3 is 4 bit shift
-- stage 4 is 8 bit shift
-- stage 5 is 16 bit shift
--
-- AUTHOR: Daniel Limanowski
-------------------------------------------------------------------------

-- FROM WIKIPEDIA: "In a logical shift, zeros are shifted in to replace the
-- discarded bits. Therefore, the logical and arithmetic left-shifts are exactly the same."
-- An arithmetic right shift simply shifts the bits by shamt and shifts in from the left
-- 1's so as to preserve the sign bit

library IEEE;
use IEEE.std_logic_1164.all;

entity barrel_shifter is
    port( i_data   : in std_logic_vector(31 downto 0);
          i_type   : in std_logic; -- 0 = logical, 1 = arithmetic
          i_dir    : in std_logic; -- 0 = right, 1 = left
          i_shamt  : in std_logic_vector(4 downto 0); -- shift amount
          o_data   : out std_logic_vector(31 downto 0) );
end barrel_shifter;

--- Define the architecture ---
architecture structure of barrel_shifter is
    --- Component Declaration ---
    component mux_2_1_struct_single is
        port( i_X   : in std_logic;
              i_Y   : in std_logic;
              i_SEL : in std_logic;
              o_OUT : out std_logic );
    end component;

    component mux_2_1_struct is
        generic(N : integer := 32);
        port( i_X   : in std_logic_vector(N-1 downto 0);
              i_Y   : in std_logic_vector(N-1 downto 0);
              i_SEL : in std_logic;
              o_OUT   : out std_logic_vector(N-1 downto 0) );
    end component;


    component reverse_order is
        port( i_data   : in std_logic_vector(31 downto 0);
              o_data   : out std_logic_vector(31 downto 0) );
    end component;

    signal s_out, s_fin_reverse, s_reversed, s_data, mux_out_1, mux_out_2, mux_out_3, mux_out_4 : std_logic_vector(31 downto 0);
    signal s_shift_bit : std_logic;

begin
    REVERSE: reverse_order
        port map (i_data, s_reversed);

    -- flip bits if necessary (for left shifts)
    ORGANIZE_BITS_BEFORE: mux_2_1_struct
        port map (i_data, s_reversed, i_dir, s_data);

    -- we must define the type of bit to shift in dependent on the shift type
    with i_type select s_shift_bit <=
        i_data(31) when '1', -- for an arithmetic shift, shift in the MSB
        '0' when '0',        -- logical shift always shifts in 0
        '0' when others;     -- all other possibilities (compiler complains otherwise)

    -- set up the multiplexers using five for loops, one for each cascade level

    -- CASCADE LEVEL 1
    LEVEL_GEN_1: for i in 0 to 31 generate
    begin
        GEN_SHIFT_IN: if (i > 30) generate
            tmp_mux_i: mux_2_1_struct_single
                -- if i_shamt(0) = '1', this would be a one bit shift
                port map(s_data(i), s_shift_bit, i_shamt(0), mux_out_1(i));
        end generate GEN_SHIFT_IN;

        GEN_MAIN: if (i <= 30) generate
            tmp_mux_i: mux_2_1_struct_single
                port map(s_data(i), s_data(i + 1), i_shamt(0), mux_out_1(i));
        end generate GEN_MAIN;
    end generate;

    -- CASCADE LEVEL 2
    LEVEL_GEN_2: for i in 0 to 31 generate
    begin
        GEN_SHIFT_IN: if (i > 29) generate
            tmp_mux_i: mux_2_1_struct_single
                port map(mux_out_1(i), s_shift_bit, i_shamt(1), mux_out_2(i));
        end generate GEN_SHIFT_IN;

        GEN_MAIN: if (i <= 29) generate
            tmp_mux_i: mux_2_1_struct_single
                port map(mux_out_1(i), mux_out_1(i + 2), i_shamt(1), mux_out_2(i));
        end generate GEN_MAIN;
    end generate;

    -- CASCADE LEVEL 3
    LEVEL_GEN_3: for i in 0 to 31 generate
    begin
        GEN_SHIFT_IN: if (i > 27) generate
            tmp_mux_i: mux_2_1_struct_single
                port map(mux_out_2(i), s_shift_bit, i_shamt(2), mux_out_3(i));
        end generate GEN_SHIFT_IN;

        GEN_MAIN: if (i <= 27) generate
            tmp_mux_i: mux_2_1_struct_single
                port map(mux_out_2(i), mux_out_2(i + 4), i_shamt(2), mux_out_3(i));
        end generate GEN_MAIN;
    end generate;

    -- CASCADE LEVEL 4
    LEVEL_GEN_4: for i in 0 to 31 generate
    begin
        GEN_SHIFT_IN: if (i > 23) generate
            tmp_mux_i: mux_2_1_struct_single
                port map(mux_out_3(i), s_shift_bit, i_shamt(3), mux_out_4(i));
        end generate GEN_SHIFT_IN;

        GEN_MAIN: if (i <= 23) generate
            tmp_mux_i: mux_2_1_struct_single
                port map(mux_out_3(i), mux_out_3(i + 8), i_shamt(3), mux_out_4(i));
        end generate GEN_MAIN;
    end generate;

    -- CASCADE LEVEL 5
    LEVEL_GEN_5: for i in 0 to 31 generate
    begin
        GEN_SHIFT_IN: if (i > 15) generate
            tmp_mux_i: mux_2_1_struct_single
                port map(mux_out_4(i), s_shift_bit, i_shamt(4), s_out(i));
        end generate GEN_SHIFT_IN;

        GEN_MAIN: if (i <= 15) generate
            tmp_mux_i: mux_2_1_struct_single
                port map(mux_out_4(i), mux_out_4(i + 16), i_shamt(4), s_out(i));
        end generate GEN_MAIN;
    end generate;

    -- if necessary, reverse order one more time (in case of left shift)
    REVERSE_FIN: reverse_order
        port map (s_out, s_fin_reverse);

    ORGANIZE_BITS_AFTER: mux_2_1_struct
        port map (s_out, s_fin_reverse, i_dir, o_data);

end structure;
