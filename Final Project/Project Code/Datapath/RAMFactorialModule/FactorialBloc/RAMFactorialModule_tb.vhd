library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity RAMFactorialModule_tb is
end RAMFactorialModule_tb;

architecture TB of RAMFactorialModule_tb is
        -- register locations
        constant IOPORT0: std_logic_vector(31 downto 0) := X"0000FFF8";
        constant INPORT1: std_logic_vector(31 downto 0) := X"0000FFFC";
        -- constant OUTPORT: std_logic_vector(31 downto 0) := X"00010000"; -- document says the same address as inport0, but that doesn't make any sense
        constant GO     : std_logic_vector(31 downto 0) := X"0000FFE8"; -- factorial 
        constant N      : std_logic_vector(31 downto 0) := X"0000FFEC"; -- factorial
        constant RESULT : std_logic_vector(31 downto 0) := X"0000FFF0"; -- factorial
        constant DONE   : std_logic_vector(31 downto 0) := X"0000FFE4"; -- factorial
    
        -- select values
        constant RAM    : std_logic_vector(2 downto 0) := "000";
        constant PORT0  : std_logic_vector(2 downto 0) := "001";
        constant PORT1  : std_logic_vector(2 downto 0) := "010";
        constant G0     : std_logic_vector(2 downto 0) := "011";
        constant Nn     : std_logic_vector(2 downto 0) := "100";
        constant RSLT   : std_logic_vector(2 downto 0) := "101";
        constant DNE    : std_logic_vector(2 downto 0) := "110";

    constant WIDTH   : positive := 32;

    component RAMFactorialModule
    generic(WIDTH : positive := 32);
    port (
    clk                      : in std_logic;
    FactGoin                 : in std_logic;
    FactNin                  : in std_logic_vector(WIDTH - 1 downto 0);
    MemWren                  : in std_logic;
    MemButtonSig             : in std_logic;
    MemAddr                  : in std_logic_vector(WIDTH - 1 downto 0);
    MemWrData                : in std_logic_vector(WIDTH - 1 downto 0);
    MemSwitchData            : in std_logic_vector(9 downto 0);
    MemRdData                : out std_logic_vector(WIDTH - 1 downto 0);
    LEDout                   : out std_logic_vector(WIDTH - 1 downto 0)
    
    );
    end component;

    signal clkEn  : std_logic := '1';
    signal clk: std_logic := '0'; 
    signal MemWrEnt, MemButtonSigt, FactGoint: std_logic;
    signal FactNint, MemAddrt, MemWrDatat, MemRdDatat, LEDoutt: std_logic_vector(WIDTH - 1 downto 0);
    signal MemSwitchDatat: std_logic_vector(9 downto 0);

    -- signal to track where the simulation is in the waveform window
    signal OperationCounter: std_logic_vector(7 downto 0);

begin

    UUT: RAMFactorialModule
    port map (
        clk             => clk,
        FactGoin        => FactGoint,
        FactNin         => FactNint,
        MemWren         => MemWrent,
        MemButtonSig    => MemButtonSigt,
        MemAddr         => MemAddrt,
        MemWrData       => MemWrDatat,
        MemSwitchData   => MemSwitchDatat,
        MemRdData       => MemRdDatat,
        LEDout          => LEDoutt
    );

    clk <= not clk and clkEn after 20 ns;

    process
    begin
        -- Write 0x0A0A0A0A to byte address 0x00000000
        OperationCounter <= x"01";

        MemWrDatat  <= x"0A0A0A0A";
        MemAddrt    <= x"00000000";
        MemWrEnt    <= '1';
        wait until clk'event and clk = '1';
        MemWrEnt    <= '0';

        -- Write 0xF0F0F0F0 to byte address 0x00000004
        OperationCounter <= x"02";

        MemWrDatat  <= x"F0F0F0F0";
        MemAddrt    <= x"00000004";
        MemWrEnt    <= '1';
        wait until clk'event and clk = '1';
        MemWrEnt    <= '0';

        -- Read from byte address 0x00000000 (should show 0x0A0A0A0A on read data output)
        OperationCounter <= x"03";

        MemAddrt    <= x"00000000";
        wait until clk'event and clk = '1';

        -- Read from byte address 0x00000001 (should show 0x0A0A0A0A on read data output)
        OperationCounter <= x"04";

        MemAddrt    <= x"00000001";
        wait until clk'event and clk = '1';

        -- Read from byte address 0x00000004 (should show 0xF0F0F0F0 on read data output)
        OperationCounter <= x"05";

        MemAddrt    <= x"00000004";
        wait until clk'event and clk = '1';

        -- Read from byte address 0x00000005 (should show 0xF0F0F0F0 on read data output)
        OperationCounter <= x"06";

        MemAddrt    <= x"00000005";
        wait until clk'event and clk = '1';

        -- Write 0x00001111 to the outport (should see value appear on outport)
        OperationCounter <= x"07";

        MemWrDatat  <= x"00001111";
        MemAddrt    <= IOPORT0;
        MemWrent    <= '1';
        wait until clk'event and clk = '1';
        MemWrent    <= '0';

        -- Load 0x00010000 into inport 0
        OperationCounter <= x"08";

        MemSwitchDatat   <= "0100000000"; -- requested value is too large?
        MemButtonSigt    <= '0';
        wait until clk'event and clk = '1';
        MemButtonSigt    <= '1';

        -- Load 0x00000001 into inport 1
        OperationCounter <= x"09";

        MemSwitchDatat   <= "1000000001";
        MemButtonSigt    <= '0';
        wait until clk'event and clk = '1';
        MemButtonSigt    <= '1';
        
        -- Read from inport 0 (should show 0x00010000 on read data output)
        OperationCounter <= x"0A";

        MemAddrt    <= IOPORT0;
        wait until clk'event and clk = '1';

        -- Read from inport 1 (should show 0x00000001 on read data output)
        OperationCounter <= x"0B";

        MemAddrt    <= INPORT1;
        wait until clk'event and clk = '1';

        -- Write 0x00000004 to the N reg
        OperationCounter <= x"0C";

        MemAddrt    <= N;
        FactNint    <= x"00000004";
        MemWrEnt    <= '1';
        wait until clk'event and clk = '1';
        MemWrEnt    <= '0';

        -- Read from the N reg (should show 0x00000004 on read data output)
        OperationCounter <= x"0D";

        MemAddrt    <= N;
        wait until clk'event and clk = '1';

        -- Write 0x00000001 to the GO reg
        OperationCounter <= x"0E";

        MemAddrt    <= GO;
        FactGoint   <= '1';
        MemWrEnt    <= '1';
        wait until clk'event and clk = '1';
        -- wait until clk'event and clk = '1';
        -- wait until clk'event and clk = '1';
        MemWrEnt    <= '0';

        -- Read from the GO reg (should show 0x00000001 on read data output)
        OperationCounter <= x"0F";

        MemAddrt    <= GO;
        wait until clk'event and clk = '1';

        -- Read from the DONE reg until DONE = ‘1’ (wait until read data output = 0x00000001)
        OperationCounter <= x"10";

        MemAddrt    <= DONE;
        for i in 0 to 10 loop
            wait until clk'event and clk = '1';
        end loop;  -- i

        -- Read from the RESULT reg (should show 0x00000018 on read data output)
        OperationCounter <= x"11";

        MemAddrt    <= RESULT;
        wait;

    end process;
end TB;


-- Waiting for multiple clock cycles

-- for i in 0 to 1 loop
--     wait until clk'event and clk = '1';
--   end loop;  -- i