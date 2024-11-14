library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity Concat28to32 is
    port(
        input1: in std_logic_vector(27 downto 0);
        input2: in std_logic_vector(3 downto 0);
        output: out std_logic_vector(31 downto 0)
    );
end Concat28to32;

architecture behavioral of Concat28to32 is

begin

    output <= std_logic_vector(unsigned(input2) & unsigned(input1));

end behavioral;