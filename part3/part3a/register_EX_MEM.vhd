-- register_EX_MEM.vhd
-------------------------------------------------------------------------
-- DESCRIPTION: ID/EX Register to store state in between the stages
--
-- AUTHOR: Daniel Limanowski
-------------------------------------------------------------------------

library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;

entity register_EX_MEM is
    port( i_Clock       : in std_logic;
          i_Reset       : in std_logic;
          i_MemToReg    : in std_logic;
          i_ALUOut      : in std_logic_vector(31 downto 0);
          i_WR          : in std_logic_vector(4 downto 0); -- Register to write to after WB
          o_MemToReg    : out std_logic;
          o_ALUOut      : out std_logic_vector(31 downto 0);
          o_WR          : out std_logic_vector(4 downto 0) );
end register_EX_MEM;

architecture structural of register_EX_MEM is

    component register_Nbit is
        generic ( N : integer := 38 );
        port ( i_CLK  : in std_logic;
               i_RST  : in std_logic;
               i_WD   : in std_logic_vector(N-1 downto 0);    -- WD = write data
               i_WE   : in std_logic;                         -- WE = write enable
               o_Q    : out std_logic_vector(N-1 downto 0) ); -- Output requested data
    end component;

    -- 38 bit signals for write and read data
    signal s_WD, s_RD : std_logic_vector(37 downto 0);

begin
    s_WD <= i_MemToReg & i_ALUOut & i_WR; -- concat the signals

    -- We are always writing to these staged registers so WE hardcoded to '1'
    reg: register_Nbit
    port map (i_Clock, i_Reset, s_WD, '1', s_RD);

    o_MemToReg <= s_RD(37);
    o_ALUOut <= s_RD(36 downto 5);
    o_WR <= s_RD(4 downto 0);


end structural;
