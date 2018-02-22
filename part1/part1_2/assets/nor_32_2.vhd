-- and32.vhd
-------------------------------------------------------------------------
-- DESCRIPTION: This file contains a 32 bit NOR gate (1 input).

-- AUTHOR: Vishal Joel
-------------------------------------------------------------------------

library IEEE;
use IEEE.std_logic_1164.all;

entity nor_32_2 is
    port( i_A : in  STD_LOGIC_VECTOR (31 downto 0);
          o_F : out  std_logic);
end nor_32_2;

architecture behavioral of nor_32_2 is
begin
  process(i_A)
    variable t0: std_logic; -- temp variable
      begin
        if i_A="00000000000000000000000000000000" then
          t0 := '1';
        else
          t0 := '0';
        end if;

        o_F <= t0;
  end process;
end behavioral;
