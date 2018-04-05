-- addsub_32bit.vhd
-------------------------------------------------------------------------
-- DESCRIPTION: N-bit adder/subtractor w/ control implementation using
-- structural VHDL
-- Perfoms A + B when i_nAdd_Sub = 0
-- ...     A - B when i_nAdd_Sub = 1
-- AUTHOR: Daniel Limanowski
-------------------------------------------------------------------------

library IEEE;
use IEEE.std_logic_1164.all;

entity addsub_32bit is
    port( i_A         : in std_logic_vector(31 downto 0);
          i_B         : in std_logic_vector(31 downto 0);
          i_nAdd_Sub  : in std_logic; -- A + B when = '0', A - B when = '1'
          o_Cout      : out std_logic;
          o_S         : out std_logic_vector(31 downto 0) );
end addsub_32bit;

--- Define the architecture ---
architecture structure of addsub_32bit is
    --- Component Declaration ---
    component ones_comp_32bit is
        generic(N : integer := 32);
        port( i_Bits     : in std_logic_vector(N-1 downto 0);
              o_OnesComp : out std_logic_vector(N-1 downto 0) );
    end component;

    component mux2to1_32bit is
        generic(N : integer := 32);
        port( i_X   : in std_logic_vector(N-1 downto 0);
              i_Y   : in std_logic_vector(N-1 downto 0);
              i_SEL : in std_logic;
              o_OUT   : out std_logic_vector(N-1 downto 0) );
    end component;

    component fulladder_32bit is
        generic(N : integer := 32);
        port( i_A    : in std_logic_vector(N-1 downto 0);
              i_B    : in std_logic_vector(N-1 downto 0);
              i_Cin  : in std_logic;
              o_Cout : out std_logic;
              o_S    : out std_logic_vector(N-1 downto 0) );
    end component;

    --- Signal Declaration ---
    signal s_inv_b, s_mux_out : std_logic_vector(31 downto 0);
    signal s_twoscomp_cout : std_logic;
    signal s_twoscomp : std_logic_vector(31 downto 0);
    signal s_one : std_logic_vector(31 downto 0);


begin
s_one <= (0 => '1', others => '0'); -- a signal forced to 0b1

-- one's complement the b input for subtraction
inv_b: ones_comp_32bit GENERIC MAP (32)
    port map(i_B, s_inv_b);

-- add one to one's complement to make the B signal "two's complemented"
add1_inv_b: fulladder_32bit GENERIC MAP (32)
    port map(s_inv_b, s_one, '0', s_twoscomp_cout, s_twoscomp);

mux_sel: mux2to1_32bit GENERIC MAP (32)
    port map(i_B, s_twoscomp, i_nAdd_Sub, s_mux_out);

adder: fulladder_32bit GENERIC MAP (32)
    port map(i_A, s_mux_out, '0', o_Cout, o_S);

end structure;
