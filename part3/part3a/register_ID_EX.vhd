-- register_ID_EX.vhd
-------------------------------------------------------------------------
-- DESCRIPTION: ID/EX Register to store state in between the stages
--
-- AUTHOR: Daniel Limanowski
-------------------------------------------------------------------------

library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;

entity register_ID_EX is
    port( i_Clock       : in std_logic;
          i_Reset       : in std_logic;
          i_ALUOP       : in std_logic_vector(3 downto 0);
          i_ALUSrc      : in std_logic;
          i_RD1         : in std_logic_vector(31 downto 0);
          i_RD2         : in std_logic_vector(31 downto 0);
          i_PCPlus4     : in std_logic_vector(31 downto 0);
          i_IMM         : in std_logic_vector(31 downto 0);
          i_WR          : in std_logic_vector(4 downto 0);
          o_ALUOP       : out std_logic_vector(3 downto 0);
          o_ALUSrc      : out std_logic;
          o_RD1         : out std_logic_vector(31 downto 0);
          o_RD2         : out std_logic_vector(31 downto 0);
          o_PCPlus4     : out std_logic_vector(31 downto 0);
          o_IMM         : out std_logic_vector(31 downto 0);
          o_WR          : out std_logic_vector(4 downto 0) );
end register_ID_EX;

architecture structural of register_ID_EX is

    component register_Nbit is
        generic ( N : integer := 138 );
        port ( i_CLK  : in std_logic;
               i_RST  : in std_logic;
               i_WD   : in std_logic_vector(N-1 downto 0);    -- WD = write data
               i_WE   : in std_logic;                         -- WE = write enable
               o_Q    : out std_logic_vector(N-1 downto 0) ); -- Output requested data
    end component;

    -- 64 bit signals for write and read data
    signal s_WD, s_RD : std_logic_vector(137 downto 0);

begin
    s_WD <= i_ALUOp & i_ALUSrc & i_RD1 & i_RD2 & i_PCPlus4 & i_IMM & i_WR; -- concat the signals

    -- We are always writing to these staged registers so WE hardcoded to '1'
    reg: register_Nbit
    port map (i_Clock, i_Reset, s_WD, '1', s_RD);

    o_ALUOp <= s_RD(137 downto 134);
    o_ALUSrc <= s_RD(133);
    o_RD1 <= s_RD(132 downto 101);
    o_RD2 <= s_RD(100 downto 69);
    o_PCPlus4 <= s_RD(68 downto 37);
    o_IMM <= s_RD(36 downto 5);
    o_WR <= s_RD(4 downto 0);

end structural;
