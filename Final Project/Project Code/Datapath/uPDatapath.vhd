library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity uPDatapath is
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
end uPDatapath;

architecture structural of uPDatapath is


    -- component definitions
    component DatMux2x1
    generic(WIDTH: positive :=  32);
    port(
        A, B    : in std_logic_vector(width - 1 downto 0);
        sel     : in std_logic;
        output  : out std_logic_vector(width - 1 downto 0)
    ); 
    end component;

    component DatMux2x15Bit
    port(
        A, B    : in std_logic_vector(4 downto 0);
        sel     : in std_logic;
        output  : out std_logic_vector(4 downto 0)
    ); 
    end component;

    component Registers
    generic(WIDTH : positive := 32);
    port(
      input                : in std_logic_vector(WIDTH - 1 downto 0);
      rst                  : in std_logic;
      clk                  : in std_logic;
      enable               : in std_logic;
      output               : out std_logic_vector(WIDTH - 1 downto 0)
    );
  end component;

  component DatMux3x1
  generic(WIDTH: positive := 32);
port(
    A, B, C    : in std_logic_vector(width - 1 downto 0);
    sel        : in std_logic_vector(1 downto 0);
    output  : out std_logic_vector(width - 1 downto 0)
); 
end component;

component DatMux4x1
generic(WIDTH: positive := 32);
port(
    A, B, C, D    : in std_logic_vector(width - 1 downto 0);
  sel        : in std_logic_vector(1 downto 0);
  output  : out std_logic_vector(width - 1 downto 0)
); 
end component;

component RAMFactorialModule
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
end component;

