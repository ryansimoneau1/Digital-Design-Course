library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity uPTop_tb is
end uPTop_tb;

architecture TB of uPTop_tb is

	constant width : positive := 32;
	
	signal clk				: std_logic := '1';
	signal rst				: std_logic := '0';
	signal Switchest	 	: std_logic_vector(9 downto 0) := (others => '0');
	signal TactileSwitcht	: std_logic := '0';
	signal SSDLEDst			: std_logic_vector(width-1 downto 0) := (others => '0');
	--signal done 	: std_logic := '0';
	
	component uPTopLevel
	generic(WIDTH: positive := 32);
    port(
		clk             : in std_logic;
        rst             : in std_logic;

        Switches        : in std_logic_vector(9 downto 0);
        TactileSwitch   : in std_logic;
        SSDLEDs         : out std_logic_vector(WIDTH - 1 downto 0)
	);
	end component;

begin
	
	UUT : uPTopLevel
	generic map (WIDTH => WIDTH)
	port map (
		clk				=> clk,
		rst				=> rst,
		Switches		=> Switchest,
		TactileSwitch	=> TactileSwitcht,
		SSDLEDs			=> SSDLEDst
	);
			
	--clk <= NOT clk AND NOT done after 20 ns;
	--done <= '1' after 500000000 ns;
	clk <= NOT clk after 5 ps;
	
	process
	
	begin
		
		-- wait for 10 ps;
		--done <= '0';
		Switchest		<= (others => '0');
		TactileSwitcht	<= '1'; --low true
		rst				<= '1'; --give all registers a value of 0 rather than undefined
		wait until rising_edge(clk);
		
        rst <= '0';
        wait until rising_edge(clk);
        wait until rising_edge(clk);
        wait until rising_edge(clk);
        wait until rising_edge(clk);
        wait until rising_edge(clk);
        wait until rising_edge(clk);
        wait until rising_edge(clk);
        wait until rising_edge(clk);
        wait until rising_edge(clk);
        wait until rising_edge(clk);
        wait until rising_edge(clk);
        wait until rising_edge(clk);
        wait until rising_edge(clk);
        wait until rising_edge(clk);
        wait until rising_edge(clk);
        wait until rising_edge(clk);
        wait until rising_edge(clk);
        wait until rising_edge(clk);
		


		
		--report "DONE!";
		--done <= '1';
		wait;
		
	end process;
	
end TB;
		
	