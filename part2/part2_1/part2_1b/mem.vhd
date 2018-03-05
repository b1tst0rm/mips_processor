-- Quartus Prime VHDL Template
-- Single-port RAM with single read/write address

-- NOTE: To use the memory module, you must load it into modelsim using the
-- following command during simulation
-- mem load -infile dmem.hex -format hex

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity mem is
	generic
	(
		DATA_WIDTH : natural := 32;
		ADDR_WIDTH : natural := 10
	);

	port ( clk	: in std_logic;
		   addr	: in natural range 0 to 2**ADDR_WIDTH - 1;
		   data	: in std_logic_vector((DATA_WIDTH-1) downto 0);
		   we	: in std_logic := '1';
		   q	: out std_logic_vector((DATA_WIDTH-1) downto 0) );
end mem;

architecture rtl of mem is

	-- Build a 2-D array type for the RAM
	subtype word_t is std_logic_vector((DATA_WIDTH-1) downto 0);
	type memory_t is array(2**ADDR_WIDTH-1 downto 0) of word_t;

	-- Declare the RAM signal and specify a default value.	Quartus Prime
	-- will load the provided memory initialization file (.mif).
	signal ram : memory_t;

begin

	process(clk)
	begin
	if(rising_edge(clk)) then
		if(we = '1') then
			ram(addr) <= data;
		end if;

	end if;
	end process;

	q <= ram(addr);

end rtl;
