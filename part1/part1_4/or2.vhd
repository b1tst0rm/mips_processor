-------------------------------------------------------------------------
-- Joseph Zambreno
-- Department of Electrical and Computer Engineering
-- Iowa State University
-------------------------------------------------------------------------


-- or2_MS.vhd
-------------------------------------------------------------------------
-- DESCRIPTION: This file contains an implementation of a 2-input OR 
-- gate.
--
--
-- NOTES:
-- 8/19/16 by JAZ::Design created.
-------------------------------------------------------------------------

library IEEE;
use IEEE.std_logic_1164.all;

entity or2_MS is

  port(i_A          : in std_logic;
       i_B          : in std_logic;
       o_F          : out std_logic);

end or2_MS;

architecture dataflow of or2_MS is
begin

  o_F <= i_A or i_B;
  
end dataflow;
