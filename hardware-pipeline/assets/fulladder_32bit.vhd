-- fulladder_32bit.vhd
-------------------------------------------------------------------------
-- DESCRIPTION: N-bit full adder implementation using structural VHDL
--
-- AUTHOR: Daniel Limanowski
-------------------------------------------------------------------------

library IEEE;
use IEEE.std_logic_1164.all;

entity fulladder_32bit is
    port( i_A    : in std_logic_vector(31 downto 0);
          i_B    : in std_logic_vector(31 downto 0);
          i_Cin  : in std_logic;
          o_Cout : out std_logic;
          o_S    : out std_logic_vector(31 downto 0) );
end fulladder_32bit;

architecture structure of fulladder_32bit is
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

    component xor2_1bit is
        port(i_A          : in std_logic;
             i_B          : in std_logic;
             o_F          : out std_logic);
    end component;

    --- Signal Declaration ---
    signal s_XOR_ab, s_AND_ab, s_AND_nextand : std_logic_vector(31 downto 0);
    signal s_Carry : std_logic_vector(32 downto 0); -- carry bit flows through the adders

begin
s_Carry(0) <= i_Cin;
o_Cout <= s_Carry(32);

GENFOR: for i in 0 to 31 generate
    ab_xor: xor2_1bit
        port map ( i_A => i_A(i),
                   i_B => i_B(i),
                   o_F => s_XOR_ab(i) );

    ab_and: and2_1bit
        port map ( i_A => i_A(i),
                   i_B => i_B(i),
                   o_F => s_AND_ab(i) );

    nextand: and2_1bit
        port map ( i_A => s_XOR_ab(i),
                   i_B => s_Carry(i),
                   o_F => s_AND_nextand(i) );

    or_fin: or2_1bit
        port map ( i_A => s_AND_nextand(i),
                   i_B => s_AND_ab(i),
                   o_F => s_Carry(i+1) );
    xor_fin: xor2_1bit
        port map ( i_A => s_XOR_ab(i),
                   i_B => s_Carry(i),
                   o_F => o_S(i) );
end generate;

end structure;
