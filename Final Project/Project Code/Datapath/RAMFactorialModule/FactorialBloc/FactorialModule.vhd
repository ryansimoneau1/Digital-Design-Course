library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity FactorialModule is
  generic(WIDTH : positive := 32);
  port(
    clk     : in  std_logic;
    rst             : in std_logic;
    n       : in  std_logic_vector(width-1 downto 0);
    go      : in  std_logic;
    done    : out std_logic;
    output  : out std_logic_vector(WIDTH-1 downto 0)

  );
end FactorialModule;

architecture FSM_D1 of FactorialModule is

-- Fill in with your code
signal RNS, RNE, TFS, TFE, OE, NGEO: std_logic;

component FactDatapath
generic(
  WIDTH :   positive := 32);
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
end component;

component FactCtrl
  port(
    clk           : in std_logic;
    rst             : in std_logic;
    go            : in std_logic;
    n_ge_1        : in std_logic;
    regN_sel      : out std_logic;
    regN_en       : out std_logic;
    output_en     : out std_logic;
    tempFact_sel  : out std_logic;
    tempFact_en   : out std_logic;
    done          : out std_logic
  );
end component;

begin 
  
   -- Fill in with your code
  DATA: FactDatapath
  generic map (
    WIDTH => WIDTH)
  port map(
    clk          => clk,
    rst     => rst,
    n            => n,
    regN_en      => RNE,    
    regN_sel     => RNS,  
    tempFact_en  => TFE,    
    tempFact_sel => TFS, 
    output_en    => OE,   
    n_ge_1       => NGEO,
    output       => output
  );

  FSM: FactCtrl
  port map(
    clk          => clk,
    rst     => rst,
    go           => go,
    regN_en      => RNE,    
    regN_sel     => RNS,  
    tempFact_en  => TFE,    
    tempFact_sel => TFS, 
    output_en    => OE,   
    n_ge_1       => NGEO, 
    done         => done
  );

end FSM_D1;