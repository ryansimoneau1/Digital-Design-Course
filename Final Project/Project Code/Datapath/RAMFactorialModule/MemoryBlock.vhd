library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity MemoryBlock is
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
        RdData        : out std_logic_vector(WIDTH - 1 downto 0));
    end MemoryBlock;

architecture structural of MemoryBlock is
    -- Defined intermediate signals
    signal SwitchDataLarge, Inport0RegOut, Inport1RegOut, RdRamData: std_logic_vector(WIDTH - 1 downto 0);
    signal DecodeOut, Selin: std_logic_vector(2 downto 0);
    signal Inport0Enable, Inport1Enable, RamWrEnable, OutportWrEnable: std_logic;

    -- component definition 
    component multiplexer7x1
    generic(WIDTH: positive := 32);
    port(
        D, G                : in std_logic;
        A, B, C, E, F       : in std_logic_vector(WIDTH - 1 downto 0);
        sel                 : in std_logic_vector(2 downto 0);
        output              : out std_logic_vector(WIDTH - 1 downto 0)
    );
    end component;

    component MemDecodeLogic
    port(
        addr         : in  std_logic_vector(31 downto 0);
        wren         : in  std_logic;
        rddata_sel   : out std_logic_vector(2 downto 0); -- 7 possible choices, so 3 select bits to accomodate
        sram_wren    : out std_logic;
        outport_wren : out std_logic;
        NWrEn        : out std_logic;
        GoWrEnNW     : out std_logic
    );
    end component;

    component IOEnable
    generic(WIDTH: positive := 32);
    port(
        DIPData   : in std_logic_vector(WIDTH - 1 downto 0);
        Button    : in std_logic;
        Inport0En : out std_logic;
        Inport1En : out std_logic
    );
    end component;

    component RAM
	port(
		address : in std_logic_vector(7 downto 0);
		clock	: in std_logic  := '1';
		data	: in std_logic_vector(31 downto 0);
		wren	: in std_logic;
		q		: out std_logic_vector(31 downto 0)
    );
    end component; 

    component ZeroExtend
    generic(WIDTH  : positive := 32);
    port(
        Input : in  std_logic_vector(9 downto 0);
        Output: out std_logic_vector((WIDTH - 1) downto 0)
    );
    end component;

    component registers
    generic(WIDTH : positive := 32);
    port(
        input  : in std_logic_vector(WIDTH - 1 downto 0);
        clk    : in std_logic;
        rst             : in std_logic;
        enable : in std_logic;
        output : out std_logic_vector(WIDTH - 1 downto 0)
    );
    end component;

    component registers2
    generic(WIDTH : positive := 3);
    port(
        input  : in std_logic_vector(WIDTH - 1 downto 0);
        clk    : in std_logic;
        rst             : in std_logic;
        enable : in std_logic;
        output : out std_logic_vector(WIDTH - 1 downto 0)
    );
    end component;

begin

    DataMux: multiplexer7x1
    generic map (WIDTH => WIDTH)
    port map (
        A               => RdRamData,
        B               => Inport0RegOut,
        C               => Inport1RegOut,
        D               => GoRegin,
        E               => NRegin,
        F               => ResultRegin,
        G               => DoneRegin,
        sel             => Selin,
        output          => rdData
    );
    
    DecodeLogic: MemDecodeLogic
    port map(
        addr            => Addr,
        wren            => Wren,
        rddata_sel      => DecodeOut,
        sram_wren       => RamWrEnable,
        outport_wren    => OutportWrEnable,
        NWrEn           => NWrEnable,
        GoWrEnNW        => GoWrEnable
    );

    InportEnable: IOenable
    generic map (WIDTH => WIDTH)
    port map(
        DIPData         => SwitchDataLarge,
        Button          => ButtonSig,
        Inport0En       => Inport0Enable,
        Inport1En       => Inport1Enable
    );

    Memory: RAM
    port map(
        address         => Addr(9 downto 2),
        clock           => clk,  
        data            => WrData,
        wren            => RamWrEnable,
        q               => RdRamData
    );

    extend0: ZeroExtend
    generic map (WIDTH => WIDTH)
    port map(
        Input           => SwitchData,
        Output          => SwitchDataLarge
    );

    Inport0Reg: registers
    port map(
        input           => SwitchDataLarge,
        clk             => clk,
        rst     => '0',
        enable          => inport0Enable,
        output          => Inport0Regout
    );

    Inport1Reg: registers
    port map(
        input           => SwitchDataLarge,
        clk             => clk,
        rst     => '0',
        enable          => inport1Enable,
        output          => Inport1Regout
    );

    OutportReg: registers
    port map(
        input           => WrData,
        clk             => clk,
        rst     => '0',
        enable          => OutportWrEnable,
        output          => OutportData
    );

    SelReg: registers2
    port map(
        input           => DecodeOut,
        clk             => clk,
        rst     => '0',
        enable          => '1',
        output          => Selin
    );
end structural;