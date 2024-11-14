library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity SignExtend is
    generic(
        WIDTH : positive := 32);
    port(
    IsSigned    : in std_logic;
    Input       : in  std_logic_vector((WIDTH/2 - 1) downto 0);
    Output      : out std_logic_vector((WIDTH - 1) downto 0));
end SignExtend;

architecture Behavioral of SignExtend is
begin

    process(Input, IsSigned)
    constant Zeros : unsigned((WIDTH/2 - 1) downto 0) := x"0000"; -- append 16 zeros to the front of the IR[0:15] field
    constant Ones  : unsigned((WIDTH/2 - 1) downto 0) := x"FFFF"; -- append 16 ones to the front of the IR[0:15] field  

    begin
        if((Input(15) and '1') = '1' and IsSigned = '1') then
            Output <= std_logic_vector(Ones & unsigned(Input));
        else
            Output <= std_logic_vector(Zeros & unsigned(Input)); -- this may cause issues. Not sure tho
        end if;
    end process;

end Behavioral;