library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all; 

entity cla4 is
    port(
        xh, yh : in std_logic_vector (3 downto 0);
        cinh   : in std_logic;
        sh     : out std_logic_vector (3 downto 0);
        couth  : out std_logic;
        BPh     : out std_logic;
		BGh    : out std_logic        
    );
end cla4;

architecture structural of cla4 is

    signal CLA0BP, CLA0BG : std_logic;
    signal CLA1BP, CLA1BG : std_logic;
    signal CGEN2Ci : std_logic;
    signal CLA1Cout : std_logic;

    component cla2
        port (
		    x 	 : in std_logic_vector(1 downto 0);
		    y 	 : in std_logic_vector(1 downto 0);
		    cin  : in std_logic;
		    s 	 : out std_logic_vector(1 downto 0);
		    cout : out std_logic;
		    BP   : out std_logic;
            BG   : out std_logic
        );
    end component;

    component cgen2
        port (
            C0, P0, G0, P1, G1 : in std_logic;
            C1, C2, BP, BG     : out std_logic  
        );
    end component;

begin
    CLA0: cla2
        port map (
            x(0) => xh(0),
            x(1) => xh(1),
            y(0) => yh(0),
            y(1) => yh(1),
            s(0) => sh(0),
            s(1) => sh(1),
            BP   => CLA0BP,
            BG   => CLA0BG,
            cin  => cinh
            
        );

    CLA1: cla2
        port map (
            x(0) => xh(2),
            x(1) => xh(3),
            y(0) => yh(2),
            y(1) => yh(3),
            s(0) => sh(2),
            s(1) => sh(3),
            cin  => CGEN2Ci,
            cout => CLA1Cout, -- check on this
            BP   => CLA1BP,
            BG   => CLA1BG
        );

    CGEN: cgen2
        port map (
            C0 => cinh,
            C1 => CGEN2Ci,
            C2 => couth,
            P0 => CLA0BP,
            G0 => CLA0BG,
            P1 => CLA1BP,
            G1 => CLA1BG,
            BP => BPh,
            BG => BGh
        );
end structural;
