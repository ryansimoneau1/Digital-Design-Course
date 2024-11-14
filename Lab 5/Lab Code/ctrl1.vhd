library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity ctrl1 is
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
end ctrl1;

architecture BHV of ctrl1 is
type STATE_TYPE is (START, HOLT, INIT, FACTORIAL, CLOSE);
signal state, next_state: STATE_TYPE;


begin 
  Process(clk,rst)
  begin
    if(rst = '1') then
      state <= START;
    elsif(rising_edge(clk)) then
      state <= next_state;
    end if;
  end process;

  process(go, state, n_ge_1)
  begin
    next_state <= STATE;
    regN_sel     <= '0';
    tempFact_sel <= '1';
    regN_en      <= '0';
    tempFact_en  <= '0';
    output_en    <= '0';
    done         <= '0';
    case state is

      when START     =>
      if(go = '1') then
        next_state <= INIT;
      else
        next_state <= START;
      end if;

      when HOLT      =>
      if(go = '1') then
        next_state <= INIT;
        done <= '0';
      else
        next_state <= HOLT;
      end if;

      when INIT      =>
      regN_en      <= '1';
      tempFact_en  <= '1';
      next_state <= FACTORIAL;

      when FACTORIAL =>
      if(n_ge_1 = '1') then
        tempFact_sel <= '0'; -- product of 1 and n should already be the output of multiplier, so switch over to the result of the multiplier
        regN_sel     <= '1';
        regN_en      <= '1';
        tempFact_en  <= '1';
      else
        next_state <= CLOSE;
      end if;

      when CLOSE      =>
      output_en <= '1';
      done      <= '1';
      if(go = '0') then
        next_state <= HOLT;
      else
        next_state <= CLOSE;
      end if;

      when others    => null;
    end case;
  end process;
end BHV;
