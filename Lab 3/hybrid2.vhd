library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity hybrid2 is
    port (
        xhy, yhy: in std_logic_vector (7 downto 0);
        cinhy   : in std_logic;
        couthy  : out std_logic;
        shy     : out std_logic_vector (7 downto 0)
    );
end hybrid2;

architecture structural of hybrid2 is

    component cla2
        port (
		    x 	 : in std_logic_vector(1 downto 0);
		    y 	 : in std_logic_vector(1 downto 0);
		    cin  : in std_logic;
		    s 	 : out std_logic_vector(1 downto 0);
		    cout : out std_logic;
		    BP   : out std_logic; -- no connect
            BG   : out std_logic  -- no connect 
        );
    end component;

    signal carryhy: std_logic_vector(2 downto 0); -- intermediate carries

begin

    CLA_0: cla2
    port map(
        x(1 downto 0) => xhy(1 downto 0),
        y(1 downto 0) => yhy(1 downto 0),
        cin           => cinhy,
        s(1 downto 0) => shy(1 downto 0),
        cout          => carryhy(0),
        BP            => open,
        BG            => open
    );
    CLA_1: cla2
    port map(
        x(1 downto 0) => xhy(3 downto 2),
        y(1 downto 0) => yhy(3 downto 2),
        cin           => carryhy(0),
        s(1 downto 0) => shy(3 downto 2),
        cout          => carryhy(1),
        BP            => open,
        BG            => open
    );
    CLA_2: cla2
    port map(
        x(1 downto 0) => xhy(5 downto 4),
        y(1 downto 0) => yhy(5 downto 4),
        cin           => carryhy(1),
        s(1 downto 0) => shy(5 downto 4),
        cout          => carryhy(2),
        BP            => open,
        BG            => open
    );
    CLA_3: cla2
    port map(
        x(1 downto 0) => xhy(7 downto 6),
        y(1 downto 0) => yhy(7 downto 6),
        cin           => carryhy(2),
        s(1 downto 0) => shy(7 downto 6),
        cout          => couthy,
        BP            => open,
        BG            => open
    );


end structural;