library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity cgen2 is 
    port (
        C0, P0, G0, P1, G1 : in std_logic;
        C1, C2, BP, BG     : out std_logic  
    );
end cgen2;

architecture behavioral of cgen2 is
begin
    C1 <= G0 or (P0 and C0);
    C2 <= G1 or (P1 and G0) or (P1 and P0 and C0);
    BP <= P0 and P1;
    BG <= G1 or (P1 and G0);
end behavioral;