-- tb_instruction_mem.vhd
-------------------------------------------------------------------------
-- DESCRIPTION: This file contains proof that mem.vhd can be used for
-- instruction memory in a MIPS 32 bit processor.
--
-- TESTS THE FOLLOWING FILES:
--   mem.vhd
--
-- AUTHOR: Daniel Limanowski
-------------------------------------------------------------------------

library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;

entity tb_instruc_mem is
    generic(gCLK_HPER   : time := 50 ns);
end tb_instruc_mem;

--- Define the architecture ---
architecture structure of tb_instruc_mem is
    -- Calculate the clock period as twice the half-period
    constant cCLK_PER  : time := gCLK_HPER * 2;


--- Component Declaration ---
    component mem is
        generic ( DATA_WIDTH : natural := 32; ADDR_WIDTH : natural := 10 );
        port ( clk	: in std_logic;
               addr	: in natural range 0 to 2**ADDR_WIDTH - 1;
               data	: in std_logic_vector((DATA_WIDTH-1) downto 0); -- not needed for instruction memory
               we	: in std_logic := '0';                          -- not needed for instruction memory
               q	: out std_logic_vector((DATA_WIDTH-1) downto 0) );
    end component;

    signal s_Clock, s_we : std_logic;
    signal s_before_addr : std_logic_vector(31 downto 0);
    signal s_addr : natural range 0 to 31;
    signal s_q, s_data : std_logic_vector(31 downto 0);

begin
    mem_unit: mem
        port map(s_Clock, s_addr, s_data, s_we, s_q);

    P_CLK: process
    begin
        s_Clock <= '0';
        wait for gCLK_HPER;
        s_Clock <= '1';
        wait for gCLK_HPER;
    end process;

    -- force we and data to 0 because we do NOT need them for instruction memory
    s_we <= '0';
    s_data <= (others => '0');

    -- Testbench process
    P_TB: process
    begin
        wait until s_Clock = '0'; -- set values on clock LOW
        s_before_addr <= (others => '0'); -- address = 0
        s_addr <= to_integer(unsigned(s_before_addr));
        wait for cCLK_PER; -- wait a full clock cycle to start next command
        s_before_addr <= (0 => '1', others => '0'); -- address = 1
        s_addr <= to_integer(unsigned(s_before_addr));
        wait for cCLK_PER;
        s_before_addr <= (1 => '1', others => '0'); -- address = 2
        s_addr <= to_integer(unsigned(s_before_addr));
        wait for cCLK_PER;
    end process;
end structure;
