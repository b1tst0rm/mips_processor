-- register_file.vhd
-------------------------------------------------------------------------
-- DESCRIPTION: 32, 32-bit register file implementation using
-- structural VHDL
--
-- AUTHOR: Daniel Limanowski
-------------------------------------------------------------------------

library IEEE;
use IEEE.std_logic_1164.all;

entity register_file is
    port( i_CLK       : in std_logic;                         -- Clock
          i_RST       : in std_logic;                         -- Reset
          i_WR        : in std_logic_vector(4 downto 0);      -- Write Register
          i_WD        : in std_logic_vector(31 downto 0);     -- Write Data
          i_REGWRITE  : in std_logic;                         -- Write Enable
          i_RR1       : in std_logic_vector(4 downto 0);      -- Read Register 1
          i_RR2       : in std_logic_vector(4 downto 0);      -- Read Register 2
          o_RD1       : out std_logic_vector(31 downto 0);    -- Read Data 1
          o_RD2       : out std_logic_vector(31 downto 0) );  -- Read Data 2
end register_file;

architecture structure of register_file is
    --- Component Declaration ---
    component register_32bit_rf
        port( i_CLK  : in std_logic;
              i_RST  : in std_logic;
              i_WD   : in std_logic_vector(31 downto 0);    -- WD = write data
              i_WE   : in std_logic;                         -- WE = write enable
              o_Q    : out std_logic_vector(31 downto 0) ); -- Output requested data
    end component;

    component decode_5to32bit
        port( i_D : in std_logic_vector(4 downto 0);
              o_F : out std_logic_vector(31 downto 0) );
    end component;

    component mux32to1_32bit is
        port( i_SEL : in std_logic_vector(4 downto 0); -- 5 bit selector
              i_0   : in std_logic_vector(31 downto 0); -- first of 32 inputs to mux
              i_1   : in std_logic_vector(31 downto 0);
              i_2   : in std_logic_vector(31 downto 0);
              i_3   : in std_logic_vector(31 downto 0);
              i_4   : in std_logic_vector(31 downto 0);
              i_5   : in std_logic_vector(31 downto 0);
              i_6   : in std_logic_vector(31 downto 0);
              i_7   : in std_logic_vector(31 downto 0);
              i_8   : in std_logic_vector(31 downto 0);
              i_9   : in std_logic_vector(31 downto 0);
              i_10  : in std_logic_vector(31 downto 0);
              i_11  : in std_logic_vector(31 downto 0);
              i_12  : in std_logic_vector(31 downto 0);
              i_13  : in std_logic_vector(31 downto 0);
              i_14  : in std_logic_vector(31 downto 0);
              i_15  : in std_logic_vector(31 downto 0);
              i_16  : in std_logic_vector(31 downto 0);
              i_17  : in std_logic_vector(31 downto 0);
              i_18  : in std_logic_vector(31 downto 0);
              i_19  : in std_logic_vector(31 downto 0);
              i_20  : in std_logic_vector(31 downto 0);
              i_21  : in std_logic_vector(31 downto 0);
              i_22  : in std_logic_vector(31 downto 0);
              i_23  : in std_logic_vector(31 downto 0);
              i_24  : in std_logic_vector(31 downto 0);
              i_25  : in std_logic_vector(31 downto 0);
              i_26  : in std_logic_vector(31 downto 0);
              i_27  : in std_logic_vector(31 downto 0);
              i_28  : in std_logic_vector(31 downto 0);
              i_29  : in std_logic_vector(31 downto 0);
              i_30  : in std_logic_vector(31 downto 0);
              i_31  : in std_logic_vector(31 downto 0);
              o_F   : out std_logic_vector(31 downto 0) );  -- the selected output
    end component;

    component and2_1bit is
      port(i_A          : in std_logic;
           i_B          : in std_logic;
           o_F          : out std_logic);
    end component;

signal s_decoded : std_logic_vector(31 downto 0);
signal s_write : std_logic_vector(31 downto 0);

type vector32 is array (natural range<>) of std_logic_vector(31 downto 0); -- SEE: http://www.ics.uci.edu/~jmoorkan/vhdlref/arrays.html
signal s_register_data: vector32(31 downto 0);

begin

decode_WR: decode_5to32bit
    port map(i_WR, s_decoded);

generate_registers: for i in 1 to 31 generate -- skip $0 as it will be wired to 0 later
    do_write: and2_1bit
        port map(s_decoded(i), i_REGWRITE, s_write(i)); -- only enable writing if the input WE is enabled

    reg: register_32bit_rf
        port map(i_CLK, i_RST, i_WD, s_write(i), s_register_data(i));
end generate;

reg_0: register_32bit_rf  -- Set $0
    port map(i_CLK, '1', (others => '0'), '0', s_register_data(0)); -- RST = 1 means this will always hold 0

-- Now for the two 32:1 mux mappings for RD1, RD2:
mux_RD1: mux32to1_32bit
    port map ( i_SEL => i_RR1, -- 5 bit selector
          i_0   => s_register_data(0), -- $0 = zero or '0' at all times
          i_1   => s_register_data(1),
          i_2   => s_register_data(2),
          i_3   => s_register_data(3),
          i_4   => s_register_data(4),
          i_5   => s_register_data(5),
          i_6   => s_register_data(6),
          i_7   => s_register_data(7),
          i_8   => s_register_data(8),
          i_9   => s_register_data(9),
          i_10  => s_register_data(10),
          i_11  => s_register_data(11),
          i_12  => s_register_data(12),
          i_13  => s_register_data(13),
          i_14  => s_register_data(14),
          i_15  => s_register_data(15),
          i_16  => s_register_data(16),
          i_17  => s_register_data(17),
          i_18  => s_register_data(18),
          i_19  => s_register_data(19),
          i_20  => s_register_data(20),
          i_21  => s_register_data(21),
          i_22  => s_register_data(22),
          i_23  => s_register_data(23),
          i_24  => s_register_data(24),
          i_25  => s_register_data(25),
          i_26  => s_register_data(26),
          i_27  => s_register_data(27),
          i_28  => s_register_data(28),
          i_29  => s_register_data(29),
          i_30  => s_register_data(30),
          i_31  => s_register_data(31),
          o_F   => o_RD1 );  -- the selected output

mux_RD2: mux32to1_32bit
    port map ( i_SEL => i_RR2, -- 5 bit selector
          i_0   => s_register_data(0), -- $0 = zero or '0' at all times
          i_1   => s_register_data(1),
          i_2   => s_register_data(2),
          i_3   => s_register_data(3),
          i_4   => s_register_data(4),
          i_5   => s_register_data(5),
          i_6   => s_register_data(6),
          i_7   => s_register_data(7),
          i_8   => s_register_data(8),
          i_9   => s_register_data(9),
          i_10  => s_register_data(10),
          i_11  => s_register_data(11),
          i_12  => s_register_data(12),
          i_13  => s_register_data(13),
          i_14  => s_register_data(14),
          i_15  => s_register_data(15),
          i_16  => s_register_data(16),
          i_17  => s_register_data(17),
          i_18  => s_register_data(18),
          i_19  => s_register_data(19),
          i_20  => s_register_data(20),
          i_21  => s_register_data(21),
          i_22  => s_register_data(22),
          i_23  => s_register_data(23),
          i_24  => s_register_data(24),
          i_25  => s_register_data(25),
          i_26  => s_register_data(26),
          i_27  => s_register_data(27),
          i_28  => s_register_data(28),
          i_29  => s_register_data(29),
          i_30  => s_register_data(30),
          i_31  => s_register_data(31),
          o_F   => o_RD2 );  -- the selected output

end structure;
