library ieee;
use ieee.std_logic_1164.all;


entity mips_pc is
	port(
		bus_in 	: in std_logic_vector(31 downto 0);
		bus_out : out std_logic_vector(31 downto 0);
		clock 	: in std_logic;
		reset_n : in std_logic);
end mips_pc;


architecture arch of mips_pc is
begin
	process(reset_n, clock) is
	begin
		if (reset_n = '0') then
			bus_out <= X"00400000";
		elsif (rising_edge(clock)) then
			bus_out <= bus_in;
		end if;
	end process;
			
end arch;

