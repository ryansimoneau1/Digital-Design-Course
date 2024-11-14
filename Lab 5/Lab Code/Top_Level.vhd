library ieee;
use ieee.std_logic_1164.all;

entity top_level is
    port (
        clk      : in  std_logic;
        rst      : in  std_logic;
        go       : in  std_logic;
        switch   : in  std_logic_vector(9 downto 0); -- where n will be
        ledr0    : out std_logic;                    -- where the done signal will go
        led0     : out std_logic_vector(6 downto 0);
        led0_dp  : out std_logic;
        led1     : out std_logic_vector(6 downto 0);
        led1_dp  : out std_logic;
        led2     : out std_logic_vector(6 downto 0);
        led2_dp  : out std_logic;
        led3     : out std_logic_vector(6 downto 0);
        led3_dp  : out std_logic
        );
end top_level;

architecture STR of top_level is

    component factorial
    generic(
        WIDTH         :   positive := 16);
      port(
        clk     : in  std_logic;
        rst     : in  std_logic;
        n       : in  std_logic_vector(width-1 downto 0);
        go      : in  std_logic;
        done    : out std_logic;
        output  : out std_logic_vector(WIDTH-1 downto 0));
    end component;

    component segment_crtl
    port(
        factorial : in std_logic_vector(15 downto 0):= (others => '0'); 
        seg0      : out std_logic_vector(6 downto 0);
        seg1      : out std_logic_vector(6 downto 0);
        seg2      : out std_logic_vector(6 downto 0);
        seg3      : out std_logic_vector(6 downto 0)); 
    end component;

signal inputN    : std_logic_vector(15 downto 0);
signal outputFact: std_logic_vector(15 downto 0);

begin  -- STR

    inputN <= "0000000000000" & switch(2 downto 0);

    Factorial1: factorial
    generic map(
        WIDTH => 16)
    port map(
        clk    => clk,
        rst    => rst,
        n      => inputN,
        go     => go,
        done   => ledr0,
        output => outputFact
    );
    
    U_LEDs : segment_crtl 
    port map(
        factorial => outputFact,
        seg0      => led0,     
        seg1      => led1,
        seg2      => led2,
        seg3      => led3
    ); 
    

    led3_dp <= '1';
    led2_dp <= '1';
    led1_dp <= '1';
    led0_dp <= '1';

end STR;