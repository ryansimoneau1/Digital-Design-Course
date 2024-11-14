library ieee;
use ieee.std_logic_1164.all;

-- DO NOT CHANGE ANYTHING IN THE ENTITY

entity adder is
  port (
    input1    : in  std_logic_vector(5 downto 0);
    input2    : in  std_logic_vector(5 downto 0);
    carry_in  : in  std_logic;
    sum       : out std_logic_vector(5 downto 0);
    carry_out : out std_logic);
end adder;

-- DEFINE A RIPPLE-CARRY ADDER USING A STRUCTURE DESCRIPTION THAT CONSISTS OF 6
-- FULL ADDERS

architecture STR of adder is

signal c1, c2, c3, c4, c5 : std_logic;

begin  -- STR

  UFA0: entity work.fa
  port map (
  
    input1		=> input1(0),
    input2		=> input2(0),
    carry_in	=> carry_in,
    sum			=> sum(0),
    carry_out	=> c1
	 
	);
	--end fa;
	
  UFA1: entity work.fa
  port map (
  
    input1		=> input1(1),
    input2		=> input2(1),
    carry_in	=> c1,
    sum			=> sum(1),
    carry_out	=> c2
	 
	);
	--end fa;
	
  UFA2: entity work.fa
  port map (
  
    input1		=> input1(2),
    input2		=> input2(2),
    carry_in	=> c2,
    sum			=> sum(2),
    carry_out	=> c3
	 
	);
	--end fa;
	
  UFA3: entity work.fa
  port map (
  
    input1		=> input1(3),
    input2		=> input2(3),
    carry_in	=> c3,
    sum			=> sum(3),
    carry_out	=> c4
	 
	);
	--end fa;
	
  UFA4: entity work.fa
  port map (
  
    input1		=> input1(4),
    input2		=> input2(4),
    carry_in	=> c4,
    sum			=> sum(4),
    carry_out	=> c5
	 
	);
	--end fa;
	
  UFA5: entity work.fa
  port map (
  
    input1		=> input1(5),
    input2		=> input2(5),
    carry_in	=> c5,
    sum			=> sum(5),
    carry_out	=> carry_out
	 
	);
	--end fa;

end STR;