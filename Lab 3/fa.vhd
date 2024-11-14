library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity fa is
    port(
        a : in std_logic;
        b : in std_logic;
        FAcin : in std_logic;
        FAout : out std_logic;
        FAcout: out std_logic
    );
end fa;

architecture BHV of fa is
begin

    FAout  <= a xor b xor FAcin;
    FAcout <= (a and b) or (a and FAcin) or (b and FAcin); 

end BHV;