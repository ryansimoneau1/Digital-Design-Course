library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity counter is
    port (
        clk    : in  std_logic;
        rst    : in  std_logic;
        go     : in std_logic;
        up_n   : in  std_logic;         -- active low
        load_n : in  std_logic;         -- active low
        input  : in  std_logic_vector(3 downto 0);
        output : out std_logic_vector(3 downto 0));
end counter;

architecture behavioral of counter is
begin
    process(clk,rst)
    variable counting : unsigned(3 downto 0);
    begin
        if(rst = '1') then
            counting    := to_unsigned(0,4);
        elsif(rising_edge(clk)) then
            if(go = '1') then
                if(load_n = '0') then
                    counting := unsigned(input(3 downto 0));
                elsif(up_n = '0') then
                    counting := counting + 1;
                else
                    counting := counting - 1;
                end if;
            end if;
        end if;
        output <= std_logic_vector(counting);
    end process;


end behavioral;