component ALUAIO
generic(WIDTH: positive := 32);
port(
in1, in2: in  std_logic_vector((WIDTH) - 1 downto 0);
Sel     : in  std_logic_vector          (4 downto 0);
immVal  : in  std_logic_vector          (4 downto 0);
Result  : out std_logic_vector((WIDTH) - 1 downto 0); -- should this be doubled in size (isn't the register so yes?)
HI      : out std_logic_vector((WIDTH) - 1 downto 0);
Branch  : out std_logic
);
end component;

component RegisterFile
generic(WIDTH: positive := 32);
port(
clk      : in std_logic;
rst      : in std_logic;
rd_addr0 : in std_logic_vector(4 downto 0);
rd_addr1 : in std_logic_vector(4 downto 0);
wr_addr  : in std_logic_vector(4 downto 0);
wr_en    : in std_logic;
JandL    : in std_logic;
wr_data  : in std_logic_vector (WIDTH - 1 downto 0);
rd_data0 : out std_logic_vector(WIDTH - 1 downto 0);
rd_data1 : out std_logic_vector(WIDTH - 1 downto 0)
);
end component;

component ShiftLeft26Bit
generic(WIDTH : positive := 26);
port(
    input: in std_logic_vector(WIDTH - 1 downto 0);
    output: out std_logic_vector(WIDTH + 1 downto 0)
);
end component;

component ShiftLeft32Bit
generic(WIDTH : positive := 32);
port(
    input: in std_logic_vector(WIDTH - 1 downto 0);
    output: out std_logic_vector(WIDTH - 1 downto 0)
);
end component;

component Concat28to32
port(
    input1: in std_logic_vector(27 downto 0);
    input2: in std_logic_vector(3 downto 0);
    output: out std_logic_vector(31 downto 0)
);
end component;

component SignExtend
generic(WIDTH: positive := 32);
port(
IsSigned: in std_logic;
Input   : in  std_logic_vector((WIDTH/2 - 1) downto 0);
Output  : out std_logic_vector((WIDTH - 1) downto 0)
);
end component;

-- Memory Module Signals (Red)
signal RegBout, MemoryModuleOut, MemoryModuleIn: std_logic_vector(WIDTH - 1 downto 0);

-- Instruction Register Signals (Orange)
signal IRSignal:   std_logic_vector(WIDTH - 1 downto 0);
signal IRtoConcat: std_logic_vector(25 downto 0);
-- signal IRtoController will be a top level entity signal
signal IRandReadReg1, IRandReadReg2, IRandRegDstMux: std_logic_vector(4 downto 0);
signal IRandSignExtend: std_logic_vector(15 downto 0);
signal IRandALU       : std_logic_vector(4 downto 0);

-- Register File Signals (Yellow)
signal ReadData1andRegA, ReadData2andRegB, MemToRegMuxandWriteData: std_logic_vector(WIDTH - 1 downto 0);
signal RegDstMuxandWriteReg: std_logic_vector(4 downto 0);

-- ALU Signals (Green)
signal ALUandALUSrcAMux, ALUandALUSrcBMux, ALUandHIReg, ALUandALUOutReg: std_logic_vector(WIDTH - 1 downto 0);

-- Additional Multiplexer Signals(Teal)
Signal IorDMuxandPC, IorDMuxandALUOutReg, MemToRegMuxandMemDataReg, MemToRegMuxandALU_LO_HIMux, 
       ALUsrcAMuxandRegAOut, ALUSrcBMuxandSingExtend, ALUSrcBMuxandShiftLeft, PCSrcMuxandConcat,
       PCSrcMuxandPC, ALU_LO_HIMuxandLOReg, ALU_LO_HIMuxandHIReg: std_logic_vector(WIDTH - 1 downto 0);

-- Concat Signal(Blue)
signal ShiftLeftandConcat: std_logic_vector(27 downto 0);
signal PCandConcat       : std_logic_vector(3 downto 0);

-- Program Counter
signal PCSignal: std_logic_vector(WIDTH - 1 downto 0);



begin

    -- 2x1 Multiplexers
    MemToRegMux: DatMux2x1
    generic map(WIDTH => WIDTH)
    port map(
        A       => MemToRegMuxandALU_LO_HIMux,
        B       => MemToRegMuxandMemDataReg,
        sel     => MemtoRegD,
        output  => MemToRegMuxandWriteData
    );
    RegDstMux: DatMux2x15Bit
    port map(
        A       => IRandReadReg2,
        B       => IRandRegDstMux,
        sel     => RegDstD,
        output  => RegDstMuxandWriteReg
    );
    ALUSrcAMux: DatMux2x1
    generic map(WIDTH => WIDTH)
    port map(
        A       => IorDMuxandPC,
        B       => ALUsrcAMuxandRegAOut,
        sel     => ALUSrcAD,
        output  => ALUandALUSrcAMux
    );
    IorDMux: DatMux2x1
    generic map(WIDTH => WIDTH)
    port map(
        A       => IorDMuxandPC,
        B       => IorDMuxandALUOutReg,
        sel     => IorDD,
        output  => MemoryModuleIn
    );

    -- 3x1 Multiplexers
    PCSrcMux: DatMux3x1
    generic map(WIDTH => WIDTH)
    port map(
        A       => ALUandALUOutReg,
        B       => IorDMuxandALUOutReg,
        C       => PCSrcMuxandConcat,
        sel     => PCSourceD,
        output  => PCSrcMuxandPC
    );
    ALU_LO_HIMux: DatMux3x1
    generic map(WIDTH => WIDTH)
    port map(
        A       => IorDMuxandALUOutReg,
        B       => ALU_LO_HIMuxandLOReg,
        C       => ALU_LO_HIMuxandHIReg,
        sel     => ALU_LO_HID,
        output  => MemToRegMuxandALU_LO_HIMux
    );

    -- 4x1 Multiplexers
    ALUSrcBMux: DatMux4x1
    generic map(WIDTH => WIDTH)
    port map(
        A       => RegBout,
        B       => x"00000004",
        C       => ALUSrcBMuxandSingExtend,
        D       => ALUSrcBMuxandShiftLeft,
        sel     => ALUSrcBD,
        output  => ALUandALUSrcBMux
    );

    -- 32-Bit Registers
    ProgramCounter: Registers
    generic map(WIDTH => WIDTH)
    port map(
        input   => PCSrcMuxandPC,
        rst     => rst,
        clk     => clk, 
        enable  => PCRegEnD,
        output  => PCSignal
    );
    IorDMuxandPC <= PCSignal;
    PCandConcat  <= PCSignal(31 downto 28);

    InstructionReg: Registers
    generic map(WIDTH => WIDTH)
    port map(
        input   => MemoryModuleOut,
        rst     => rst,
        clk     => clk, 
        enable  => IRwriteD,
        output  => IRSignal
    );
    IRtoConcat        <= IRSignal(25 downto 0);
    OpCodeD           <= IRSignal(31 downto 0);
    IRFunctionFieldD  <= IRSignal(5 downto 0);
    IRandReadReg1     <= IRSignal(25 downto 21);
    IRandReadReg2     <= IRSignal(20 downto 16);
    IRandRegDstMux    <= IRSignal(15 downto 11);
    IRandSignExtend   <= IRSignal(15 downto 0);
    IRandALU          <= IRSignal(10 downto 6);
    MemoryDatReg: Registers
    generic map(WIDTH => WIDTH)
    port map(
        input   => MemoryModuleOut,
        rst     => rst,
        clk     => clk, 
        enable  => '1',
        output  => MemToRegMuxandMemDataReg
    );
    RegA: Registers
    generic map(WIDTH => WIDTH)
    port map(
        input   => ReadData1andRegA,
        rst     => rst,
        clk     => clk, 
        enable  => '1',
        output  => ALUsrcAMuxandRegAOut
    );
    RegB: Registers
    generic map(WIDTH => WIDTH)
    port map(
        input   => ReadData2andRegB,
        rst     => rst,
        clk     => clk, 
        enable  => '1',
        output  => RegBout
    );
    ALUOutReg: Registers
    generic map(WIDTH => WIDTH)
    port map(
        input   => ALUandALUOutReg,
        rst     => rst,
        clk     => clk, 
        enable  => '1',
        output  => IorDMuxandALUOutReg
    );
    LOReg: Registers
    generic map(WIDTH => WIDTH)
    port map(
        input   => ALUandALUOutReg,
        rst     => rst,
        clk     => clk, 
        enable  => LO_EnD,
        output  => ALU_LO_HIMuxandLOReg
    );
    HIReg: Registers
    generic map(WIDTH => WIDTH)
    port map(
        input   => ALUandHIReg,
        rst     => rst,
        clk     => clk, 
        enable  => HI_EnD,
        output  => ALU_LO_HIMuxandHIReg
    );

    -- Register File
    RegisterArray: RegisterFile
    generic map(WIDTH => WIDTH)
    port map(
        clk         => clk,
        rst     => rst,
        rd_addr0    => IRandReadReg1,
        rd_addr1    => IRandReadReg2,
        wr_addr     => RegDstMuxandWriteReg, 
        wr_en       => RegWriteD,
        JandL       => JumpAndLinkD,
        wr_data     => MemToRegMuxandWriteData, 
        rd_data0    => ReadData1andRegA,
        rd_data1    => ReadData2andRegB
    );

    -- Memory/Factorial Module
    RAMFact: RAMFactorialModule
    generic map(WIDTH => WIDTH)
    port map(
        clk             => clk,
        rst     => rst,
        FactGoin        => '0',
        FactNin         => x"00000000",
        MemWrEn         => MemWriteD,
        MemButtonSig    => TactileSwitch,
        MemAddr         => MemoryModuleIn, 
        MemWrData       => RegBout,
        MemSwitchData   => Switches,
        MemRdData       => MemoryModuleOut,
        LEDOut          => SSDLEDs
    );

    -- Arithmetic and Logic Unit
    ArithemeticAndLogicUnit: ALUAIO
    generic map(WIDTH => WIDTH)
    port map(
        in1     => ALUandALUSrcAMux,
        in2     => ALUandALUSrcBMux,
        Sel     => OPSelectD,
        immVal  => IRandALU,
        Result  => ALUandALUOutReg,
        HI      => ALUandHIReg,
        Branch  => BranchTakenD
    );

    -- Left Shift Modules
    ConcatLeftShift: ShiftLeft26Bit
    generic map(WIDTH => 26)
    port map(
        input   => IRtoConcat,
        output  => ShiftLeftandConcat
    );
    RegBLeftShift: ShiftLeft32Bit
    generic map(WIDTH => WIDTH)
    port map(
        input   => ALUSrcBMuxandSingExtend,
        output  => ALUSrcBMuxandShiftLeft
    );

    -- Concatenation Module
    Concat: Concat28to32
    port map(
        input1  => ShiftLeftandConcat,
        input2  => PCandConcat,
        output  => PCSrcMuxandConcat
    );

    -- Sign Extend Module
    IRSignExtend: SignExtend
    generic map(WIDTH => WIDTH)
    port map(
        IsSigned    => IsSignedD,
        Input       => IRandSignExtend,
        Output      => ALUSrcBMuxandSingExtend
    );
end structural;



  
