library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_arith.all;
use ieee.std_logic_unsigned.all;

entity alu_ns_tb is
end alu_ns_tb;

architecture TB of alu_ns_tb is

    component alu_ns

        generic (
            WIDTH : positive := 17
            );
        port (
            input1   : in  std_logic_vector(WIDTH-1 downto 0);
            input2   : in  std_logic_vector(WIDTH-1 downto 0);
            sel      : in  std_logic_vector(3 downto 0);
            output   : out std_logic_vector(WIDTH-1 downto 0);
            overflow : out std_logic
            );

    end component;

    constant WIDTH  : positive                           := 9;
    signal input1   : std_logic_vector(WIDTH-1 downto 0) := (others => '0');
    signal input2   : std_logic_vector(WIDTH-1 downto 0) := (others => '0');
    signal sel      : std_logic_vector(3 downto 0)       := (others => '0');
    signal output   : std_logic_vector(WIDTH-1 downto 0);
    signal overflow : std_logic;

begin  -- TB

    UUT : alu_ns
        generic map (WIDTH => WIDTH)
        port map (
            input1   => input1,
            input2   => input2,
            sel      => sel,
            output   => output,
            overflow => overflow);

    process
    begin

        -- test 2+6 (no overflow)
        sel    <= "0000";
        input1 <= conv_std_logic_vector(2, input1'length);
        input2 <= conv_std_logic_vector(6, input2'length);
        wait for 40 ns;

        -- test F + 2 (with overflow)
        sel    <= "0000";
        input1 <= conv_std_logic_vector(15, input1'length);
        input2 <= conv_std_logic_vector(2, input2'length);
        wait for 40 ns;

        -- test 5*6
        sel    <= "0010";
        input1 <= conv_std_logic_vector(5, input1'length);
        input2 <= conv_std_logic_vector(6, input2'length);
        wait for 40 ns;

        -- test 50*60
        sel    <= "0010";
        input1 <= conv_std_logic_vector(15, input1'length);
        input2 <= conv_std_logic_vector(15, input2'length);
        wait for 40 ns;

        -- test left shift
        sel    <= "1000";
        input1 <= conv_std_logic_vector(3, input1'length); --should become 3
        input2 <= conv_std_logic_vector(0,  input2'length);
        wait for 40 ns;

        -- test right shift
        sel    <= "1001";
        input1 <= conv_std_logic_vector(12, input1'length); -- should become 3
        input2 <= conv_std_logic_vector(0, input2'length);
        wait for 40 ns;
        
        -- test bit swap
        sel    <= "1010";
        input1 <= conv_std_logic_vector(0, input1'length);
        input2 <= conv_std_logic_vector(90977, input2'length);
        wait for 40 ns;

        -- test reverse
        sel    <= "1011";
        input1 <= conv_std_logic_vector(0, input1'length);
        input2 <= conv_std_logic_vector(7, input2'length);
        wait for 40 ns;

        -- test odd even flag
        sel    <= "1100";
        input1 <= conv_std_logic_vector(0, input1'length);
        input2 <= conv_std_logic_vector(0, input2'length);
        wait for 40 ns;

        -- test 2's comp
        sel    <= "1101";
        input1 <= conv_std_logic_vector(0, input1'length);
        input2 <= conv_std_logic_vector(15, input2'length);
        wait for 40 ns;

        -- test null 1
        sel    <= "1110";
        input1 <= conv_std_logic_vector(6, input1'length);
        input2 <= conv_std_logic_vector(14, input2'length);
        wait for 40 ns;

        -- test null 2
        sel    <= "1111";
        input1 <= conv_std_logic_vector(6, input1'length);
        input2 <= conv_std_logic_vector(14, input2'length);
        wait for 40 ns;
    
        wait;

    end process;



end TB;
