-- register_32bit.vhd
-------------------------------------------------------------------------
-- DESCRIPTION: 32-bit register implementation using structural VHDL
--
-- AUTHOR: Daniel Limanowski
-------------------------------------------------------------------------

library IEEE;
use IEEE.std_logic_1164.all;

entity register_32bit is
    port( i_CLK  : in std_logic;
          i_RST  : in std_logic;
          i_WD   : in std_logic_vector(31 downto 0);    -- WD = write data
          i_WE   : in std_logic;                        -- WE = write enable
          o_Q    : out std_logic_vector(31 downto 0) ); -- Output requested data
end register_32bit;

--- Define the architecture ---
architecture structure of register_32bit is
    --- Component Declaration ---
    component dff_1bit
        port( i_CLK        : in std_logic;     -- Clock input
              i_RST        : in std_logic;     -- Reset input
              i_WE         : in std_logic;     -- Write enable input
              i_D          : in std_logic;     -- Data value input
              o_Q          : out std_logic );  -- Data value output
    end component;

begin

GENFOR: for i in 0 to 31 generate
    flip_flop: dff_1bit
        port map (i_CLK, i_RST, i_WE, i_WD(i), o_Q(i));

end generate;

end structure;
