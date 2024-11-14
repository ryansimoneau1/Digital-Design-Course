library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity uPTopLevel is
    generic(WIDTH: positive := 32);
    port(
        clk             : in std_logic;
        rst             : in std_logic;

        Switches        : in std_logic_vector(9 downto 0);
        TactileSwitch   : in std_logic;
        SSDLEDs         : out std_logic_vector(WIDTH - 1 downto 0)
    );
    end uPTopLevel;

architecture structural of uPTopLevel is

    signal IorDT           :  std_logic;
    signal MemWriteT       :  std_logic;
    signal MemtoRegT       :  std_logic;
    signal IRWriteT        :  std_logic; 
    signal JumpAndLinkT    :  std_logic;
    signal IsSignedT       :  std_logic;
    signal PCSourceT       :  std_logic_vector(1 downto 0);
    signal ALUSrcBT        :  std_logic_vector(1 downto 0);
    signal ALUSrcAT        :  std_logic;
    signal RegWriteT       :  std_logic;
    signal RegDstT         :  std_logic;
    signal PCRegEnT        :  std_logic;

        -- ALU Control Signals
    signal HI_EnT              :  std_logic;
    signal LO_EnT              :  std_logic;
    signal ALU_LO_HIT          :  std_logic_vector(1 downto 0);
    signal OPSelectT           :  std_logic_vector(4 downto 0);
    signal IRFunctionFieldT    :  std_logic_vector(5 downto 0);

        -- DataPath to Controller Ports
    signal BranchTakenT    :  std_logic;
    signal OpCodeT         :  std_logic_vector(WIDTH - 1 downto 0);

    signal ALUOpT          :  std_logic_vector(3 downto 0);

    signal PCWriteCondT: std_logic;
    signal PCWriteT    : std_logic;

    component uPDatapath is
    generic(WIDTH: positive := 32);
    port(
    -- Control Signals
        IorDD           : in std_logic;
        MemWriteD       : in std_logic;
        MemtoRegD       : in std_logic;
        IRWriteD        : in std_logic; 
        JumpAndLinkD    : in std_logic;
        IsSignedD       : in std_logic;
        PCSourceD       : in std_logic_vector(1 downto 0);
        ALUSrcBD        : in std_logic_vector(1 downto 0);
        ALUSrcAD        : in std_logic;
        RegWriteD       : in std_logic;
        RegDstD         : in std_logic;
        PCRegEnD        : in std_logic;

        -- ALU Control Signals
        HI_EnD              : in std_logic;
        LO_EnD              : in std_logic;
        ALU_LO_HID          : in std_logic_vector(1 downto 0);
        OPSelectD           : in std_logic_vector(4 downto 0);
        IRFunctionFieldD    : out std_logic_vector(5 downto 0);

        -- DataPath to Controller Ports
        BranchTakenD    : out std_logic;
        OpCodeD         : out std_logic_vector(WIDTH - 1 downto 0);

        -- Inteface ports
        clk             : in std_logic;
        rst             : in std_logic;
        Switches        : in std_logic_vector(9 downto 0);
        TactileSwitch   : in std_logic;
        SSDLEDs         : out std_logic_vector(WIDTH - 1 downto 0)
    );
    end component;

    component ALUController is
    generic(WIDTH: positive := 32);
    port(
        ALUOpAC              : in std_logic_vector(3 downto 0);
        IRFunctionFieldAC    : in std_logic_vector(5 downto 0);
        HI_EnAC              : out std_logic;
        LO_EnAC              : out std_logic;
        ALU_LO_HIAC          : out std_logic_vector(1 downto 0);
        OPSelectAC           : out std_logic_vector(4 downto 0)
    );
    end component;

    component uPController is
    generic(WIDTH: positive := 32);
    port(
        clk             : in std_logic;
        rst             : in std_logic;

        -- Datapath Control Signals
        IorDC           : out std_logic;
        MemWriteC       : out std_logic;
        MemtoRegC       : out std_logic;
        IRWriteC        : out std_logic;
        JumpAndLinkC    : out std_logic;
        IsSignedC       : out std_logic;
        PCSourceC       : out std_logic_vector(1 downto 0);
        ALUSrcBC        : out std_logic_vector(1 downto 0);
        ALUSrcAC        : out std_logic;
        RegWriteC       : out std_logic;
        RegDstC         : out std_logic;
        PCWriteCondC    : out std_logic;
        PCWriteC        : out std_logic;

        -- ALU Controller control Signals
        ALUOpC          : out std_logic_vector(3 downto 0);

        -- DataPath to Controller Ports
        OpCodeC         : in std_logic_vector(WIDTH - 1 downto 0)
    );
    end component;

begin

    PCRegEnT <= PCWriteT OR (PCWriteCondT AND BranchTakenT);

    Control: uPController
    generic map(WIDTH => WIDTH)
    port map(
        clk             => clk          ,
        rst             => rst          ,
        IorDC           => IorDT        ,
        MemWriteC       => MemWriteT    ,
        MemtoRegC       => MemtoRegT    ,
        IRWriteC        => IRWriteT     ,
        JumpAndLinkC    => JumpAndLinkT ,
        IsSignedC       => IsSignedT    ,
        PCSourceC       => PCSourceT    ,
        ALUSrcBC        => ALUSrcBT     ,
        ALUSrcAC        => ALUSrcAT     ,
        RegWriteC       => RegWriteT    ,
        RegDstC         => RegDstT      ,
        PCWriteCondC    => PCWriteCondT ,
        PCWriteC        => PCWriteT,
        ALUOpC          => ALUOpT,
        OpCodeC         => OpCodeT
    );

    ALUControl: ALUController
    generic map(WIDTH => WIDTH)
    port map(
        ALUOpAC             => ALUOpT,
        IRFunctionFieldAC   => IRFunctionFieldT,
        HI_EnAC             => HI_EnT,
        LO_EnAC             => LO_EnT,
        ALU_LO_HIAC         => ALU_LO_HIT,
        OPSelectAC          => OPSelectT
    );

    DataPath:uPDataPath
    generic map(WIDTH => WIDTH)
    port map(
        IorDD               => IorDT        ,
        MemWriteD           => MemWriteT    ,
        MemtoRegD           => MemtoRegT    ,
        IRWriteD            => IRWriteT     ,
        JumpAndLinkD        => JumpAndLinkT ,
        IsSignedD           => IsSignedT    ,
        PCSourceD           => PCSourceT    ,
        ALUSrcBD            => ALUSrcBT     ,
        ALUSrcAD            => ALUSrcAT     ,
        RegWriteD           => RegWriteT    ,
        RegDstD             => RegDstT      ,
        PCRegEnD            => PCRegEnT,
        IRFunctionFieldD    => IRFunctionFieldT,
        HI_EnD              => HI_EnT,
        LO_EnD              => LO_EnT,
        ALU_LO_HID          => ALU_LO_HIT,
        OPSelectD           => OPSelectT,
        BranchTakenD        => BranchTakenT,
        OpCodeD             => OpCodeT,
        clk                 => clk,
        rst             => rst          ,
        Switches            => Switches,
        TactileSwitch       => TactileSwitch,
        SSDLEDs             => SSDLEDs
    );
end structural;
