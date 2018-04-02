-- IF_ID_Reg.vhd
-------------------------------------------------------------------------
-- DESCRIPTION: IF/ID Register used to implement hazard detection.
-- AUTHORS: Vishal Joel
-------------------------------------------------------------------------

library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;

entity IF_ID_Reg is
    port( i_Clock       : in std_logic;
          i_Reset       : in std_logic;
          i_WriteEn     : in std_logic;
          i_Instruction : in std_logic_vector(31 downto 0);
          i_PC_adder    : in std_logic_vector(31 downto 0);
          o_Instruction : out std_logic_vector(31 downto 0);
          o_PC_adder    : out std_logic_vector(31 downto 0) );
end IF_ID_Reg;

architecture structural of IF_ID_Reg is

  component register_nbit is
      generic ( N : integer := 32 );
      port( i_CLK  : in std_logic;
            i_RST  : in std_logic;
            i_WD   : in std_logic_vector(N-1 downto 0);    -- WD = write data
            i_WE   : in std_logic;                         -- WE = write enable
            o_Q    : out std_logic_vector(N-1 downto 0) ); -- Output requested data
  end component;

  begin
    pc: register_nbit
        port map (i_Clock, i_Reset, i_PC_adder, i_WriteEn, o_PC_adder);

    instruction_mem: register_nbit
        port map (i_Clock, i_Reset, i_Instruction, i_WriteEn, o_Instruction);

end structural;
