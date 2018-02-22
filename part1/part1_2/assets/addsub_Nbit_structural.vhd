-- addsub_Nbit_structural.vhd
-------------------------------------------------------------------------
-- DESCRIPTION: N-bit adder/subtractor w/ control implementation using
-- structural VHDL

-- Perfoms A + B when i_nAdd_Sub = 0
-- ...     A - B when i_nAdd_Sub = 1

-- AUTHOR: Daniel Limanowski
-------------------------------------------------------------------------

library IEEE;
use IEEE.std_logic_1164.all;

entity addsub_struct_nbit is
    generic(N : integer := 4);
    port( i_A         : in std_logic_vector(N-1 downto 0);
          i_B         : in std_logic_vector(N-1 downto 0);
          i_nAdd_Sub  : in std_logic; -- A+B when = '0', A-B when = '1'
          o_Cout      : out std_logic;
          o_S         : out std_logic_vector(N-1 downto 0) );
end addsub_struct_nbit;

--- Define the architecture ---
architecture structure of addsub_struct_nbit is
    --- Component Declaration ---
    component ones_comp_structural is
        generic(N : integer := 32);
        port( i_A  : in std_logic_vector(N-1 downto 0);
              o_F  : out std_logic_vector(N-1 downto 0) );
    end component;

    component mux_2_1_struct is
        generic(N : integer := 32);
        port( i_X   : in std_logic_vector(N-1 downto 0);
              i_Y   : in std_logic_vector(N-1 downto 0);
              i_SEL : in std_logic;
              o_OUT   : out std_logic_vector(N-1 downto 0) );
    end component;

    component full_adder_struct_nbit is
        generic(N : integer := 32);
        port( i_A    : in std_logic_vector(N-1 downto 0);
              i_B    : in std_logic_vector(N-1 downto 0);
              i_Cin  : in std_logic;
              o_Cout : out std_logic;
              o_S    : out std_logic_vector(N-1 downto 0) );
    end component;

    --- Signal Declaration ---
    signal s_inv_b, s_mux_out : std_logic_vector(N-1 downto 0);

begin
-- try putting these in a process?
inv_a: ones_comp_structural GENERIC MAP (N)
    port map(i_B, s_inv_b);

mux_sel: mux_2_1_struct GENERIC MAP (N)
    port map(i_B, s_inv_b, i_nAdd_Sub, s_mux_out);

adder: full_adder_struct_nbit GENERIC MAP (N)
    port map(i_A, s_mux_out, i_nAdd_Sub, o_Cout, o_S);

end structure;
