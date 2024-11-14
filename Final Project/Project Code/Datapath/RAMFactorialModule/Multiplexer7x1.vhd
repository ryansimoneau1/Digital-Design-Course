library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity multiplexer7x1 is
    generic(
        WIDTH         :   positive := 32);
    port(
        D, G                : in std_logic;
        A, B, C, E, F       : in std_logic_vector(WIDTH - 1 downto 0);
        sel                 : in std_logic_vector(2 downto 0);
        output              : out std_logic_vector(WIDTH - 1 downto 0)
    ); 
end multiplexer7x1;

architecture behavioral of multiplexer7x1 is
    -- select values
    constant RAM    : std_logic_vector(2 downto 0) := "000";
    constant PORT0  : std_logic_vector(2 downto 0) := "001";
    constant PORT1  : std_logic_vector(2 downto 0) := "010";
    constant G0     : std_logic_vector(2 downto 0) := "011";
    constant Nn     : std_logic_vector(2 downto 0) := "100";
    constant RSLT   : std_logic_vector(2 downto 0) := "101";
    constant DNE    : std_logic_vector(2 downto 0) := "110";

    constant Zeros: unsigned(WIDTH - 2 downto 0) := (others => '0');
    signal   D2,G2: std_logic_vector(0 downto 0);
begin

    D2 <= (0 => D);
    G2 <= (0 => G);

    with sel select
    output <= A when RAM,
              B when PORT0,
              C when PORT1,
              std_logic_vector(Zeros & unsigned(D2)) when G0,
              E when Nn,
              F when RSLT,
              std_logic_vector(Zeros & unsigned(G2)) when DNE,
              (others => '0') when others;
end behavioral;