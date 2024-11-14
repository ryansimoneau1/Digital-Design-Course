library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity datapath1 is
  generic(
  WIDTH :   positive := 16);
  port(
    clk             : in std_logic;
    rst             : in std_logic;
    n               : in std_logic_vector(width-1 downto 0);

    regN_en         : in std_logic;
    regN_sel        : in std_logic;
    tempFact_en     : in std_logic;
    tempFact_sel    : in std_logic;
    output_en       : in std_logic;
    n_ge_1          : out std_logic;
    output          : out std_logic_vector(width-1 downto 0)

  );
end datapath1;

architecture STR of datapath1 is

signal RNMtoRN, TFMtoTF, TFO, MtoTFM, RNO, DtoRNM: std_logic_vector(width - 1 downto 0); -- intermediate signals between each of the 8 components
constant C1: std_logic_vector(width-1 downto 0) := std_logic_vector(to_unsigned(1, width));

-- defining components
component Multiplexer
  generic(
    WIDTH         :   positive := 16);
  port(
    A, B    : in std_logic_vector(width - 1 downto 0);
    sel     : in std_logic;
    output  : out std_logic_vector(width - 1 downto 0)
  );
end component;

component comparator
generic(
  WIDTH         :   positive := 16);
  port(
    input : in std_logic_vector(width - 1 downto 0);
    n_ge_1: out std_logic
  );
end component;

component Registerr
generic(
  WIDTH         :   positive := 16);
  port(
    input                : in std_logic_vector(width - 1 downto 0);
    clk                  : in std_logic;
    reset                : in std_logic;
    enable               : in std_logic;
    output               : out std_logic_vector(width - 1 downto 0)
  );
end component;

component Multiplier
generic(
  WIDTH         :   positive := 16);
  port(
    in1, in2:  in std_logic_vector((width) - 1 downto 0);
    output  :  out std_logic_vector((width) - 1 downto 0)
  );
end component;

component Decrementor
generic(
  WIDTH         :   positive := 16);
  port(
    input  : in std_logic_vector(width - 1 downto 0);
    output : out std_logic_vector(width - 1 downto 0)
  );
end component;

begin
  -- Note: instantiations go component => signal
  RegNMux: multiplexer
  generic map (
    WIDTH => WIDTH)
  port map (
    A      => DtoRNM,
    B      => n,
    sel    => regN_sel,
    output => RNMtoRN
  );

  FactMux: multiplexer
  generic map (
    WIDTH => WIDTH)
  port map (
    A      => C1,
    B      => MtoTFM,
    sel    => tempFact_sel,
    output => TFMtoTF
  );

  RegN: registerr
  generic map (
    WIDTH => WIDTH)
  port map (
    input  => RNMtoRN,
    clk    => clk,
    reset  => rst,
    enable => regN_en,
    output => RNO
  );

  TempFact: registerr
  generic map (
    WIDTH => WIDTH)
  port map (
    input  => TFMtoTF,
    clk    => clk,
    reset  => rst,
    enable => tempFact_en,
    output => TFO
  );

  OutputReg: registerr
  generic map (
    WIDTH => WIDTH)
  port map (
    input  => TFO,
    clk    => clk,
    reset  => rst,
    enable => output_en,
    output => output
  );

  Mult: Multiplier
  generic map (
    WIDTH => WIDTH)
  port map (
    in1    => TFO,
    in2    => RNO,
    output => MtoTFM
  );

  Comp: comparator
  generic map (
    WIDTH => WIDTH)
  port map (
    input  => RNO,
    n_ge_1 => n_ge_1
  );

  Dec: Decrementor
  generic map (
    WIDTH => WIDTH)
  port map (
    input  => RNO,
    output => DtoRNM
  );

end STR;
