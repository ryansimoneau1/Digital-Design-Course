library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity FactorialRegisters is
    generic(WIDTH: positive := 32);
    port(
        clk         : in std_logic;
        rst             : in std_logic;
        NEn         : in std_logic;
        GoEn        : in std_logic;
        Goin        : in std_logic;
        Donein      : in std_logic;
        Nin         : in std_logic_vector(WIDTH - 1 downto 0);
        Resultin    : in std_logic_vector(WIDTH - 1 downto 0);
        GoOut       : out std_logic;
        DoneOut     : out std_logic;
        NOut        : out std_logic_vector(WIDTH - 1 downto 0);
        ResultOut   : out std_logic_vector(WIDTH - 1 downto 0)
    );
    end FactorialRegisters;

architecture structural of FactorialRegisters is

    component registers
    generic(WIDTH : positive := 32);
    port(
        input  : in std_logic_vector(WIDTH - 1 downto 0);
        
        clk    : in std_logic;
        rst             : in std_logic;
        enable : in std_logic;
        output : out std_logic_vector(WIDTH - 1 downto 0)
    );
    end component;

    component BitRegister
    port(
        input  : in std_logic;
        clk    : in std_logic;
        rst             : in std_logic;
        enable : in std_logic;
        output : out std_logic
    );
    end component;

begin

    GoReg: BitRegister
    port map(
        input           => Goin,
        clk             => clk,
        rst     => rst,
        enable          => GoEn,
        output          => GoOut
    );

    NReg: registers
    port map(
        input           => Nin,
        clk             => clk,
        rst     => rst,
        enable          => NEn,
        output          => NOut
    );

    ResultReg: registers
    port map(
        input           => Resultin,
        clk             => clk,
        rst     => rst,
        enable          => '1',
        output          => ResultOut
    );

    DoneReg: BitRegister
    port map(
        input           => Donein,
        clk             => clk,
        rst     => rst,
        enable          => '1',
        output          => DoneOut
    );
end structural;

