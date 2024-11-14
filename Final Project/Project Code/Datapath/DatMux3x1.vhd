library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity DatMux3x1 is
    generic(
        WIDTH         :   positive := 32);
    port(
        A, B, C    : in std_logic_vector(width - 1 downto 0);
        sel        : in std_logic_vector(1 downto 0);
        output  : out std_logic_vector(width - 1 downto 0)
    ); 
end DatMux3x1;

architecture behavioral of DatMux3x1 is
begin
    with sel select
    output <= C when "00",
              B when "01",
              A when "10",
              ( others => '0') when others;
end behavioral;