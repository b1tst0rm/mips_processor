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
    port( i_Reset       : in std_logic;
          i_Clock       : in std_logic;
          i_Flush       : in std_logic;
          i_Stall       : in std_logic;
          i_PCPlus4     : in std_logic_vector(31 downto 0);
          i_JAL         : in std_logic;
          i_ALUOut      : in std_logic_vector(31 downto 0);
          i_WR          : in std_logic_vector(4 downto 0);
          i_Mem_To_Reg  : in std_logic;
          i_RegWriteEn  : in std_logic;
          i_MemOut      : in std_logic_vector(31 downto 0);
          o_PCPlus4     : out std_logic_vector(31 downto 0);
          o_JAL         : out std_logic;
          o_ALUOut      : out std_logic_vector(31 downto 0);
          o_WR          : out std_logic_vector(4 downto 0);
          o_Mem_To_Reg  : out std_logic;
          o_RegWriteEn  : out std_logic;
          o_MemOut      : out std_logic_vector(31 downto 0) );
end register_MEM_WB;

architecture structural of register_MEM_WB is
    component register_Nbit is
        generic ( N : integer := 104 );
        port ( i_CLK  : in std_logic;
               i_RST  : in std_logic;
               i_WD   : in std_logic_vector(N-1 downto 0);
               i_WE   : in std_logic;
               o_Q    : out std_logic_vector(N-1 downto 0) );
    end component;

    -- 71 bit signals for write and read data
    signal s_WD, s_RD : std_logic_vector(103 downto 0);
    signal s_stall_reg : std_logic;

begin

    s_stall_reg <= not i_Stall;

    with i_Flush select s_WD <=
        (others => '0') when '1',     -- clears the register when a flush is received
        (i_PCPlus4 & i_JAL & i_ALUOut & i_WR & i_Mem_To_Reg & i_RegWriteEn & i_MemOut) when '0',            -- updates the register as usual
        (others => '0') when others;  -- all other possibilities (compiler complains otherwise)

    reg: register_Nbit
        port map (i_Clock, i_Reset, s_WD, s_stall_reg, s_RD);

    o_PCPlus4 <= s_RD(103 downto 72);
    o_JAL <= s_RD(71);
    o_ALUOut <= s_RD(70 downto 39);
    o_WR <= s_RD(38 downto 34);
    o_Mem_To_Reg <= s_RD(33);
    o_RegWriteEn <= s_RD(32);
    o_MemOut <= s_RD(31 downto 0);

end structural;
