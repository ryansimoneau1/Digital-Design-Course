library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity counter_tb is
end counter_tb;
    
architecture TB of counter_tb is

    component counter
    port (
        clk    : in  std_logic;
        rst    : in  std_logic;
        go     : in std_logic;
        up_n   : in  std_logic;         -- active low
        load_n : in  std_logic;         -- active low
        input  : in  std_logic_vector(3 downto 0);
        output : out std_logic_vector(3 downto 0));
    end component;

    signal clk1 : std_logic := '0';
    signal rst  : std_logic;
    signal g0   : std_logic;
    signal up   : std_logic;
    signal load : std_logic;
    signal inp  : std_logic_vector(3 downto 0);
    signal outp : std_logic_vector(3 downto 0);
begin
    UUT : counter 
    port map (
        clk   => clk1,
        go     => g0,
        rst    => rst,
        up_n   => up,
        load_n => load,
        input  => inp,
        output => outp);

    clk1 <= not clk1 after 1000 ms;

    process
    begin
        rst  <= '1';
        up   <= '0';
        load <= '1';


        -- wait for 5 cycles
        for i in 0 to 5 loop
            wait until clk1'event and clk1 = '1';
        end loop;  -- i

        wait for 500 ms;
        rst <= '0';

        wait for 1000 ms; -- 0
        g0 <= '1';

        wait for 1000 ms;
        load <= '0';
        inp <= "1010";

        wait for 1000 ms; -- 1
        load <= '1';

        wait for 15000 ms; -- guarentee an overflow
        up <= '1';

        wait for 16000 ms;
    end process;
end TB;
        
