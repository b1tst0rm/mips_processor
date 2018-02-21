-- mux2-1_Nbit_structural.vhd
-------------------------------------------------------------------------
-- DESCRIPTION: N-bit 2 to 1 (2:1) multiplexer (mux) implementation
-- using structural VHDL

-- AUTHOR: Daniel Limanowski
-------------------------------------------------------------------------

library IEEE;
use IEEE.std_logic_1164.all;

entity mux_2_1_struct is
    generic(N : integer := 32);
    port( i_X   : in std_logic_vector(N-1 downto 0);
          i_Y   : in std_logic_vector(N-1 downto 0);
          i_SEL : in std_logic;
          o_OUT   : out std_logic_vector(N-1 downto 0) );
end mux_2_1_struct;

--- Define the architecture ---
architecture structure of mux_2_1_struct is
    --- Component Declaration ---
    component inv
        port( i_A  : in std_logic;
              o_F  : out std_logic );
    end component;

    component or2
        port( i_A          : in std_logic;
              i_B          : in std_logic;
              o_F          : out std_logic );
    end component;

    component and2
        port( i_A          : in std_logic;
              i_B          : in std_logic;
              o_F          : out std_logic );
    end component;

    signal s_notsel        : std_logic; 
    signal s_andy, s_andx  : std_logic_vector(N-1 downto 0);

begin
not_sel: inv -- this part doesn't need to be in GENFOR b/c it is not affected by i (constant)
    port map ( i_A => i_SEL,
               o_F => s_notsel );

GENFOR: for i in 0 to N-1 generate    
    and_sel_y: and2
        port map ( i_A => i_SEL,
                   i_B => i_Y(i), 
                   o_F => s_andy(i) );

    and_notsel_x: and2
        port map ( i_A => s_notsel, 
                   i_B => i_X(i), 
                   o_F => s_andx(i) );

    or_xysel: or2
        port map ( i_A => s_andy(i),
                   i_B => s_andx(i),
                   o_F => o_OUT(i) );
end generate;
end structure;
