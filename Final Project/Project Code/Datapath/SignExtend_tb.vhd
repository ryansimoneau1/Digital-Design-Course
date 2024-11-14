library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity SignExtend_tb is
end SignExtend_tb;

architecture TB of SignExtend_tb is

    signal inputt: std_logic_vector(15 downto 0);
    signal outputt: std_logic_vector(31 downto 0);

    component SignExtend
    generic(WIDTH : positive := 32);
    port(
        input : in std_logic_vector(WIDTH/2 - 1 downto 0);
        output: out std_logic_vector(WIDTH - 1 downto 0)
    );
    end component;

begin

    UUT: SignExtend
    port map(
        input   => inputt,
        output  => outputt
    );

    process
    begin

        inputt <= "0000000000110110";
        wait for 10 ns;

        inputt <= "1000000000110110";

        wait;

    end process;
end TB;