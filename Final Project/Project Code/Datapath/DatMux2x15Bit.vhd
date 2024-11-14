library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity DatMux2x15Bit is
    port(
        A, B    : in std_logic_vector(4 downto 0);
        sel     : in std_logic;
        output  : out std_logic_vector(4 downto 0)
    ); 
end DatMux2x15Bit;

architecture behavioral of DatMux2x15Bit is
begin
    with sel select
    output <= B when '0', A when others;
end behavioral;