library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity DatMux2x1 is
    generic(WIDTH: positive := 32);
    port(
        A, B    : in std_logic_vector(width - 1 downto 0);
        sel     : in std_logic;
        output  : out std_logic_vector(width - 1 downto 0)
    ); 
end DatMux2x1;

architecture behavioral of DatMux2x1 is
begin
    with sel select
    output <= B when '0', A when others;
end behavioral;