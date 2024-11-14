library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity comparator is
  generic(
    WIDTH         :   positive := 16);
  port(
    input : in std_logic_vector(width - 1 downto 0);
    n_ge_1: out std_logic
  );
end comparator;

architecture behavioral of comparator is
begin
  n_ge_1 <= '1' when unsigned(input) >= 1 else '0';
end behavioral;