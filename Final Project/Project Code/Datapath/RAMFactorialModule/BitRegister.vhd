library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity BitRegister is
  port(
    input                : in std_logic;
    clk                  : in std_logic;
    rst             : in std_logic;
    enable               : in std_logic;
    output               : out std_logic
  );
end BitRegister;

architecture behavioral of BitRegister is
begin

    process(clk, rst)
    begin
      if (rst = '1') then
        output <='0';
      elsif(rising_edge(clk)) then
        if(enable = '1') then
          output <= input;
        end if;
      end if;
    end process;
    end behavioral;