library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity ZeroExtend is
    generic(WIDTH : positive := 32);
    port(
    Input : in  std_logic_vector(9 downto 0);
    Output: out std_logic_vector((WIDTH - 1) downto 0));
end ZeroExtend;

architecture Behavioral of ZeroExtend is
    constant Zeros : unsigned((21) downto 0) := "0000000000000000000000"; -- append 22 zeros to the front of the Input field
begin

    Output <= std_logic_vector(Zeros & unsigned(Input));

end Behavioral;