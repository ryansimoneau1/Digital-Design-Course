library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity RAMFactorialModule is
    generic(WIDTH : positive := 32);
    port (
    clk                      : in std_logic;
    rst                  : in std_logic;
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
end RAMFactorialModule;

architecture structural of RAMFactorialModule is
    -- Defined intermediate signals --
    -- Factorial Registers and Memory Module
    signal FactNWrEnable, FactGoWrEnable, FactGoRegQ, FactDoneRegQ: std_logic;
    signal FactNRegQ, FactResultRegQ                : std_logic_vector(WIDTH - 1 downto 0);
    -- Factorial Registers and Factorial Module
    signal FactDone: std_logic;
    signal FactResult: std_logic_vector(WIDTH - 1 downto 0);
     
    -- component definitions
    component FactorialModule
    generic(WIDTH: positive := 32);
    port(
        clk     : in  std_logic;
        rst             : in std_logic;
        n       : in  std_logic_vector(width-1 downto 0);
        go      : in  std_logic;
        done    : out std_logic;
        output  : out std_logic_vector(WIDTH-1 downto 0)
    );
    end component;

    component FactorialRegisters 
    generic(WIDTH: positive := 32);
    port(
        clk         : in std_logic;
        rst             : in std_logic;
        NEn         : in std_logic;
        GoEn        : in std_logic;
        Goin        : in std_logic;
        Donein      : in std_logic;
        Nin         : in std_logic_vector(WIDTH - 1 downto 0);
        Resultin    : in std_logic_vector(WIDTH - 1 downto 0);
        GoOut       : out std_logic;
        DoneOut     : out std_logic;
        NOut        : out std_logic_vector(WIDTH - 1 downto 0);
        ResultOut   : out std_logic_vector(WIDTH - 1 downto 0)
    );
    end component;

    component MemoryBlock
    generic(WIDTH: positive := 32);
    port(
        Addr          : in std_logic_vector(WIDTH - 1 downto 0);
        SwitchData    : in std_logic_vector(9 downto 0);
        WrData        : in std_logic_vector(WIDTH - 1 downto 0);
        Wren          : in std_logic;
        ButtonSig     : in std_logic;
        clk           : in std_logic;
        rst             : in std_logic;
        GoRegin       : in std_logic;
        DoneRegin     : in std_logic;
        NRegin        : in std_logic_vector(WIDTH - 1 downto 0);
        ResultRegin   : in std_logic_vector(WIDTH - 1 downto 0);
        GoWrEnable    : out std_logic;
        NWrEnable     : out std_logic;
        OutportData   : out std_logic_vector(WIDTH - 1 downto 0);
        RdData        : out std_logic_vector(WIDTH - 1 downto 0)
    );
    end component;

begin

    FactorialBloc: FactorialModule
    generic map(WIDTH => WIDTH)
    port map(
        clk         => clk,
        rst     => rst,
        n           => FactNRegQ,
        go          => FactGoRegQ,
        Done        => FactDone,
        output      => FactResult
    );

    FactorialRegisterBloc: FactorialRegisters
    generic map(WIDTH => WIDTH)
    port map(
        clk         => clk,
        rst     => rst,
        NEn         => FactNWrEnable,
        GoEn        => FactGoWrEnable,
        Goin        => FactGoin,
        Donein      => FactDone,
        Nin         => FactNin,
        Resultin    => FactResult,
        GoOut       => FactGoRegQ,
        DoneOut     => FactDoneRegQ,
        NOut        => FactNRegQ,
        ResultOut   => FactResultRegQ
    );

    MemoryBloc: MemoryBlock
    generic map(WIDTH => WIDTH)
    port map(
        Addr           => MemAddr,
        SwitchData     => MemSwitchData,
        WrData         => MemWrData,
        Wren           => MemWrEn,
        ButtonSig      => MemButtonSig,
        clk            => clk,
        rst     => rst,
        GoRegin        => FactGoRegQ,
        NRegin         => FactNRegQ,
        ResultRegin    => FactResultRegQ,
        DoneRegin      => FactDoneRegQ,
        GoWrEnable     => FactGoWrEnable,
        NWrEnable      => FactNWrEnable,
        OutportData    => LEDOut,
        RdData         => MemRdData
    );
end structural;