library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity ALUandALUController_tb is
end ALUandALUController_tb;

architecture TB of ALUandALUController_tb is

    constant WIDTH : positive := 32;

    --ALUOp Values
    constant ADD  : std_logic_vector(3 downto 0) := "0000";
    constant SUB  : std_logic_vector(3 downto 0) := "0001";
    constant FUN  : std_logic_vector(3 downto 0) := "0010";
    constant BEQ  : std_logic_vector(3 downto 0) := "0011";
    constant BNE  : std_logic_vector(3 downto 0) := "0100";
    constant BLEZ : std_logic_vector(3 downto 0) := "0101";
    constant BGTZ : std_logic_vector(3 downto 0) := "0110";
    constant BLTZ : std_logic_vector(3 downto 0) := "0111";
    constant BGEZ : std_logic_vector(3 downto 0) := "1000";

    -- ALUControl values (the ones that the ALU uses for the select input)
    -- R - Type instructions
    constant Lsll  : std_logic_vector(4 downto 0) := "00000"; -- shift left logical
    constant Lsrl  : std_logic_vector(4 downto 0) := "00001"; -- shift right logical
    constant Asra  : std_logic_vector(4 downto 0) := "00010"; -- shift right arithmetic
    constant mult  : std_logic_vector(4 downto 0) := "00011"; -- multiplication
    constant multu : std_logic_vector(4 downto 0) := "00100"; -- multiplication unsigned
    constant addu  : std_logic_vector(4 downto 0) := "00101"; -- addition (unsigned)
    constant subu  : std_logic_vector(4 downto 0) := "00110"; -- subtraction (unsigned)
    constant Land  : std_logic_vector(4 downto 0) := "00111"; -- logical and
    constant Lor   : std_logic_vector(4 downto 0) := "01000"; -- logical or
    constant Lxor  : std_logic_vector(4 downto 0) := "01001"; -- logical exclusive or
    constant slt   : std_logic_vector(4 downto 0) := "01010"; -- set on less than (signed)
    constant sltu  : std_logic_vector(4 downto 0) := "01011"; -- set on less than (unsigned)
    constant mfhi  : std_logic_vector(4 downto 0) := "01100"; -- moves data from high register and puts it in register file
    constant mflo  : std_logic_vector(4 downto 0) := "01101"; -- moves data from low register and puts it in register file
    constant FNull : std_logic_vector(4 downto 0) := "11111"; -- not a valid instruction for ALU

       -- branch instructions (placeholder codes for now)
    constant Abeq  : std_logic_vector(4 downto 0) := "01100"; -- branch when equal
    constant Abne  : std_logic_vector(4 downto 0) := "01101"; -- branch when not equal
    constant Ablez : std_logic_vector(4 downto 0) := "01110"; -- branch when less than or equal to zero
    constant Abgtz : std_logic_vector(4 downto 0) := "01111"; -- branch when greater than zero
    constant Abltz : std_logic_vector(4 downto 0) := "10000"; -- branch when less than zero
    constant Abgez : std_logic_vector(4 downto 0) := "10001"; -- branch when greater than or equal to zero

    -- IRFunctionField (the raw function field data used when ALUOpAc is FUN)
    constant LsllF  : std_logic_vector(5 downto 0) := "000000"; -- shift left logical
    constant LsrlF  : std_logic_vector(5 downto 0) := "000010"; -- shift right logical
    constant AsraF  : std_logic_vector(5 downto 0) := "000011"; -- shift right arithmetic
    constant mfhiF  : std_logic_vector(5 downto 0) := "010000"; -- moves data from high register and puts it in register file
    constant mfloF  : std_logic_vector(5 downto 0) := "010010"; -- moves data from low register and puts it in register file
    constant multF  : std_logic_vector(5 downto 0) := "011000"; -- multiplication
    constant multuF : std_logic_vector(5 downto 0) := "011001"; -- multiplication unsigned
    constant adduF  : std_logic_vector(5 downto 0) := "100001"; -- addition (unsigned)
    constant subuF  : std_logic_vector(5 downto 0) := "100011"; -- subtraction (unsigned)
    constant LandF  : std_logic_vector(5 downto 0) := "100100"; -- logical and
    constant LorF   : std_logic_vector(5 downto 0) := "100101"; -- logical or
    constant LxorF  : std_logic_vector(5 downto 0) := "100110"; -- logical exclusive or
    constant sltF   : std_logic_vector(5 downto 0) := "101010"; -- set on less than (signed)
    constant sltuF  : std_logic_vector(5 downto 0) := "101011"; -- set on less than (unsigned)

    component ALUandALUController
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
    end component;


    signal in1AACt, in2AACt        : std_logic_vector((WIDTH) - 1 downto 0);
    signal immValAACt              : std_logic_vector(4 downto 0);
    signal ALUOpAACt               : std_logic_vector(3 downto 0);
    signal IRFunctionFieldAACt     : std_logic_vector(5 downto 0);

    begin
        UUT: ALUandALUController
        port map(
            in1AAC              => in1AACt,
            in2AAC              => in2AACt,
            immValAAC           => immValAACt,
            ALUOpAAC            => ALUOpAACt,
            IRFunctionFieldAAC  => IRFunctionFieldAACt
        );

        process
        begin
        -- Testing R - Type instructions
        in1AACt     <= x"0000000A";
        in2AACt     <= x"0000000F";
        immValAACt  <= "00000";
        ALUOpAACt   <= FUN;
        IRFunctionFieldAACt <= adduF;

        wait for 50 ps;
        in1AACt     <= x"00000019";
        in2AACt     <= x"0000000A";
        immValAACt  <= "00000";
        ALUOpAACt   <= FUN;
        IRFunctionFieldAACt <= subuF;

        wait for 50 ps;
        in1AACt     <= X"0000000A";
        in2AACt     <= X"FFFFFFFC";
        immValAACt  <= "00000";
        ALUOpAACt   <= FUN;
        IRFunctionFieldAACt <= multF;

        wait for 50 ps;
        in1AACt     <= X"00010000";
        in2AACt     <= X"00020000";
        immValAACt  <= "00000";
        ALUOpAACt   <= FUN;
        IRFunctionFieldAACt <= multuF;

        wait for 50 ps;
        in1AACt     <= X"0000FFFF";
        in2AACt     <= X"FFFF1234";
        immValAACt  <= "00000";
        ALUOpAACt   <= FUN;
        IRFunctionFieldAACt <= LandF;

        wait for 50 ps;
        in1AACt     <= X"0000FFFF";
        in2AACt     <= X"FFFF1234";
        immValAACt  <= "00000";
        ALUOpAACt   <= FUN;
        IRFunctionFieldAACt <= LorF;

        wait for 50 ps;
        in1AACt     <= X"0000FFFF";
        in2AACt     <= X"FFFF1234";
        immValAACt  <= "00000";
        ALUOpAACt   <= FUN;
        IRFunctionFieldAACt <= LxorF;
        
        wait for 50 ps;
        in1AACt     <= X"0000000F";
        in2AACt     <= X"00000000";
        immValAACt  <= "00100";
        ALUOpAACt   <= FUN;
        IRFunctionFieldAACt <= LsrlF; 

        wait for 50 ps;
        in1AACt     <= X"F0000008";
        in2AACt     <= X"00000000";
        immValAACt  <= "00001";
        ALUOpAACt   <= FUN;
        IRFunctionFieldAACt <= AsraF; 

        wait for 50 ps;
        in1AACt     <= X"00000008";
        in2AACt     <= X"00000000";
        immValAACt  <= "00001";
        ALUOpAACt   <= FUN;
        IRFunctionFieldAACt <= AsraF; 

        wait for 50 ps;
        in1AACt     <= X"0000000A";
        in2AACt     <= X"0000000F";
        immValAACt  <= "00000";
        ALUOpAACt   <= FUN;
        IRFunctionFieldAACt <= sltuF; 

        wait for 50 ps;
        in1AACt     <= X"0000000F";
        in2AACt     <= X"0000000A";
        immValAACt  <= "00000";
        ALUOpAACt   <= FUN;
        IRFunctionFieldAACt <= sltuF; 

        wait for 50 ps;
        in1AACt     <= X"0000000A";
        in2AACt     <= X"0000000F";
        immValAACt  <= "00000";
        ALUOpAACt   <= FUN;
        IRFunctionFieldAACt <= mfhiF; 

        wait for 50 ps;
        in1AACt     <= X"0000000F";
        in2AACt     <= X"0000000A";
        immValAACt  <= "00000";
        ALUOpAACt   <= FUN;
        IRFunctionFieldAACt <= mfloF;

        -- I - Type Instructions
        wait for 50 ps;
        in1AACt     <= X"00000005";
        in2AACt     <= X"00000005";
        immValAACt  <= "00000";
        ALUOpAACt   <= BEQ;
        IRFunctionFieldAACt <= "000000";
        
        wait for 50 ps;
        in1AACt     <= X"00000005";
        in2AACt     <= X"00000000";
        immValAACt  <= "00000";
        ALUOpAACt   <= BNE;
        IRFunctionFieldAACt <= "000000";

        wait for 50 ps;
        in1AACt     <= X"80000005";
        in2AACt     <= X"00000000";
        immValAACt  <= "00000";
        ALUOpAACt   <= BLEZ;
        IRFunctionFieldAACt <= "000000";
        
        wait for 50 ps;
        in1AACt     <= X"00000005";
        in2AACt     <= X"00000000";
        immValAACt  <= "00000";
        ALUOpAACt   <= BGTZ;
        IRFunctionFieldAACt <= "000000";

        wait for 50 ps;
        in1AACt     <= X"00000005";
        in2AACt     <= X"00000000";
        immValAACt  <= "00000";
        ALUOpAACt   <= BLTZ;
        IRFunctionFieldAACt <= "000000";
        
        wait for 50 ps;
        in1AACt     <= X"00000005";
        in2AACt     <= X"00000000";
        immValAACt  <= "00000";
        ALUOpAACt   <= BGEZ;
        IRFunctionFieldAACt <= "000000";

        -- Generics for Operations that use ALU to change PC
        wait for 50 ps;
        in1AACt     <= X"00000005";
        in2AACt     <= X"00000001";
        immValAACt  <= "00000";
        ALUOpAACt   <= ADD;
        IRFunctionFieldAACt <= "000000";
        
        wait for 50 ps;
        in1AACt     <= X"00000005";
        in2AACt     <= X"00000001";
        immValAACt  <= "00000";
        ALUOpAACt   <= SUB;
        IRFunctionFieldAACt <= "000000";

        wait for 150 ps;
        end process;

    end TB;
