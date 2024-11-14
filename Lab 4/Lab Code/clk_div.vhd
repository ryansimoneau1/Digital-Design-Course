library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use ieee.math_real.all;

entity clk_div is
    generic(clk_in_freq  : natural := 50000;
            clk_out_freq : natural := 1);
    port (
        clk_in  : in  std_logic;
        clk_out : out std_logic;
        rst     : in  std_logic);
end clk_div;
--integer(clk_in_freq)/integer(clk_out_freq) 
architecture behavioral of clk_div is
        signal temp_clk : std_logic;
        constant divider: integer := clk_in_freq ;
begin
        process(clk_in, rst)
        variable count : integer := 0;
        begin
                if(rst = '1') then
                        count    := 0;
                        temp_clk <= '0';
                elsif(rising_edge(clk_in)) then
                        if(count < divider/2) then
                                count := count + 1;
                        else
                                count    := 0;
                                temp_clk <= not temp_clk;
                        end if;
                end if;
        end process;
        clk_out <= temp_clk;
end behavioral;
















-- other attempts:
-- architecture behavioral of clk_div is
--         signal temp_clk: std_logic;
-- begin
--         process(clk_in, rst)
--         variable count : integer := 0;
--         begin
--                 if(rst = '1') then
--                         count    := 0;
--                         temp_clk <= '0';
--                 elsif(rising_edge(clk_in)) then
--                         if(count < 25000 and temp_clk = '0') then
--                                 count    := count + 1;
--                                 temp_clk <= '0';
--                         elsif(count >= 25000) then
--                                 count    :=  0;
--                                 temp_clk <= '1';
--                         end if;

--                         if(count < 25000 and temp_clk = '1') then
--                                 count    := count + 1;
--                                 temp_clk <= '1';
--                         elsif(count >= 25000) then
--                                 count    :=  0;
--                                 temp_clk <= '0';
--                         end if;
--                 end if;
--         end process;
--         clk_out <= temp_clk;

-- end behavioral;

-- architecture behavioral of clk_div is
--         constant duty   : integer    := 50               ; -- defines the duty cycle of the clock in decimal form
--         constant ratio  : integer     := 50000            ; -- the ratio of the input clock to the output clock
--         constant ZorO   : std_logic                       ; -- used to keep track of zero or one for the output signal

-- begin
        

--         process(clk_in, rst)
--         variable Zerocnt: unsigned := (1 - duty/10)*50000; -- variables used to determine how long the signal should be high or low
--         variable Onecnt : unsigned := duty*50000                ;
--         begin
--                 if(rst = '1') then
--                         ZorO    := 0;
--                         Zerocnt := (1 - duty/10)*50000;
--                         Onecnt  := duty*50000;
--                         clk_out <= '0';
--                 elsif(rising_edge(clk_in)) then
--                         if(ZorO = 0) then
--                                 Zerocnt := Zerocnt - 1;
--                                 clk_out <= '0';
--                                 if(Zerocnt = 0) then
--                                         Zerocnt := (1 - duty/10)*50000;
--                                         ZorO    := 1;
--                                 end if;
--                         elsif(ZorO = 1) then
--                                 Onecnt  := Onecnt - 1;
--                                 clk_out <= '1';
--                                 if(Onecnt = 0) then
--                                         Onecnt := duty*50000;
--                                         ZorO   := 0;
--                                 end if;
--                         end if;
--                 end if;
--         end process;
-- end behavioral;
