library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_arith.all;
use ieee.std_logic_signed.all;

entity mips_alu is
    port(
        ALUControl      : in std_logic_vector( 3 downto 0);
        inputA, inputB  : in std_logic_vector(31 downto 0);
        shamt           : in std_logic_vector( 4 downto 0);
        Zero            : out std_logic;
        ALU_Result      : out std_logic_vector(31 downto 0)
    );
end mips_alu;

architecture arch of mips_alu is 
    signal result : std_logic_vector(31 downto 0);
begin
    ALU_Result <= result;
    process(inputA, inputB, ALUControl, shamt)
    begin
        case (ALUControl) is
            when "0000" => -- and
                result <= inputA and inputB;
            when "0001" => -- or
                result <= inputA or inputB;
            when "0010" => -- add
                result <= inputA + inputB;
            when "0110" => -- subtract
                result <= inputA - inputB;
            when "0111" => -- set on less than
                if (inputA < inputB) then
                    result <= X"00000001";
                else
                    result <= X"00000000";
                end if;
            when "1000" => -- shift left logical
                case (shamt) is
                    when "00000" =>
                        result <= inputA;
                    when "00001" =>
                        result <= inputA(30 downto 0) & "0";
                    when "00010" =>
                        result <= inputA(29 downto 0) & "00";
                    when "00011" =>
                        result <= inputA(28 downto 0) & "000";
                    when "00100" =>
                        result <= inputA(27 downto 0) & "0000";
                    when "00101" =>
                        result <= inputA(26 downto 0) & "00000";
                    when "00110" =>
                        result <= inputA(25 downto 0) & "000000";
                    when "00111" =>
                        result <= inputA(24 downto 0) & "0000000";
                    when "01000" =>
                        result <= inputA(23 downto 0) & "00000000";
                    when "01001" =>
                        result <= inputA(22 downto 0) & "000000000";
                    when "01010" =>
                        result <= inputA(21 downto 0) & "0000000000";
                    when "01011" =>
                        result <= inputA(20 downto 0) & "00000000000";
                    when "01100" =>
                        result <= inputA(19 downto 0) & "000000000000";
                    when "01101" =>
                        result <= inputA(18 downto 0) & "0000000000000";
                    when "01110" =>
                        result <= inputA(17 downto 0) & "00000000000000";
                    when "01111" =>
                        result <= inputA(16 downto 0) & "000000000000000";
                    when "10000" =>
                        result <= inputA(15 downto 0) & "0000000000000000";
                    when "10001" =>
                        result <= inputA(14 downto 0) & "00000000000000000";
                    when "10010" =>
                        result <= inputA(13 downto 0) & "000000000000000000";
                    when "10011" =>
                        result <= inputA(12 downto 0) & "0000000000000000000";
                    when "10100" =>
                        result <= inputA(11 downto 0) & "00000000000000000000";
                    when "10101" =>
                        result <= inputA(10 downto 0) & "000000000000000000000";
                    when "10110" =>
                        result <= inputA(9 downto 0) & "0000000000000000000000";
                    when "10111" =>
                        result <= inputA(8 downto 0) & "00000000000000000000000";
                    when "11000" =>
                        result <= inputA(7 downto 0) & "000000000000000000000000";
                    when "11001" =>
                        result <= inputA(6 downto 0) & "0000000000000000000000000";
                    when "11010" =>
                        result <= inputA(5 downto 0) & "00000000000000000000000000";
                    when "11011" =>
                        result <= inputA(4 downto 0) & "000000000000000000000000000";
                    when "11100" =>
                        result <= inputA(3 downto 0) & "0000000000000000000000000000";
                    when "11101" =>
                        result <= inputA(2 downto 0) & "00000000000000000000000000000";
                    when "11110" =>
                        result <= inputA(1 downto 0) & "000000000000000000000000000000";
                    when "11111" =>
                        result <= inputA(0 downto 0) & "0000000000000000000000000000000";
                    when others =>
                        result <= X"00000000";
                end case;
            when "1001" => -- shift right logical
                case (shamt) is
                    when "00000" =>
                        result <= inputA;
                    when "00001" =>
                        result <= "0" & inputA(31 downto 1);
                    when "00010" =>
                        result <= "00" & inputA(31 downto 2);
                    when "00011" =>
                        result <= "000" & inputA(31 downto 3);
                    when "00100" =>
                        result <= "0000" & inputA(31 downto 4);
                    when "00101" =>
                        result <= "00000" & inputA(31 downto 5);
                    when "00110" =>
                        result <= "000000" & inputA(31 downto 6);
                    when "00111" =>
                        result <= "0000000" & inputA(31 downto 7);
                    when "01000" =>
                        result <= "00000000" & inputA(31 downto 8);
                    when "01001" =>
                        result <= "000000000" & inputA(31 downto 9);
                    when "01010" =>
                        result <= "0000000000" & inputA(31 downto 10);
                    when "01011" =>
                        result <= "00000000000" & inputA(31 downto 11);
                    when "01100" =>
                        result <= "000000000000" & inputA(31 downto 12);
                    when "01101" =>
                        result <= "0000000000000" & inputA(31 downto 13);
                    when "01110" =>
                        result <= "00000000000000" & inputA(31 downto 14);
                    when "01111" =>
                        result <= "000000000000000" & inputA(31 downto 15);
                    when "10000" =>
                        result <= "0000000000000000" & inputA(31 downto 16);
                    when "10001" =>
                        result <= "00000000000000000" & inputA(31 downto 17);
                    when "10010" =>
                        result <= "000000000000000000" & inputA(31 downto 18);
                    when "10011" =>
                        result <= "0000000000000000000" & inputA(31 downto 19);
                    when "10100" =>
                        result <= "00000000000000000000" & inputA(31 downto 20);
                    when "10101" =>
                        result <= "000000000000000000000" & inputA(31 downto 21);
                    when "10110" =>
                        result <= "0000000000000000000000" & inputA(31 downto 22);
                    when "10111" =>
                        result <= "00000000000000000000000" & inputA(31 downto 23);
                    when "11000" =>
                        result <= "000000000000000000000000" & inputA(31 downto 24);
                    when "11001" =>
                        result <= "0000000000000000000000000" & inputA(31 downto 25);
                    when "11010" =>
                        result <= "00000000000000000000000000" & inputA(31 downto 26);
                    when "11011" =>
                        result <= "000000000000000000000000000" & inputA(31 downto 27);
                    when "11100" =>
                        result <= "0000000000000000000000000000" & inputA(31 downto 28);
                    when "11101" =>
                        result <= "00000000000000000000000000000" & inputA(31 downto 29);
                    when "11110" =>
                        result <= "000000000000000000000000000000" & inputA(31 downto 30);
                    when "11111" =>
                        result <= "0000000000000000000000000000000" & inputA(31 downto 31);
                    when others =>
                        result <= X"00000000";
                end case;
            when "1010" => -- shift left logical vector
                case (inputB) is
                    when "00000000000000000000000000000000" =>
                        result <= inputA;
                    when "00000000000000000000000000000001" =>
                        result <= inputA(30 downto 0) & "0";
                    when "00000000000000000000000000000010" =>
                        result <= inputA(29 downto 0) & "00";
                    when "00000000000000000000000000000011" =>
                        result <= inputA(28 downto 0) & "000";
                    when "00000000000000000000000000000100" =>
                        result <= inputA(27 downto 0) & "0000";
                    when "00000000000000000000000000000101" =>
                        result <= inputA(26 downto 0) & "00000";
                    when "00000000000000000000000000000110" =>
                        result <= inputA(25 downto 0) & "000000";
                    when "00000000000000000000000000000111" =>
                        result <= inputA(24 downto 0) & "0000000";
                    when "00000000000000000000000000001000" =>
                        result <= inputA(23 downto 0) & "00000000";
                    when "00000000000000000000000000001001" =>
                        result <= inputA(22 downto 0) & "000000000";
                    when "00000000000000000000000000001010" =>
                        result <= inputA(21 downto 0) & "0000000000";
                    when "00000000000000000000000000001011" =>
                        result <= inputA(20 downto 0) & "00000000000";
                    when "00000000000000000000000000001100" =>
                        result <= inputA(19 downto 0) & "000000000000";
                    when "00000000000000000000000000001101" =>
                        result <= inputA(18 downto 0) & "0000000000000";
                    when "00000000000000000000000000001110" =>
                        result <= inputA(17 downto 0) & "00000000000000";
                    when "00000000000000000000000000001111" =>
                        result <= inputA(16 downto 0) & "000000000000000";
                    when "00000000000000000000000000010000" =>
                        result <= inputA(15 downto 0) & "0000000000000000";
                    when "00000000000000000000000000010001" =>
                        result <= inputA(14 downto 0) & "00000000000000000";
                    when "00000000000000000000000000010010" =>
                        result <= inputA(13 downto 0) & "000000000000000000";
                    when "00000000000000000000000000010011" =>
                        result <= inputA(12 downto 0) & "0000000000000000000";
                    when "00000000000000000000000000010100" =>
                        result <= inputA(11 downto 0) & "00000000000000000000";
                    when "00000000000000000000000000010101" =>
                        result <= inputA(10 downto 0) & "000000000000000000000";
                    when "00000000000000000000000000010110" =>
                        result <= inputA(9 downto 0) & "0000000000000000000000";
                    when "00000000000000000000000000010111" =>
                        result <= inputA(8 downto 0) & "00000000000000000000000";
                    when "00000000000000000000000000011000" =>
                        result <= inputA(7 downto 0) & "000000000000000000000000";
                    when "00000000000000000000000000011001" =>
                        result <= inputA(6 downto 0) & "0000000000000000000000000";
                    when "00000000000000000000000000011010" =>
                        result <= inputA(5 downto 0) & "00000000000000000000000000";
                    when "00000000000000000000000000011011" =>
                        result <= inputA(4 downto 0) & "000000000000000000000000000";
                    when "00000000000000000000000000011100" =>
                        result <= inputA(3 downto 0) & "0000000000000000000000000000";
                    when "00000000000000000000000000011101" =>
                        result <= inputA(2 downto 0) & "00000000000000000000000000000";
                    when "00000000000000000000000000011110" =>
                        result <= inputA(1 downto 0) & "000000000000000000000000000000";
                    when "00000000000000000000000000011111" =>
                        result <= inputA(0 downto 0) & "0000000000000000000000000000000";
                    when others =>
                        result <= X"00000000";
                end case;
            when "1011" => -- shift right logical vector
                case (inputB) is
                    when "00000000000000000000000000000000" =>
                        result <= inputA;
                    when "00000000000000000000000000000001" =>
                        result <= "0" & inputA(31 downto 1);
                    when "00000000000000000000000000000010" =>
                        result <= "00" & inputA(31 downto 2);
                    when "00000000000000000000000000000011" =>
                        result <= "000" & inputA(31 downto 3);
                    when "00000000000000000000000000000100" =>
                        result <= "0000" & inputA(31 downto 4);
                    when "00000000000000000000000000000101" =>
                        result <= "00000" & inputA(31 downto 5);
                    when "00000000000000000000000000000110" =>
                        result <= "000000" & inputA(31 downto 6);
                    when "00000000000000000000000000000111" =>
                        result <= "0000000" & inputA(31 downto 7);
                    when "00000000000000000000000000001000" =>
                        result <= "00000000" & inputA(31 downto 8);
                    when "00000000000000000000000000001001" =>
                        result <= "000000000" & inputA(31 downto 9);
                    when "00000000000000000000000000001010" =>
                        result <= "0000000000" & inputA(31 downto 10);
                    when "00000000000000000000000000001011" =>
                        result <= "00000000000" & inputA(31 downto 11);
                    when "00000000000000000000000000001100" =>
                        result <= "000000000000" & inputA(31 downto 12);
                    when "00000000000000000000000000001101" =>
                        result <= "0000000000000" & inputA(31 downto 13);
                    when "00000000000000000000000000001110" =>
                        result <= "00000000000000" & inputA(31 downto 14);
                    when "00000000000000000000000000001111" =>
                        result <= "000000000000000" & inputA(31 downto 15);
                    when "00000000000000000000000000010000" =>
                        result <= "0000000000000000" & inputA(31 downto 16);
                    when "00000000000000000000000000010001" =>
                        result <= "00000000000000000" & inputA(31 downto 17);
                    when "00000000000000000000000000010010" =>
                        result <= "000000000000000000" & inputA(31 downto 18);
                    when "00000000000000000000000000010011" =>
                        result <= "0000000000000000000" & inputA(31 downto 19);
                    when "00000000000000000000000000010100" =>
                        result <= "00000000000000000000" & inputA(31 downto 20);
                    when "00000000000000000000000000010101" =>
                        result <= "000000000000000000000" & inputA(31 downto 21);
                    when "00000000000000000000000000010110" =>
                        result <= "0000000000000000000000" & inputA(31 downto 22);
                    when "00000000000000000000000000010111" =>
                        result <= "00000000000000000000000" & inputA(31 downto 23);
                    when "00000000000000000000000000011000" =>
                        result <= "000000000000000000000000" & inputA(31 downto 24);
                    when "00000000000000000000000000011001" =>
                        result <= "0000000000000000000000000" & inputA(31 downto 25);
                    when "00000000000000000000000000011010" =>
                        result <= "00000000000000000000000000" & inputA(31 downto 26);
                    when "00000000000000000000000000011011" =>
                        result <= "000000000000000000000000000" & inputA(31 downto 27);
                    when "00000000000000000000000000011100" =>
                        result <= "0000000000000000000000000000" & inputA(31 downto 28);
                    when "00000000000000000000000000011101" =>
                        result <= "00000000000000000000000000000" & inputA(31 downto 29);
                    when "00000000000000000000000000011110" =>
                        result <= "000000000000000000000000000000" & inputA(31 downto 30);
                    when "00000000000000000000000000011111" =>
                        result <= "0000000000000000000000000000000" & inputA(31 downto 31);
                    when others =>
                        result <= X"00000000";
                end case;
            when "1100" => -- nor
                result <= not(inputA or inputB);
            when "1101" => -- load upper immediate
                result <= inputA(15 downto 0) & X"0000";
            when others =>
                result <= X"00000000";
        end case;
        if (result = X"00000000") then
            Zero <= '1';
        else
            Zero <= '0';
        end if;
    end process;
end arch;