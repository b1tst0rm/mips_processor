-- ones_complement_structural.vhd
-------------------------------------------------------------------------
-- DESCRIPTION: This file contains an implementation of a one's
-- complementer using structural modeling (ie., modular design)

-- AUTHOR: Daniel Limanowski
-------------------------------------------------------------------------

library IEEE;
use IEEE.std_logic_1164.all;

entity ones_comp_structural is
    generic(N : integer := 32);
    port( i_Bits     : in std_logic_vector(N-1 downto 0);
          o_OnesComp : out std_logic_vector(N-1 downto 0) );
end ones_comp_structural;

--- Define the architecture ---
architecture structure of ones_comp_structural is
    --- Component Declaration ---
    -- NOT (inv.vhd)
    component inv_MS is
      port(i_A          : in std_logic;
           o_F          : out std_logic);
    end component;

begin

-- generic for loop goes through each individual signal
-- and inverts it...this is implemented as a reusable module
-- and is therefore considered structural code
GENFOR: for i in 0 to N-1 generate
    inv_i: inv_MS
        port map(i_Bits(i), o_OnesComp(i));
end generate;

end structure;
