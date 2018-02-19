-- TODO: implement...

-- tb_barrel_shift.vhd
-------------------------------------------------------------------------
-- DESCRIPTION: This file contains a simple VHDL testbench for the
-- 32 bit barrel shifter in barrel_shift.vhd

-- AUTHOR: Daniel Limanowski
-------------------------------------------------------------------------

library IEEE;
use IEEE.std_logic_1164.all;

entity tb_barrel_shift is
    generic(gCLK_HPER   : time := 50 ns);
end tb_barrel_shift;

architecture behavior of tb_barrel_shift is
    -- Calculate the clock period as twice the half-period
    constant cCLK_PER  : time := gCLK_HPER * 2;

    component barrel_shifter is
        port( i_data   : in std_logic_vector(31 downto 0);
              o_data   : out std_logic_vector(31 downto 0);
              i_type   : in std_logic; -- 0 = logical, 1 = arithmetic
              i_dir    : in std_logic; -- 0 = left, 1 = right
              i_shamt  : in std_logic_vector(4 downto 0) ); -- shift amount
    end component;

    -- Temporary signals to connect to the datapath component
    signal s_Clock, s_type, s_dir : std_logic;
    signal s_shamt : std_logic_vector(4 downto 0);
    signal s_data_in, s_data_out : std_logic_vector(31 downto 0);

begin
    DUT: barrel_shifter
        port map(TODO);

    -- This process sets the clock value (low for gCLK_HPER, then high
    -- for gCLK_HPER). Absent a "wait" command, processes restart
    -- at the beginning once they have reached the final statement.
    P_CLK: process
    begin
        s_Clock <= '0';
        wait for gCLK_HPER;
        s_Clock <= '1';
        wait for gCLK_HPER;
    end process;

    -- Testbench process
    P_TB: process
    begin
        wait until s_Clock = '0'; -- perform the command (test) on CLOCK LOW

        -- set values here

        wait for cCLK_PER; -- wait a full clock cycle to start next command

    end process;
end behavior;
