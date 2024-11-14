library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity IOEnable is
    generic(WIDTH: positive := 32);
    port(
        DIPData   : in std_logic_vector(WIDTH - 1 downto 0);
        Button    : in std_logic;
        Inport0En : out std_logic;
        Inport1En : out std_logic
    );
end IOEnable;

architecture behavioral of IOEnable is

begin
    process(DIPData, Button)
    begin

        if(DIPData(9) = '0' and Button = '0') then
            Inport0En <= '1';
        else
            Inport0En <= '0';
        end if;

        if(DIPData(9) = '1' and Button = '0') then
            Inport1En <= '1';
        else
            Inport1En <= '0';
        end if;
    end process;
end behavioral;

        