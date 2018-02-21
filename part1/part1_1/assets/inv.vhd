-- inv.vhd
-------------------------------------------------------------------------
-- DESCRIPTION: This file contains an implementation of a 1-input NOT 
-- gate.
-------------------------------------------------------------------------

library IEEE;
use IEEE.std_logic_1164.all;

entity inv is

  port(i_A          : in std_logic;
       o_F          : out std_logic);

end inv;

architecture dataflow of inv is
begin

  o_F <= not i_A;
  
end dataflow;
