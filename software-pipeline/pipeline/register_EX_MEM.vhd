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
    port( i_Reset       : in std_logic;
          i_Clock       : in std_logic;
          i_PCPlus4     : in std_logic_vector(31 downto 0);
          i_JAL         : in std_logic;
          i_ALUOut      : in std_logic_vector(31 downto 0);
          i_RD2         : in std_logic_vector(31 downto 0);
          i_WR          : in std_logic_vector(4 downto 0);
          i_Mem_To_Reg  : in std_logic;
          i_MemWrite    : in std_logic;
          i_RegWriteEn  : in std_logic;
          o_PCPlus4     : out std_logic_vector(31 downto 0);
          o_JAL         : out std_logic;
          o_ALUOut      : out std_logic_vector(31 downto 0);
          o_RD2         : out std_logic_vector(31 downto 0);
          o_WR          : out std_logic_vector(4 downto 0);
          o_Mem_To_Reg  : out std_logic;
          o_MemWrite    : out std_logic;
          o_RegWriteEn  : out std_logic );
end register_EX_MEM;

architecture structural of register_EX_MEM is

    component register_Nbit is
        generic ( N : integer := 105 );
        port ( i_CLK  : in std_logic;
               i_RST  : in std_logic;
               i_WD   : in std_logic_vector(N-1 downto 0);    -- WD = write data
               i_WE   : in std_logic;                         -- WE = write enable
               o_Q    : out std_logic_vector(N-1 downto 0) ); -- Output requested data
    end component;

    -- 72 bit signals for write and read data
    signal s_WD, s_RD : std_logic_vector(104 downto 0);

begin
    s_WD <= i_PCPlus4 & i_JAL & i_ALUOut & i_RD2 & i_WR & i_Mem_To_Reg & i_MemWrite & i_RegWriteEn; -- concat the signals

    -- We are always writing to these staged registers so WE hardcoded to '1'
    reg: register_Nbit
    port map (i_Clock, i_Reset, s_WD, '1', s_RD);

    o_PCPlus4 <= s_RD(104 downto 73);
    o_JAL <= s_RD(72);
    o_ALUOut <= s_RD(71 downto 40);
    o_RD2 <= s_RD(39 downto 8);
    o_WR <= s_RD(7 downto 3);
    o_Mem_To_Reg <= s_RD(2);
    o_MemWrite <= s_RD(1);
    o_RegWriteEn <= s_RD(0);

end structural;
