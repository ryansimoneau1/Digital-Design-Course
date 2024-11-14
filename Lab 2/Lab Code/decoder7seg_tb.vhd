library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity decoder7seg_tb is
end decoder7seg_tb;

architecture behavioral of decoder7seg_tb is

-- Component Declaration
component decoder7seg
port(
    input  : in std_logic_vector;
    output : out std_logic_vector
);
end component;

-- Stimulus Signals
signal inputTest   : std_logic_vector(3 downto 0);
signal outputTest  : std_logic_vector(0 to 6);

begin -- TB
-- Unit Under Test Port Map
UUT: entity work.decoder7seg
    port map(
        input  => inputTest,
        output => outputTest

    );
    -- Testing Proceedure
    testing: process
    begin
        inputTest <= "0000";
        wait for 10 ns;
        inputTest <= "0001";
        wait for 10 ns;
        inputTest <= "0010";
        wait for 10 ns;
        inputTest <= "0011";
        wait for 10 ns;
        inputTest <= "0100";
        wait for 10 ns;
        inputTest <= "0101";
        wait for 10 ns;
        inputTest <= "0110";
        wait for 10 ns;
        inputTest <= "0111";
        wait for 10 ns;
        inputTest <= "1000";
        wait for 10 ns;
        inputTest <= "1001";
        wait for 10 ns;
        inputTest <= "1010";
        wait for 10 ns;
        inputTest <= "1011";
        wait for 10 ns;
        inputTest <= "1100";
        wait for 10 ns;
        inputTest <= "1101";
        wait for 10 ns;
        inputTest <= "1110";
        wait for 10 ns;
        inputTest <= "1111";
        wait for 10 ns;
    end process;
end behavioral;




--     -- virtual inputs
--     signal input0 : std_logic;
--     signal input1 : std_logic;
--     signal input2 : std_logic;
--     signal input3 : std_logic;
--     signal input  : std_logic_vector(3 downto 0);

--     -- virtual outputs
--     signal output0 : std_logic;
--     signal output1 : std_logic;
--     signal output2 : std_logic;
--     signal output3 : std_logic;
--     signal output4 : std_logic;
--     signal output5 : std_logic;
--     signal output6 : std_logic;
--     signal output  : std_logic_vector(0 to 6);

-- begin -- TB

--     UUT: entity work.decoder7seg
--         port map(
--             input0 => input0,
--             input1 => input1,
--             input2 => input2,
--             input3 => input3,

--             output0 => output0,
--             output1 => output1,
--             output2 => output2,
--             output3 => output3,
--             output4 => output4,
--             output5 => output5,
--             output6 => output6
--         );

--     input0 <= input(0);
--     input1 <= input(1);
--     input2 <= input(2);
--     input3 <= input(3);

--     output0 <= output(0);
--     output1 <= output(1);
--     output2 <= output(2);
--     output3 <= output(3);
--     output4 <= output(4);
--     output5 <= output(5);
--     output6 <= output(6);

--     input   <= input3&input2&input1&input0;
--     output  <= output0&output1&output2&output3&output4&output5&output6;