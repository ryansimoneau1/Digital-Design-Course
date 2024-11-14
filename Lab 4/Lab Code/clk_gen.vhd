library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use ieee.math_real.all;

entity clk_gen is
    generic (
        ms_period : positive := 10);          -- amount of ms for button to be
                                        -- pressed before creating clock pulse
    port (
        clk50MHz : in  std_logic;
        rst      : in  std_logic;
        button_n : in  std_logic;
        clk_out  : out std_logic);
end clk_gen;

architecture STR of clk_gen is

    component clk_div
    generic(clk_in_freq  : natural := 50000;
            clk_out_freq : natural := 1);
    port (
        clk_in  : in  std_logic;
        clk_out : out std_logic;
        rst     : in  std_logic);
    end component;

    component gen_logic
    generic (
        ms_period : positive := 10);          -- amount of ms for button to be
                                        -- pressed before creating clock pulse
    port(
        div_source, rst, button: in std_logic;
        pulse: out std_logic
    );
    end component;

signal Div_out: std_logic;
begin
    C_DIV: clk_div
    port map(
        clk_in  => clk50MHz,
        clk_out => Div_out,
        rst     => rst
    );

    Gen_log: gen_logic
    port map(
        div_source => Div_out,
        rst        => rst,
        button     => button_n,
        pulse      => clk_out
    );
end STR;