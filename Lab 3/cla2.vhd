
--pseudocode for the 2-bit carry looked adder
--fill in commented sections of code
--leave the 'and' and 'or' statements in your code, fill in respecitve --input-- and --variable-- sections

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity cla2 is
	port (
		x 	 : in std_logic_vector(1 downto 0);
		y 	 : in std_logic_vector(1 downto 0);
		cin  : in std_logic;
		s 	 : out std_logic_vector(1 downto 0);
		cout : out std_logic;
		BP   : out std_logic;
		BG   : out std_logic); 
end cla2;


architecture BHV of cla2 is

	--signals list
	--there should be no signals for the cla2, but signals would be placed here in your architecture

begin

	process(x, y, cin)
	
		--variables list, DO NOT CHANGE
		variable g 	 : std_logic_vector(1 downto 0);
		variable p 	 : std_logic_vector(1 downto 0);
		variable c1	 : std_logic;
	
	begin
		--gen, prop, and carry intermediate variables defined
		g(0) := x(0) and y(0);
		g(1) := x(1) and y(1);

		p(0) := (x(0) or y(0));
		p(1) := (x(1) or y(1));
		
		--2-bit carry variable
		c1 := g(0) or (p(0) and cin);
		
		--sum
		s(0) <= x(0) xor y(0) xor cin;
		s(1) <= x(1) xor y(1) xor c1;
		
		--prop and gen output
		BG <= g(1) or (p(1) and g(0));
		BP <= p(1) and p(0);
		
		--carry out final (effectively c2)
		cout <= g(1) or (p(1) and g(0)) or (p(1) and p(0) and cin);
		
	end process;
	
end BHV;