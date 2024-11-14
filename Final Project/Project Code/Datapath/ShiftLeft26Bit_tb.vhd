library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity ShiftLeft26Bit_tb is
end ShiftLeft26Bit_tb;

architecture TB of ShiftLeft26Bit_tb is

    signal inputt: std_logic_vector(25 downto 0);
    signal outputt: std_logic_vector(27 downto 0);

    component ShiftLeft26Bit
    generic(WIDTH : positive := 26);
    port(
        input: in std_logic_vector(WIDTH - 1 downto 0);
        output: out std_logic_vector(WIDTH + 1 downto 0)
    );
    end component;

begin

    UUT: ShiftLeft26Bit
    port map(
        input   => inputt,
        output  => outputt
    );

    process
    begin

        inputt <= "00000000000000000000110110";

        wait;

    end process;
end TB;