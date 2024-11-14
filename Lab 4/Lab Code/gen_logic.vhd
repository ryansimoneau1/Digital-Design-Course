library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use ieee.math_real.all;

entity gen_logic is
    generic (
        ms_period : positive := 10);          -- amount of ms for button to be
                                        -- pressed before creating clock pulse
    port(
        div_source, rst, button: in std_logic;
        pulse: out std_logic
    );
    end gen_logic;

architecture behavioral of gen_logic is
signal temp_out: std_logic;
begin
    process(div_source,rst,button)
    variable countGEN: integer := 0;
    begin
        if(rst = '1') then
            countGEN := 0;
            temp_out <= '0';
        elsif(rising_edge(div_source)) then
            if(button = '1') then
                countGEN := countGEN + 1;
                if(countGEN >= ms_period) then
                    countGEN := 0;
                    temp_out <= '1';
                else
                    temp_out <= '0';
                end if;
            else
                countGEN := 0;
                temp_out <= '0';
            end if;
        end if;
    end process;
    pulse <= temp_out;
end behavioral;