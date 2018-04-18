-- register_IF_ID.vhd
-------------------------------------------------------------------------
-- DESCRIPTION: IF/ID Register to store state in between the stages
--
-- AUTHOR: Daniel Limanowski
-------------------------------------------------------------------------

library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;

entity register_IF_ID is
    port( i_Reset       : in std_logic;
          i_Clock       : in std_logic;
          i_Stall       : in std_logic; -- stalls register when high
          i_Flush       : in std_logic; -- flushes register when high
          i_Instruction : in std_logic_vector(31 downto 0);
          i_PCPlus4     : in std_logic_vector(31 downto 0);
          o_Instruction : out std_logic_vector(31 downto 0);
          o_PCPlus4     : out std_logic_vector(31 downto 0) );
end register_IF_ID;

architecture structural of register_IF_ID is

    component register_Nbit is
        generic ( N : integer := 64 );
        port ( i_CLK  : in std_logic;
               i_RST  : in std_logic;
               i_WD   : in std_logic_vector(N-1 downto 0);    -- WD = write data
               i_WE   : in std_logic;                         -- WE = write enable
               o_Q    : out std_logic_vector(N-1 downto 0) ); -- Output requested data
    end component;

    -- 64 bit signals for write and read data
    signal s_WD, s_RD : std_logic_vector(63 downto 0);
    signal s_stall_reg : std_logic;

begin

    s_stall_reg <= not i_Stall;

    with i_Flush select s_WD <=
        (others => '0') when '1',     -- clears the register when a flush is received
        (i_Instruction & i_PCPlus4) when '0',            -- updates the register as usual
        (others => '0') when others;  -- all other possibilities (compiler complains otherwise)

    reg: register_Nbit
        port map (i_Clock, i_Reset, s_WD, s_stall_reg, s_RD);

    o_Instruction <= s_RD(63 downto 32);
    o_PCPlus4 <= s_RD(31 downto 0);

end structural;
