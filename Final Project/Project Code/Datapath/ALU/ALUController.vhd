library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity ALUController is
    generic(WIDTH: positive := 32);
    port(
        ALUOpAC              : in std_logic_vector(3 downto 0);
        IRFunctionFieldAC    : in std_logic_vector(5 downto 0);
        HI_EnAC              : out std_logic;
        LO_EnAC              : out std_logic;
        ALU_LO_HIAC          : out std_logic_vector(1 downto 0);
        OPSelectAC           : out std_logic_vector(4 downto 0)
    );
end ALUController;

architecture behavioral of ALUController is
begin
    process(ALUOpAC, IRFunctionFieldAC)

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
    constant ANDP : std_logic_vector(3 downto 0) := "1001";
    constant ORP  : std_logic_vector(3 downto 0) := "1010";
    constant XORP : std_logic_vector(3 downto 0) := "1011";
    constant SLTI : std_logic_vector(3 downto 0) := "1100";
    constant SLTIU: std_logic_vector(3 downto 0) := "1101";

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
    constant jr    : std_logic_vector(4 downto 0) := "01100"; -- Jump to Register
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
    constant jrF    : std_logic_vector(5 downto 0) := "001000";

    begin
        case ALUOpAC is -- ALUOpAC can be determined by uPController. if there needs to be addition with an immediate value, the uPController can set ALUOp to ADD
        when ADD    =>
            OPSelectAC  <= addu;
            ALU_LO_HIAC <= (others => '0');
            LO_EnAC     <= '0';
            HI_EnAC     <= '0';
        when SUB    =>
            OPSelectAC  <= subu;
            ALU_LO_HIAC <= (others => '0');
            LO_EnAC     <= '0';
            HI_EnAC     <= '0';
        when BEQ    =>
            OPSelectAC  <= Abeq;
            ALU_LO_HIAC <= (others => '0');
            LO_EnAC     <= '0';
            HI_EnAC     <= '0';
        when BNE    =>
            OPSelectAC  <= Abne;
            ALU_LO_HIAC <= (others => '0');
            LO_EnAC     <= '0';
            HI_EnAC     <= '0';
        when BLEZ   =>
            OPSelectAC  <= Ablez;
            ALU_LO_HIAC <= (others => '0');
            LO_EnAC     <= '0';
            HI_EnAC     <= '0';
        when BGTZ   =>
            OPSelectAC  <= Abgtz;
            ALU_LO_HIAC <= (others => '0');
            LO_EnAC     <= '0';
            HI_EnAC     <= '0';
        when BLTZ   =>
            OPSelectAC  <= Abltz;
            ALU_LO_HIAC <= (others => '0');
            LO_EnAC     <= '0';
            HI_EnAC     <= '0';
        when BGEZ   =>
            OPSelectAC  <= Abgez;
            ALU_LO_HIAC <= (others => '0');
            LO_EnAC     <= '0';
            HI_EnAC     <= '0';
        
        when ANDP   =>
            OPSelectAC  <= Land;
            ALU_LO_HIAC <= (others => '0');
            LO_EnAC     <= '0';
            HI_EnAC     <= '0';
        when ORP    =>
            OPSelectAC  <= Lor;
            ALU_LO_HIAC <= (others => '0');
            LO_EnAC     <= '0';
            HI_EnAC     <= '0';
        when XORP   =>
            OPSelectAC  <= Lxor;
            ALU_LO_HIAC <= (others => '0');
            LO_EnAC     <= '0';
            HI_EnAC     <= '0';
        when SLTI   =>
            OPSelectAC  <= slt;
            ALU_LO_HIAC <= (others => '0');
            LO_EnAC     <= '0';
            HI_EnAC     <= '0';
        when SLTIU  =>
            OPSelectAC  <= sltu;
            ALU_LO_HIAC <= (others => '0');
            LO_EnAC     <= '0';
            HI_EnAC     <= '0';
        when FUN    =>
            case IRFunctionFieldAC is
            when LsllF   =>
                OPSelectAC  <= Lsll;
                ALU_LO_HIAC <= (others => '0');
                LO_EnAC     <= '0';
                HI_EnAC     <= '0';
            when LsrlF   =>
                OPSelectAC  <= Lsrl;
                ALU_LO_HIAC <= (others => '0');
                LO_EnAC     <= '0';
                HI_EnAC     <= '0';
            when AsraF   =>
                OPSelectAC  <= Asra;
                ALU_LO_HIAC <= (others => '0');
                LO_EnAC     <= '0';
                HI_EnAC     <= '0';
            when mfhiF   =>
                OPSelectAC  <= FNull; -- ALU does nothing
                ALU_LO_HIAC <= "10";
                LO_EnAC     <= '0';
                HI_EnAC     <= '0';
            when mfloF   =>
                OPSelectAC  <= FNull; -- ALU does nothing
                ALU_LO_HIAC <= "01";
                LO_EnAC     <= '0';
                HI_EnAC     <= '0';
            when multF   =>
                OPSelectAC  <= mult;
                ALU_LO_HIAC <= (others => '0');
                LO_EnAC     <= '1';
                HI_EnAC     <= '1';
            when multuF  =>
                OPSelectAC  <= multu;
                ALU_LO_HIAC <= (others => '0');
                LO_EnAC     <= '1';
                HI_EnAC     <= '1';
            when adduF   =>
                OPSelectAC  <= addu;
                ALU_LO_HIAC <= (others => '0');
                LO_EnAC     <= '0';
                HI_EnAC     <= '0';
            when subuF   =>
                OPSelectAC  <= subu;
                ALU_LO_HIAC <= (others => '0');
                LO_EnAC     <= '0';
                HI_EnAC     <= '0';
            when LandF   =>
                OPSelectAC  <= Land;
                ALU_LO_HIAC <= (others => '0');
                LO_EnAC     <= '0';
                HI_EnAC     <= '0';
            when LorF    =>
                OPSelectAC  <= Lor;
                ALU_LO_HIAC <= (others => '0');
                LO_EnAC     <= '0';
                HI_EnAC     <= '0';
            when LxorF   =>
                OPSelectAC  <= Lxor;
                ALU_LO_HIAC <= (others => '0');
                LO_EnAC     <= '0';
                HI_EnAC     <= '0';
            when sltF    =>
                OPSelectAC  <= slt;
                ALU_LO_HIAC <= (others => '0');
                LO_EnAC     <= '0';
                HI_EnAC     <= '0';
            when sltuF   =>
                OPSelectAC  <= sltu;
                ALU_LO_HIAC <= (others => '0');
                LO_EnAC     <= '0';
                HI_EnAC     <= '0';
            when jrF     =>
                OPSelectAC  <= jr;
                ALU_LO_HIAC <= (others => '0');
                LO_EnAC     <= '0';
                HI_EnAC     <= '0';
            when others  =>
                OPSelectAC  <= FNull;
                ALU_LO_HIAC <= (others => '0');
                LO_EnAC     <= '0';
                HI_EnAC     <= '0';
            end case;
        when others =>
        OPSelectAC  <= FNull;
        ALU_LO_HIAC <= (others => '0');
        LO_EnAC     <= '0';
        HI_EnAC     <= '0'; 
        end case;
    end process;
end behavioral;