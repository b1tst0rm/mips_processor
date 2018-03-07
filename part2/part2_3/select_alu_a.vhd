-- select_alu_a.vhd
-------------------------------------------------------------------------
-- DESCRIPTION: Using structural VHDL, this module selects the proper
-- value to be fed into the ALU's "a" argument. It chooses between
-- RD1 (from register file), a static value of 0d16 (for LUI), and
-- SHAMT (from Instruction(10 downto 6)) depending on the current values of
-- ALUOP and ALUSRC
--
-- AUTHOR: Daniel Limanowski
-------------------------------------------------------------------------

library IEEE;
use IEEE.std_logic_1164.all;

entity sel_alu_a is
    port( i_data   : in std_logic_vector(31 downto 0);
          i_type   : in std_logic; -- 0 = logical, 1 = arithmetic
          i_dir    : in std_logic; -- 0 = right, 1 = left
          i_shamt  : in std_logic_vector(4 downto 0); -- shift amount
          o_data   : out std_logic_vector(31 downto 0) );
end sel_alu_a;

--- Define the architecture ---
architecture structure of sel_alu_a is
    --- Component Declaration ---
    component and2_MS is
      port(i_A          : in std_logic;
           i_B          : in std_logic;
           o_F          : out std_logic);
    end component;


begin
-- TODO: complete structura... need and or inv (aka not) and 2-1mux 32 bit.
-- Reference photo on phone

end structure;
