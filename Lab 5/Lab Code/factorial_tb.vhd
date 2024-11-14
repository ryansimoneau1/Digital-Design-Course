library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity factorial_tb is
end factorial_tb;

architecture TB of factorial_tb is

  constant WIDTH   : positive := 16;
  constant TIMEOUT : time     := 1 ms;

  signal clkEn  : std_logic := '1';
  signal clk    : std_logic := '0';
  signal rst    : std_logic := '1';
  signal go     : std_logic := '0';
  signal done   : std_logic;
  signal n      : std_logic_vector(WIDTH-1 downto 0) := (others => '0');
  signal output : std_logic_vector(WIDTH-1 downto 0);

begin

  UUT : entity work.factorial(FSM_D1) -- change desired architecture to test here
    generic map (
      WIDTH  => WIDTH)
    port map (
      clk    => clk,
      rst    => rst,
      go     => go,
      done   => done,
      n      => n,
      output => output);

  clk <= not clk and clkEn after 20 ns;

  process

    function factorial (n : integer)
      return std_logic_vector is

      variable tempfactorial : integer;
      variable regN : integer;
    begin

      regN := n;
      tempfactorial := 1;
      while (regN > 0) loop
        tempfactorial := tempfactorial * regN;
        regN := regN - 1;
      end loop;

      return std_logic_vector(to_unsigned(tempfactorial, WIDTH));

    end factorial;

  begin

    clkEn <= '1';
    rst   <= '1';
    go    <= '0';
    n     <= std_logic_vector(to_unsigned(0, WIDTH));
    wait for 10 ns;

    rst <= '0';
    for i in 0 to 1 loop
      wait until clk'event and clk = '1';
    end loop;  -- i
	

    if(WIDTH >= 32) then
    	for i in 1 to 12 loop
      		n <= std_logic_vector(to_unsigned(i, WIDTH));
      		go <= '1';
      	wait until done = '1' for TIMEOUT;

      	assert(output = factorial(i)) report "Incorrect factorialorial number for " & integer'image(i) &
                                     ": " & integer'image(to_integer(unsigned(output))) & " vs " &
                                            integer'image(to_integer(unsigned(factorial(i)))) severity warning;
      	go <= '0';
      	wait until clk'event and clk = '1';
    	end loop;
     else
    	for i in 1 to 8 loop
      		n <= std_logic_vector(to_unsigned(i, WIDTH));
      		go <= '1';
      	wait until done = '1' for TIMEOUT;

      	assert(output = factorial(i)) report "Incorrect factorialorial number for " & integer'image(i) &
                                     ": " & integer'image(to_integer(unsigned(output))) & " vs " &
                                            integer'image(to_integer(unsigned(factorial(i)))) severity warning;
      	go <= '0';
      	wait until clk'event and clk = '1';
    	end loop;


     end if;

    for i in 0 to 9 loop
      wait until clk'event and clk = '1';
    end loop;  -- i

    clkEn <= '0';
    report "DONE!!!!!!" severity note;

    wait;

  end process;

end TB;
