library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity alu_ns is
generic (
WIDTH : positive := 4
);
port (
input1   : in std_logic_vector(WIDTH-1 downto 0);
input2   : in std_logic_vector(WIDTH-1 downto 0);
sel      : in std_logic_vector(3 downto 0);
output   : out std_logic_vector(WIDTH-1 downto 0);
overflow : out std_logic
);
end alu_ns;

architecture behavioral of alu_ns is
begin
    process(input1, input2, sel)
        variable temp      : unsigned((width-1) downto 0);
        variable temp_add  : unsigned((width) downto 0);
        variable temp_mult : unsigned(2*(width)-1 downto 0);-- size seems off
        variable temp_for  : unsigned((width-1) downto 0);

    begin
        overflow <= '0'; 
        output <= (others => '0'); -- why is it defined like this and not like overflow was? because its a port and not a variable?

        case sel is 
            -- Addition
            when "0000" =>
                temp_add := resize(unsigned(input1), WIDTH+1) + resize(unsigned(input2), WIDTH+1);
                output   <= std_logic_vector(temp_add(width-1 downto 0));
                overflow <= temp_add(width);
            -- Subtraction
            when "0001" =>
                output <= std_logic_vector(unsigned(input1) - unsigned(input2));
            -- Multiplication
            when "0010" =>
                temp_mult := unsigned(input1) * unsigned(input2);
                output <= std_logic_vector(temp_mult(width-1 downto 0));
                if(temp_mult(2*width-1 downto width) > 0) then
                    overflow <= '1';
                end if;
            -- And
            when "0011" =>
                output <= std_logic_vector(unsigned(input1 and input2));
            -- Or
            when "0100" =>
                output <= std_logic_vector(unsigned(input1 or input2));
            -- Xor
            when "0101" =>
                output <= std_logic_vector(unsigned(input1 xor input2));
            -- Nor
            when "0110" =>
                output <= std_logic_vector(unsigned(input1 nor input2));
            -- Not
            when "0111" =>
                output <= std_logic_vector(unsigned(not(input1)));
            -- Left Shift
            when "1000" =>
                overflow <= input1(width-1);
                output <= std_logic_vector(shift_left(unsigned(input1), 1)); 
            -- Shift Right
            when "1001" =>
                output <= std_logic_vector(shift_right(unsigned(input1), 2)); 
            -- Swap
            when "1010" =>
                if(width mod 2 = 0) then
                    output <= std_logic_vector(unsigned(input2(width/2-1 downto 0)) & unsigned(input2(width-1 downto width/2)));
                else
                    output <= std_logic_vector(unsigned(input2(width downto (width-1)/2+1)) & unsigned(input2((width-1)/2 downto 0))); -- double check this in the morning
                end if;
            -- Reverse
            when "1011" =>
                for i in width-1 downto 0 loop
							temp_for(i) := input2(width-1-i);
                    end loop;
                output <= std_logic_vector(temp_for(width-1 downto 0));
            -- Parity
            when "1100" => -- not sure what this is asking. # of 1's is even, or if the width of the number is even
                if(width mod 2 = 0) then
                    output <= (others => '0'); -- is this how the output would be defined?
                else
                    output    <= (others => '1');
                    
                end if;
            -- 2's Complement
            when "1101" =>
                output <= std_logic_vector(not(unsigned(input2)) + 1);

            when "1110" =>
                    if((input1) >= (input2)) then
                        temp_add := resize(unsigned(input1), WIDTH+1) + resize(unsigned(input2), WIDTH+1);
                        output   <= std_logic_vector(temp_add(width-1 downto 0));
                        overflow <= temp_add(width);
                        
                    else
                        output <= std_logic_vector(unsigned(input2) - unsigned(input1));
                    end if;
            when others => null;
        end case;
    end process;
end behavioral;
            

    