library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity factorial is
  generic(
    WIDTH         :   positive := 16);
  port(
    clk     : in  std_logic;
    rst     : in  std_logic;
    n       : in  std_logic_vector(width-1 downto 0);
    go      : in  std_logic;
    done    : out std_logic;
    output  : out std_logic_vector(WIDTH-1 downto 0)

  );
end factorial;

-- architecture FSMD of factorial is
-- type STATE_TYPE is (START, HOLT, INIT, FACTORIAL, CLOSE);
-- signal state, next_state: STATE_TYPE;


-- begin 
--   Process(clk,rst)
--   begin
--     if(rst = '1') then
--       state <= START;
--       --done <= '0';
--       --output <= (others => '0');
--     elsif(rising_edge(clk)) then
--       state <= next_state;
--     end if;
--   end process;

--   process(state, go)
--   variable tempFact_out: unsigned(2*(WIDTH) - 1 downto 0);
--   variable tempFact_in: unsigned((WIDTH) - 1 downto 0);
--   variable regN: unsigned((WIDTH) - 1 downto 0);
--   begin
--     next_state <= STATE;
--     done <= '0';
--     case state is

--       when START     =>
--       if(go = '1') then
--         next_state <= INIT;
--       else 
--         next_state <= START;
--       end if;

--       when HOLT      =>
--       if(go = '1') then
--         next_state <= INIT;
--         done <= '0';
--       else 
--         next_state <= HOLT;
--       end if;

--       when INIT      =>
--       tempFact_out := to_unsigned(1, 2*WIDTH);
--       tempFact_in  := to_unsigned(1, WIDTH);
--       regN         := unsigned(n(WIDTH - 1 downto 0));
--       next_state   <= FACTORIAL;

--       when FACTORIAL =>

--         while(regN > 1) loop
--           tempFact_out := tempFact_in*regN;
--           tempFact_in  := tempFact_out(WIDTH - 1 downto 0);
--           regN         := regN - 1;
--         end loop;

--         next_state <= CLOSE;

--       when CLOSE      =>
--       done <= '1';
--         output <= std_logic_vector(tempFact_out(WIDTH - 1 downto 0));
--         if(go = '0') then
--           next_state <= HOLT;
--         end if;

--       when others    => null;
--     end case;
--   end process;
-- end FSMD;

architecture FSM_D1 of factorial is

-- Fill in with your code
signal RNS, RNE, TFS, TFE, OE, NGEO: std_logic;

component datapath1
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
end component;

component ctrl1
  port(
    clk           : in std_logic;
    rst           : in std_logic;
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
  DATA: datapath1
  generic map (
    WIDTH => WIDTH)
  port map(
    clk          => clk,
    rst          => rst, 
    n            => n,
    regN_en      => RNE,    
    regN_sel     => RNS,  
    tempFact_en  => TFE,    
    tempFact_sel => TFS, 
    output_en    => OE,   
    n_ge_1       => NGEO,
    output       => output
  );

  FSM: ctrl1
  port map(
    clk          => clk,
    rst          => rst, 
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