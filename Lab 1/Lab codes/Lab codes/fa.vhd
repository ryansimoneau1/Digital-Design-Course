library ieee;
use ieee.std_logic_1164.all;

-- DO NOT CHANGE ANYTHING IN THE ENTITY
-- This is a modification of this file. Is this modification carried to Quartus?
-- more edits
entity fa is
  port (
    input1    : in  std_logic;
    input2    : in  std_logic;
    carry_in  : in  std_logic;
    sum       : out std_logic;
    carry_out : out std_logic);
end fa;

-- DEFINE THE FULL ADDER HERE

architecture BHV of fa is
begin 
	sum <= (input1 xor input2) xor carry_in;
	carry_out <= (input1 and input2) or (input1 and carry_in) or (input2 and carry_in);
  
end BHV;