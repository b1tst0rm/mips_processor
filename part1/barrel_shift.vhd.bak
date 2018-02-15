-- barrel_shift.vhd
-------------------------------------------------------------------------
-- DESCRIPTION: 32-bit (MIPS word) Barrel shifter implementation
-- using structural VHDL
--
-------------------------------------------------------------------------

library IEEE;
use IEEE.std_logic_1164.all;

entity barrel_shifter is
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

begin

end structure;
