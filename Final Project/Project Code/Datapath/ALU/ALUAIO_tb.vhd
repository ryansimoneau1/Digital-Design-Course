library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity ALUAIO_tb is
end ALUAIO_tb;

architecture TB of ALUAIO_tb is

    constant WIDTH : positive := 32;

    -- R - Type instructions
    constant Lsll  : std_logic_vector(5 downto 0) := "000000"; -- shift left logical
    constant Lsrl  : std_logic_vector(5 downto 0) := "000010"; -- shift right logical
    constant Asra  : std_logic_vector(5 downto 0) := "000011"; -- shift right arithmetic
    constant jr    : std_logic_vector(5 downto 0) := "001000"; -- jump register  (how does the ALU do this)
    constant mfhi  : std_logic_vector(5 downto 0) := "010000"; -- move from high (how does the ALU do this)
    constant mflo  : std_logic_vector(5 downto 0) := "010010"; -- move from low  (how does the ALU do this)
    constant mult  : std_logic_vector(5 downto 0) := "011000"; -- multiplication
    constant multu : std_logic_vector(5 downto 0) := "011001"; -- multiplication unsigned
    constant addu  : std_logic_vector(5 downto 0) := "100001"; -- addition (unsigned)
    constant subu  : std_logic_vector(5 downto 0) := "100011"; -- subtraction (unsigned)
    constant Land  : std_logic_vector(5 downto 0) := "100100"; -- logical and
    constant Lor   : std_logic_vector(5 downto 0) := "100101"; -- logical or
    constant Lxor  : std_logic_vector(5 downto 0) := "100110"; -- logical exclusive or
    constant slt   : std_logic_vector(5 downto 0) := "101010"; -- set on less than (signed)
    constant sltu  : std_logic_vector(5 downto 0) := "101011"; -- set on less than (unsigned)

    -- branch instructions (placeholder codes for now)
    constant beq   : std_logic_vector(5 downto 0) := "110000"; -- branch when equal
    constant bne   : std_logic_vector(5 downto 0) := "110001"; -- branch when not equal
    constant blez  : std_logic_vector(5 downto 0) := "110010"; -- branch when less than or equal to zero
    constant bgtz  : std_logic_vector(5 downto 0) := "110011"; -- branch when greater than zero
    constant bltz  : std_logic_vector(5 downto 0) := "110100"; -- branch when less than zero
    constant bgez  : std_logic_vector(5 downto 0) := "110101"; -- branch when greater than or equal to zero

    component ALUAIO
        generic(
            WIDTH         :   positive := 32);
        port(
        in1, in2: in  std_logic_vector((WIDTH) - 1 downto 0);
        Sel     : in  std_logic_vector          (5 downto 0);
        immVal  : in  std_logic_vector          (4 downto 0);
        Result  : out std_logic_vector((WIDTH) - 1 downto 0); -- should this be doubled in size (isn't the register so yes?)
        HI      : out std_logic_vector((WIDTH) - 1 downto 0);
        Branch  : out std_logic);
    end component;

    signal in1t, in2t : std_logic_vector((WIDTH) - 1 downto 0);
    signal Selt      : std_logic_vector          (5 downto 0);
    signal immValt   : std_logic_vector          (4 downto 0);
    signal Resultt   : std_logic_vector((WIDTH) - 1 downto 0);
    signal HIt       : std_logic_vector((WIDTH) - 1 downto 0);
    signal Brancht   : std_logic;
begin
    UUT : ALUAIO 
    port map (
        in1    =>  in1t,
        in2    =>  in2t,
        sel    =>  selt,
        immVal =>  immValt,
        Result =>  Resultt,
        HI     =>  HIt,
        Branch =>  Brancht);

    process
    begin

        wait for 50 ns;
        in1t    <= x"0000000A";
        in2t    <= x"0000000F";
        immValt <= "00000";
        selt <= addu;

        wait for 50 ns;
        in1t    <= x"00000019";
        in2t    <= x"0000000A";
        immValt <= "00000";
        selt <= subu;

        wait for 50 ns;
        in1t    <= X"0000000A";
        in2t    <= X"FFFFFFFC";
        immValt <= "00000";
        selt <= mult;

        wait for 50 ns;
        in1t    <= X"00010000";
        in2t    <= X"00020000";
        immValt <= "00000";
        selt <= multu;

        wait for 50 ns;
        in1t    <= X"0000FFFF";
        in2t    <= X"FFFF1234";
        immValt <= "00000";
        selt <= Land;
        
        wait for 50 ns;
        in1t    <= X"0000000F";
        in2t    <= X"00000000";
        immValt <= "00100";
        selt <= Lsrl; 

        wait for 50 ns;
        in1t    <= X"F0000008";
        in2t    <= X"00000000";
        immValt <= "00001";
        selt <= Asra; 

        wait for 50 ns;
        in1t    <= X"00000008";
        in2t    <= X"00000000";
        immValt <= "00001";
        selt <= Asra; 

        wait for 50 ns;
        in1t    <= X"0000000A";
        in2t    <= X"0000000F";
        immValt <= "00000";
        selt <= sltu; 

        wait for 50 ns;
        in1t    <= X"0000000F";
        in2t    <= X"0000000A";
        immValt <= "00000";
        selt <= sltu; 

        wait for 50 ns;
        in1t    <= X"00000005";
        in2t    <= X"00000000";
        immValt <= "00000";
        selt <= blez;
        
        wait for 50 ns;
        in1t    <= X"00000005";
        in2t    <= X"00000000";
        immValt <= "00000";
        selt <= bgtz;

        wait for 150 ns;
    end process;
end TB;
