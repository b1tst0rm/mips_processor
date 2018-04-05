-- sel_BEQ_BNE.vhd
-------------------------------------------------------------------------
-- DESCRIPTION: Using dataflow VHDL selects the proper signal to go to
-- the AND gate in fetch_logic.vhd
--
-- AUTHOR: Daniel Limanowski
-------------------------------------------------------------------------

library IEEE;
use IEEE.std_logic_1164.all;

entity sel_BEQ_BNE is
    port( i_Zero_Flag : in std_logic;
          i_Select    : in std_logic_vector(1 downto 0);
          o_F         : out std_logic );
end sel_BEQ_BNE;

architecture dataflow of sel_BEQ_BNE is
    
begin
    with i_Select select
        o_F <= i_Zero_Flag when "10",
               (not i_Zero_Flag) when "01",
               i_Zero_Flag when others;

end dataflow;
