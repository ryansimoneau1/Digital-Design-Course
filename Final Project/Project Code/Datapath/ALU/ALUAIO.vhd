library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity ALUAIO is
  generic(
    WIDTH         :   positive := 32);
  port(
    in1, in2: in  std_logic_vector((WIDTH) - 1 downto 0);
    Sel     : in  std_logic_vector          (4 downto 0);
    immVal  : in  std_logic_vector          (4 downto 0); -- is actually the shift ammount
    Result  : out std_logic_vector((WIDTH) - 1 downto 0);
    HI      : out std_logic_vector((WIDTH) - 1 downto 0);
    Branch  : out std_logic
  );
end ALUAIO;

architecture behavioral of ALUAIO is
begin
  Process(in1, in2, immVal, sel)
  variable tempmult  : signed  (2*WIDTH - 1 downto 0);
  variable tempmultu : unsigned(2*WIDTH - 1 downto 0);
  -- This corresponds to OPSelect coming from the ALU Controller
  -- R - Type instructions
  constant Lsll  : std_logic_vector(4 downto 0) := "00000"; -- shift left logical
  constant Lsrl  : std_logic_vector(4 downto 0) := "00001"; -- shift right logical
  constant Asra  : std_logic_vector(4 downto 0) := "00010"; -- shift right arithmetic
  constant mult  : std_logic_vector(4 downto 0) := "00011"; -- multiplication
  constant multu : std_logic_vector(4 downto 0) := "00100"; -- multiplication unsigned
  constant addu  : std_logic_vector(4 downto 0) := "00101"; -- addition (unsigned)
  constant subu  : std_logic_vector(4 downto 0) := "00110"; -- subtraction (unsigned)
  constant Land  : std_logic_vector(4 downto 0) := "00111"; -- logical and
  constant Lor   : std_logic_vector(4 downto 0) := "01000"; -- logical or
  constant Lxor  : std_logic_vector(4 downto 0) := "01001"; -- logical exclusive or
  constant slt   : std_logic_vector(4 downto 0) := "01010"; -- set on less than (signed)
  constant sltu  : std_logic_vector(4 downto 0) := "01011"; -- set on less than (unsigned)


   -- branch instructions (placeholder codes for now)
  constant beq   : std_logic_vector(4 downto 0) := "01100"; -- branch when equal
  constant bne   : std_logic_vector(4 downto 0) := "01101"; -- branch when not equal
  constant blez  : std_logic_vector(4 downto 0) := "01110"; -- branch when less than or equal to zero
  constant bgtz  : std_logic_vector(4 downto 0) := "01111"; -- branch when greater than zero
  constant bltz  : std_logic_vector(4 downto 0) := "10000"; -- branch when less than zero
  constant bgez  : std_logic_vector(4 downto 0) := "10001"; -- branch when greater than or equal to zero
  
  -- Other I - Type instructions
  constant andi  : std_logic_vector(4 downto 0) := "10010";
  constant ori   : std_logic_vector(4 downto 0) := "10011";
  constant xori  : std_logic_vector(4 downto 0) := "10100";
  constant addi  : std_logic_vector(4 downto 0) := "10101";
  constant subi  : std_logic_vector(4 downto 0) := "10110";
  constant slti  : std_logic_vector(4 downto 0) := "10111";
  constant sltiu : std_logic_vector(4 downto 0) := "11000";
  constant lw    : std_logic_vector(4 downto 0) := "11001";
  constant sw    : std_logic_vector(4 downto 0) := "11010";
  constant jr    : std_logic_vector(4 downto 0) := "11011"; -- Jump to Register

  begin
    case sel is -- code results in branch latch and HI latches

      when addu  =>
        Result     <= std_logic_vector(unsigned(in1) + unsigned(in2));
        Hi         <= (others => '0');
        Branch     <= '0';

      when subu  =>
        Result     <= std_logic_vector(unsigned(in1) - unsigned(in2));
        Hi         <= (others => '0');
        Branch     <= '0';

      when mult  =>
        Tempmult   := signed(in1) * signed(in2); 
        Result     <= std_logic_vector(Tempmult(WIDTH - 1 downto 0));
        HI         <= std_logic_vector(Tempmult(2*WIDTH - 1 downto WIDTH));
        Branch     <= '0';

      when multu =>
        Tempmultu  := unsigned(in1) * unsigned(in2); 
        Result     <= std_logic_vector(Tempmultu(WIDTH - 1 downto 0));
        HI         <= std_logic_vector(Tempmultu(2*WIDTH - 1 downto WIDTH));
        Branch     <= '0';

      when Land  =>
        Result     <= in1 and in2;
        Hi         <= (others => '0');
        Branch     <= '0';

      when Lor   =>
        Result     <= in1 or in2;
        Hi         <= (others => '0');
        Branch     <= '0';

      when Lxor  =>
        Result     <= in1 xor in2;
        Hi         <= (others => '0');
        Branch     <= '0';
      
      when slt   =>
        if(signed(in1) < signed(in2)) then
          Result    <= (others => '0');
          Result(0) <= '1';
          Hi        <= (others => '0');
          Branch    <= '0';
        else
          Result    <= (others => '0');
          Hi        <= (others => '0');
          Branch    <= '0';
          end if;
        
      when sltu  =>
        if(unsigned(in1) < unsigned(in2)) then
          Result    <= (others => '0');
          Result(0) <= '1';
          Hi        <= (others => '0');
          Branch    <= '0';
        else
          Result    <= (others => '0');
          Hi        <= (others => '0');
          Branch    <= '0';
          end if;

      when Lsll  =>
        Result    <= std_logic_vector(shift_left(unsigned(in1), natural(to_integer(unsigned(immVal)))));
        Hi        <= (others => '0');
        Branch    <= '0';

      when Lsrl  =>
        Result    <= std_logic_vector(shift_right(unsigned(in1), natural(to_integer(unsigned(immVal)))));
        Hi        <= (others => '0');
        Branch    <= '0';

      when Asra  =>
        Result    <= std_logic_vector(shift_right(signed(in1), natural(to_integer(unsigned(immVal)))));
        Hi        <= (others => '0');
        Branch    <= '0';

      when beq   =>  -- are the branch instructions signed?
      if(signed(in1) = signed(in2)) then
        Result <= (others => '0');
        Hi     <= (others => '0');
        Branch <= '1';
      else
        Result <= (others => '0');
        Hi     <= (others => '0');
        Branch <= '0';
        end if;

      when bne   =>
      if(signed(in1) /= signed(in2)) then
        Result <= (others => '0');
        Hi     <= (others => '0');
        Branch <= '1';
      else
        Result <= (others => '0');
        Hi     <= (others => '0');
        Branch <= '0';
        end if;

      when blez  =>
      if(signed(in1) <= 0) then
        Result <= (others => '0');
        Hi     <= (others => '0');
        Branch <= '1';
      else
        Result <= (others => '0');
        Hi     <= (others => '0');
        Branch <= '0';
        end if;

      when bgtz  =>
      if(signed(in1) > 0) then
        Result <= (others => '0');
        Hi     <= (others => '0');
        Branch <= '1';
      else
        Result <= (others => '0');
        Hi     <= (others => '0');
        Branch <= '0';
        end if;

      when bltz  =>
      if(signed(in1) < 0) then
        Result <= (others => '0');
        Hi     <= (others => '0');
        Branch <= '1';
      else
        Result <= (others => '0');
        Hi     <= (others => '0');
        Branch <= '0';
        end if;

      when bgez  =>
      if(signed(in1) >= 0) then
        Result <= (others => '0');
        Hi     <= (others => '0');
        Branch <= '1';
      else
        Result <= (others => '0');
        Hi     <= (others => '0');
        Branch <= '0';
        end if;

      when jr     =>
        Result  <= in1;
        Hi     <= (others => '0');
        Branch <= '0';

      when others =>
        Result <= (others => '0');
        Hi     <= (others => '0');
        Branch <= '0';
    end case;
  end process;
end behavioral;