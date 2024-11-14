library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_arith.all;
use ieee.std_logic_unsigned.all;

entity decoder7seg is
    port (
    input  : in std_logic_vector(3 downto 0);
    output : out std_logic_vector(6 downto 0)
    );
end decoder7seg;

architecture BHV of decoder7seg is
begin

process(input)
begin
    case input is
        
        -- 0
        when "0000" =>
        output <= "0000001";
        -- 1
        when "0001" =>
        output <= "1001111";
        -- 2
        when "0010" =>
        output <= "0010010";
        -- 3
        when "0011" =>
        output <= "0000110";
        -- 4
        when "0100" =>
        output <= "1001100";
        -- 5
        when "0101" =>
        output <= "0100100";
        -- 6
        when "0110" =>
        output <= "0100000";
        -- 7
        when "0111" =>
        output <= "0001111";
        -- 8
        when "1000" =>
        output <= "0000000";
        -- 9
        when "1001" =>
        output <= "0001100";
        -- A
        when "1010" =>
        output <= "0001000";
        -- B
        when "1011" =>
        output <= "1100000";
        -- C
        when "1100" =>
        output <= "0110001";
        -- D
        when "1101" =>
        output <= "1000010";
        -- E
        when "1110" =>
        output <= "0110000";
        -- F
        when "1111" =>
        output <= "0111000";
        -- In case of errors, makes a V shape
        when others =>
        output <= "1010101";
        
    end case;
end process;
end BHV;