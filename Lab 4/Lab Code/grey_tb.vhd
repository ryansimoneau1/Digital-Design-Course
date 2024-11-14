library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity grey_tb is
end grey_tb;

architecture TB of grey_tb is

    component gray1
    port(
    clk    : in  std_logic;
    rst    : in  std_logic;
    go     : in std_logic;
    output : out std_logic_vector(3 downto 0));
    end component;

    signal clk1 : std_logic := '0';
    signal rst  : std_logic;
    signal g0   : std_logic;

    begin 
    
    UUT : gray1
    port map (
        clk => clk1,
        go  => g0,
        rst => rst);

    clk1 <= not clk1 after 1000 ms;

    process
    begin
        rst <= '1';

        -- wait for 5 cycles
        for i in 0 to 5 loop
            wait until clk1'event and clk1 = '1';
        end loop;  -- i

        wait for 500 ms;
        rst <= '0';

        wait for 1000 ms; -- 0
        g0 <= '1';

        wait for 1000 ms;
        g0 <= '0';

        wait for 1000 ms; -- 1
        g0 <= '1';

        wait for 1000 ms;
        g0 <= '0';

        wait for 1000 ms; -- 2
        g0 <= '1';

        wait for 1000 ms;
        g0 <= '0';

        wait for 1000 ms; -- 3
        g0 <= '1';

        wait for 1000 ms;
        g0 <= '0';

        wait for 1000 ms; -- 4
        g0 <= '1';

        wait for 1000 ms;
        g0 <= '0';

        wait for 1000 ms; -- 5
        g0 <= '1';

        wait for 1000 ms;
        g0 <= '0';

        wait for 1000 ms; -- 6
        g0 <= '1';

        wait for 1000 ms;
        g0 <= '0';

        wait for 1000 ms; --7 
        g0 <= '1';

        wait for 1000 ms;
        g0 <= '0';

        wait for 1000 ms; -- 8
        g0 <= '1';

        wait for 1000 ms;
        g0 <= '0';

        wait for 1000 ms; -- 9
        g0 <= '1';

        wait for 1000 ms;
        g0 <= '0';

        wait for 1000 ms; -- A
        g0 <= '1';

        wait for 1000 ms;
        g0 <= '0';

        wait for 1000 ms; -- B
        g0 <= '1';

        wait for 1000 ms;
        g0 <= '0';

        wait for 1000 ms; -- C
        g0 <= '1';

        wait for 1000 ms;
        g0 <= '0';

        wait for 1000 ms; -- D
        g0 <= '1';

        wait for 1000 ms;
        g0 <= '0';

        wait for 1000 ms; -- E
        g0 <= '1';

        wait for 1000 ms;
        g0 <= '0';

        wait for 1000 ms; -- F
        g0 <= '1';

        wait for 1000 ms;
        g0 <= '0';

        wait for 1000 ms; -- 0
        g0 <= '1'; -- check to see if FSM wraps back around


    end process;
end TB;