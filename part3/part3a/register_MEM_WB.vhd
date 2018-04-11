-- register_MEM_WB.vhd
-------------------------------------------------------------------------
-- DESCRIPTION: MEM/WB Register to store state in between the stages
--
-- AUTHOR: Daniel Limanowski
-------------------------------------------------------------------------

library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;

entity register_MEM_WB is
    port( i_Clock       : in std_logic;
          i_Reset       : in std_logic;
          i_MemToReg    : in std_logic;
          i_MemRD       : in std_logic_vector(31 downto 0);
          i_ALUOut      : in std_logic_vector(31 downto 0);
          i_WR          : in std_logic_vector(4 downto 0);
          o_MemToReg    : out std_logic;
          o_MemRD       : out std_logic_vector(31 downto 0);
          o_ALUOut      : out std_logic_vector(31 downto 0);
          o_WR          : out std_logic_vector(4 downto 0) );
end register_MEM_WB;

architecture structural of register_MEM_WB is
    component register_Nbit is
        generic ( N : integer := 70 );
        port ( i_CLK  : in std_logic;
               i_RST  : in std_logic;
               i_WD   : in std_logic_vector(N-1 downto 0);
               i_WE   : in std_logic;
               o_Q    : out std_logic_vector(N-1 downto 0) );
    end component;

    -- 70 bit signals for write and read data
    signal s_WD, s_RD : std_logic_vector(69 downto 0);

begin
    s_WD <= i_MemToReg & i_MemRD & i_ALUOut & i_WR; -- concat the signals

    -- We are always writing to these staged registers so WE hardcoded to '1'
    reg: register_Nbit
    port map (i_Clock, i_Reset, s_WD, '1', s_RD);

    o_MemToReg <= s_RD(69);
    o_MemRD <= s_RD(68 downto 37);
    o_ALUOut <= s_RD(36 downto 5);
    o_WR <= s_RD(4 downto 0);

end structural;
