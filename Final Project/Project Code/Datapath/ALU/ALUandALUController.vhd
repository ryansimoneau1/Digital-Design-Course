library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity ALUandALUController is
    generic(WIDTH: positive := 32);
    port(
    -- ALU Inputs
    in1AAC, in2AAC  : in  std_logic_vector((WIDTH) - 1 downto 0);
    immValAAC       : in  std_logic_vector          (4 downto 0);

    -- ALUController Inputs 
    ALUOpAAC              : in std_logic_vector(3 downto 0);
    IRFunctionFieldAAC    : in std_logic_vector(5 downto 0);

    -- Module Outputs
    ResultAAC               : out std_logic_vector((WIDTH) - 1 downto 0);
    HIAAC                   : out std_logic_vector((WIDTH) - 1 downto 0);
    ALURegMuxSel            : out std_logic_vector(1 downto 0);
    BranchAAC               : out std_logic;
    HIEnable, LOEnable      : out std_logic
    );
end ALUandALUController;

architecture structural of ALUandALUController is

    signal OPSelect             : std_logic_vector(4 downto 0);

    component ALUAIO is
    generic(WIDTH: positive := 32);
    port(
        in1, in2: in  std_logic_vector((WIDTH) - 1 downto 0);
        Sel     : in  std_logic_vector          (4 downto 0);
        immVal  : in  std_logic_vector          (4 downto 0); -- is actually the shift ammount
        Result  : out std_logic_vector((WIDTH) - 1 downto 0);
        HI      : out std_logic_vector((WIDTH) - 1 downto 0);
        Branch  : out std_logic
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

begin

    ALUMod: ALUAIO
    generic map(WIDTH => WIDTH)
    port map(
        in1     => in1AAC,
        in2     => in2AAC,
        sel     => OPSelect,
        immVal  => immValAAC,
        Result  => ResultAAC,
        HI      => HIAAC,
        Branch  => BranchAAC
    );

    ALUCont: ALUController
    generic map(WIDTH => WIDTH)
    port map(
        ALUOpAC             => ALUOpAAC,
        IRFunctionFieldAC   => IRFunctionFieldAAC,
        HI_EnAC             => HIEnable,
        LO_EnAC             => LOEnable,
        ALU_LO_HIAC         => ALURegMuxSel,
        OPSelectAC          => OPSelect
    );
end structural;