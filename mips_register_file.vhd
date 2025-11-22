library ieee;
use ieee.std_logic_arith.all;
use ieee.std_logic_unsigned.all;
use ieee.std_logic_1164.all;

entity mips_register_file is
    port(
        clock, reset, RegWrite  : in    std_logic;
        read_reg1, read_reg2    : in    std_logic_vector(4 downto 0);
        write_reg               : in    std_logic_vector(4 downto 0);
        write_data              : in    std_logic_vector(31 downto 0);
        read_data1, read_data2  : out   std_logic_vector(31 downto 0)
    );
end mips_register_file;

architecture arch of mips_register_file is
    type reg_type is array (0 to 31) of std_logic_vector(31 downto 0);
    signal registers : reg_type;
begin
    -- converts 5-bit bin to a decimal index -> read_data will a value in one of our 32 registers
    read_data1 <= registers(conv_integer(read_reg1));
    read_data2 <= registers(conv_integer(read_reg2));
    process(reset, clock) is begin
        if (reset = '0') then
            for register_index in 0 to 31 loop
                registers(register_index) <= X"00000000";
            end loop;
        elsif (rising_edge(clock)) then
            if (RegWrite = '1') then
                registers(conv_integer(write_reg)) <= write_data;
            end if;
        end if;
    end process;
end arch;