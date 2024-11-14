library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity Concat28to32_tb is
end Concat28to32_tb;

architecture TB of Concat28to32_tb is

    signal input1t: std_logic_vector(27 downto 0);
    signal input2t: std_logic_vector(3 downto 0);
    signal outputt: std_logic_vector(31 downto 0);

    component Concat28to32
    port(
        input1: in std_logic_vector(27 downto 0);
        input2: in std_logic_vector(3 downto 0);
        output: out std_logic_vector(31 downto 0)
    );
    end component;

begin

    UUT: Concat28to32
    port map(
        input1  => input1t,
        input2  => input2t,
        output  => outputt
    );

    process
    begin

        input1t <= "0000000000000000000000110110";
        input2t <="1010";

        wait;

    end process;
end TB;