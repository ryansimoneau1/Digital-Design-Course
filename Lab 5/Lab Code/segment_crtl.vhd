-- Joel Mandebi
-- University of Florida

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity segment_crtl is
   port(
	      factorial : in std_logic_vector(15 downto 0):= (others => '0'); 
			
			seg0 : out std_logic_vector(6 downto 0);
			seg1 : out std_logic_vector(6 downto 0);
			seg2 : out std_logic_vector(6 downto 0);
			seg3 : out std_logic_vector(6 downto 0)
			
			
		 ); 
end segment_crtl;

architecture arch of segment_crtl is

signal bdc_value : std_logic_vector(15 downto 0);

component seg
	port (
		input : in std_logic_vector (3 downto 0);
		output : out std_logic_vector (6 downto 0));
end component;



component bcd_converter 
  port ( 
    in_binary :  in std_logic_vector(31 downto 0); 
    digit_0   : out std_logic_vector( 3 downto 0); 
    digit_1   : out std_logic_vector( 3 downto 0); 
    digit_2   : out std_logic_vector( 3 downto 0); 
    digit_3   : out std_logic_vector( 3 downto 0); 
    digit_4   : out std_logic_vector( 3 downto 0); 
    digit_5   : out std_logic_vector( 3 downto 0); 
    digit_6   : out std_logic_vector( 3 downto 0); 
    digit_7   : out std_logic_vector( 3 downto 0); 
    digit_8   : out std_logic_vector( 3 downto 0); 
    digit_9   : out std_logic_vector( 3 downto 0) 
  ); 
end component; 


signal temp : std_logic_vector(31 downto 0):= (others => '0'); 


begin
   
	temp (15 downto 0) <= factorial;

	
   bcd_conv: bcd_converter port map(in_binary => temp , digit_0 => bdc_value(3 downto 0), digit_1=>bdc_value(7 downto 4) , digit_2 =>bdc_value(11 downto 8), digit_3 =>bdc_value(15 downto 12) );

   displ0: seg port map(input =>bdc_value(3 downto 0), output =>seg0);
	displ1: seg port map(input =>bdc_value(7 downto 4), output =>seg1);
	displ2: seg port map(input =>bdc_value(11 downto 8), output =>seg2);
	displ3: seg port map(input =>bdc_value(15 downto 12), output =>seg3);
end arch;