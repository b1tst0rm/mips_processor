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
    port( i_Reset       : in std_logic;
          i_Clock       : in std_logic;
          i_PCPlus4     : in std_logic_vector(31 downto 0);
          i_JAL         : in std_logic;
          i_SHAMT       : in std_logic_vector(31 downto 0);
          i_RD1         : in std_logic_vector(31 downto 0);
          i_RD2         : in std_logic_vector(31 downto 0);
          i_IMM         : in std_logic_vector(31 downto 0);
          i_WR          : in std_logic_vector(4 downto 0);
          i_RegWriteEn  : in std_logic;
          i_ALUOP       : in std_logic_vector(3 downto 0);
          i_Sel_Mux2    : in std_logic; -- for sel_a for feeding into the alu
          i_Mem_To_Reg  : in std_logic;
          i_MemWrite    : in std_logic;
          i_ALUSrc      : in std_logic;
          o_PCPlus4     : out std_logic_vector(31 downto 0);
          o_JAL         : out std_logic;
          o_SHAMT       : out std_logic_vector(31 downto 0);
          o_RD1         : out std_logic_vector(31 downto 0);
          o_RD2         : out std_logic_vector(31 downto 0);
          o_IMM         : out std_logic_vector(31 downto 0);
          o_WR          : out std_logic_vector(4 downto 0);
          o_RegWriteEn  : out std_logic;
          o_ALUOP       : out std_logic_vector(3 downto 0);
          o_Sel_Mux2    : out std_logic;
          o_Mem_To_Reg  : out std_logic;
          o_MemWrite    : out std_logic;
          o_ALUSrc      : out std_logic );
end register_ID_EX;

architecture structural of register_ID_EX is

    component register_Nbit is
        generic ( N : integer := 175 );
        port ( i_CLK  : in std_logic;
               i_RST  : in std_logic;
               i_WD   : in std_logic_vector(N-1 downto 0);    -- WD = write data
               i_WE   : in std_logic;                         -- WE = write enable
               o_Q    : out std_logic_vector(N-1 downto 0) ); -- Output requested data
    end component;

    -- 109 bit signals for write and read data
    signal s_WD, s_RD : std_logic_vector(174 downto 0);

begin

    s_WD <= i_PCPlus4 & i_JAL & i_SHAMT & i_RD1 & i_RD2 & i_IMM & i_WR & i_RegWriteEn & i_ALUOP & i_Sel_Mux2 & i_Mem_To_Reg &
            i_MemWrite & i_ALUSrc; -- concat the signals

    -- We are always writing to these staged registers so WE hardcoded to '1'
    reg: register_Nbit
    port map (i_Clock, i_Reset, s_WD, '1', s_RD);

    o_PCPlus4 <= s_RD(174 downto 143);
    o_JAL <= s_RD(142);
    o_SHAMT <= s_RD(141 downto 110);
    o_RD1 <= s_RD(109 downto 78);
    o_RD2 <= s_RD(77 downto 46);
    o_IMM <= s_RD(45 downto 14);
    o_WR  <= s_RD(13 downto 9);
    o_RegWriteEn <= s_RD(8);
    o_ALUOP      <= s_RD(7 downto 4);
    o_Sel_Mux2   <= s_RD(3);
    o_Mem_To_Reg <= s_RD(2);
    o_MemWrite   <= s_RD(1);
    o_ALUSrc     <= s_RD(0);

end structural;
