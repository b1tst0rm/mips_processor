-- rd1_rd2_zero_detect.vhd
-------------------------------------------------------------------------
-- DESCRIPTION: Compares RD1 and RD2 values to see if they are equal.
-- If they are equal, the zero flag is set.
--
-- AUTHOR: Daniel Limanowski
-------------------------------------------------------------------------

library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;

entity rd1_rd2_zero_detect is
    port( i_RD1       : in std_logic_vector(31 downto 0);
          i_RD2       : in std_Logic_vector(31 downto 0);
          o_Zero_Flag : out std_logic );
end rd1_rd2_zero_detect;

architecture structural of rd1_rd2_zero_detect is
    component addsub_32bit is
        port( i_A         : in std_logic_vector(31 downto 0);
              i_B         : in std_logic_vector(31 downto 0);
              i_nAdd_Sub  : in std_logic; -- A + B when = '0', A - B when = '1'
              o_Cout      : out std_logic;
              o_S         : out std_logic_vector(31 downto 0) );
    end component;

    component zero_detect is
        port( i_F    : in  std_logic_vector(31 downto 0); -- result selected from mux
              o_Zero : out std_logic ); -- The zero flag result
    end component;

    signal s_cout, s_zero : std_logic;
    signal s_sum  : std_logic_vector(31 downto 0);

begin

    sub_register: addsub_32bit
        port map(i_RD1, i_RD2, '1', s_cout, s_sum); -- perform RD1 - RD2

    detect: zero_detect
        port map(s_sum, s_zero);

    o_Zero_Flag <= s_zero;

end structural;
