library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity ShiftLeft32Bit is
    generic(WIDTH : positive := 32);
    port(
        input: in std_logic_vector(WIDTH - 1 downto 0);
        output: out std_logic_vector(WIDTH - 1 downto 0)
    );
end ShiftLeft32Bit;

architecture behavioral of ShiftLeft32Bit is
begin

    output(WIDTH - 1 downto 0) <= input(WIDTH - 3 downto 0) & "00";

end behavioral;