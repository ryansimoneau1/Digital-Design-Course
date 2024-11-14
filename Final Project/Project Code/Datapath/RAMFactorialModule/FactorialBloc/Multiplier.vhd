library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity multiplier is
  generic(
    WIDTH         :   positive := 16);
  port(
    in1, in2:  in std_logic_vector((width) - 1 downto 0);
    output  :  out std_logic_vector((width) - 1 downto 0)
  );
end multiplier;

architecture behavioral of multiplier is
signal Largetemp: unsigned(2*(width) - 1 downto 0);
begin

  Largetemp <= (unsigned(in1)*unsigned(in2));

  output    <= std_logic_vector(Largetemp(width - 1 downto 0));
end behavioral;


