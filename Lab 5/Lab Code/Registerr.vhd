library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity registerr is
  generic(
    WIDTH         :   positive := 16);
  port(
    input                : in std_logic_vector(width - 1 downto 0);
    clk                  : in std_logic;
    reset                : in std_logic;
    enable               : in std_logic;
    output               : out std_logic_vector(width - 1 downto 0)
  );
end registerr;

architecture behavioral of registerr is
begin

  process(clk, reset)
  begin
    if (reset = '1') then
      output <= (others => '0');
    elsif(rising_edge(clk)) then
      if(enable = '1') then
        output <= input;
      end if;
    end if;
  end process;
end behavioral;