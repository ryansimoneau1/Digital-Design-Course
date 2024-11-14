library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity DatMux4x1 is
    generic(
        WIDTH         :   positive := 32);
    port(
        A, B, C, D    : in std_logic_vector(width - 1 downto 0);
        sel           : in std_logic_vector(1 downto 0);
        output  : out std_logic_vector(width - 1 downto 0)
    ); 
end DatMux4x1;

architecture behavioral of DatMux4x1 is
begin
    with sel select
    output <= D when "00",
              C when "01",
              B when "10",
              A when "11",
              (others => '0') when others;
end behavioral;