library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity ShiftLeft26Bit is
    generic(WIDTH : positive := 26);
    port(
        input: in std_logic_vector(WIDTH - 1 downto 0);
        output: out std_logic_vector(WIDTH + 1 downto 0)
    );
end ShiftLeft26Bit;

architecture behavioral of ShiftLeft26Bit is
begin

    output(WIDTH + 1 downto 0) <= input(WIDTH - 1 downto 0) & "00";

end behavioral;