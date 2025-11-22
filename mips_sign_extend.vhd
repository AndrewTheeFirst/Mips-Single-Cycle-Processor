library ieee;
use ieee.std_logic_1164.all;

entity mips_sign_extend is
    port(
        data_in : in std_logic_vector(15 downto 0);
        data_out : out std_logic_vector(31 downto 0)
    );
end mips_sign_extend;

architecture arch of mips_sign_extend is
begin
    process(data_in) begin
        if (data_in(15) = '0') then
            data_out <= X"0000" & data_in;
        else
            data_out <= X"FFFF" & data_in;
        end if;
    end process;
end arch;