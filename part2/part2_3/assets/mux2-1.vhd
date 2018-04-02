-- mux2-1.vhd
-------------------------------------------------------------------------
-- DESCRIPTION: Single-bit 2 to 1 (2:1) multiplexer (mux) implementation
-- using structural VHDL

-- AUTHOR: Daniel Limanowski
-------------------------------------------------------------------------

library IEEE;
use IEEE.std_logic_1164.all;

entity mux_2_1_struct_single is
    port( i_X   : in std_logic;
          i_Y   : in std_logic;
          i_SEL : in std_logic;
          o_OUT   : out std_logic );
end mux_2_1_struct_single;

--- Define the architecture ---
architecture structure of mux_2_1_struct_single is
    --- Component Declaration ---
    component inv_MS
        port( i_A  : in std_logic;
              o_F  : out std_logic );
    end component;

    component or2_MS
        port( i_A          : in std_logic;
              i_B          : in std_logic;
              o_F          : out std_logic );
    end component;

    component and2_MS
        port( i_A          : in std_logic;
              i_B          : in std_logic;
              o_F          : out std_logic );
    end component;

    signal s_notsel, s_andy, s_andx : std_logic;

begin
    not_sel: inv_MS
        port map (i_SEL, s_notsel);

    and_sel_y: and2_MS
        port map ( i_A => i_SEL,
                   i_B => i_Y,
                   o_F => s_andy );

    and_notsel_x: and2_MS
        port map ( i_A => s_notsel,
                   i_B => i_X,
                   o_F => s_andx );

    or_xysel: or2_MS
        port map ( i_A => s_andy,
                   i_B => s_andx,
                   o_F => o_OUT );
end structure;
