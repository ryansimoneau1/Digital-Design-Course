library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity decrementor is
  generic(
    WIDTH         :   positive := 16);
  port(
    input  : in std_logic_vector(width - 1 downto 0);
    output : out std_logic_vector(width - 1 downto 0)
  );
end decrementor;

architecture behavioral of decrementor is 
begin
  output <= std_logic_vector(unsigned(input) - 1);
end behavioral;