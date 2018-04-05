-- mux2to1_1bit.vhd
-------------------------------------------------------------------------
-- DESCRIPTION: 1 bit 2:1 multiplexor implementation using structural VHDL
--
-- AUTHOR: Daniel Limanowski
-------------------------------------------------------------------------

library IEEE;
use IEEE.std_logic_1164.all;

entity mux2to1_1bit is
    port( i_X   : in std_logic;
          i_Y   : in std_logic;
          i_SEL : in std_logic;
          o_OUT   : out std_logic );
end mux2to1_1bit;

--- Define the architecture ---
architecture structure of mux2to1_1bit is
    --- Component Declaration ---
    component not_1bit
        port( i_A  : in std_logic;
              o_F  : out std_logic );
    end component;

    component or2_1bit
        port( i_A          : in std_logic;
              i_B          : in std_logic;
              o_F          : out std_logic );
    end component;

    component and2_1bit
        port( i_A          : in std_logic;
              i_B          : in std_logic;
              o_F          : out std_logic );
    end component;

    signal s_notsel, s_andy, s_andx : std_logic;

begin
    not_sel: not_1bit
        port map (i_SEL, s_notsel);

    and_sel_y: and2_1bit
        port map ( i_A => i_SEL,
                   i_B => i_Y,
                   o_F => s_andy );

    and_notsel_x: and2_1bit
        port map ( i_A => s_notsel,
                   i_B => i_X,
                   o_F => s_andx );

    or_xysel: or2_1bit
        port map ( i_A => s_andy,
                   i_B => s_andx,
                   o_F => o_OUT );
end structure;
