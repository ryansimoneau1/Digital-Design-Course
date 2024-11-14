--Jonathan Cruz
--University of Florida

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use work.constants.all;

entity simon is
    port(
	clk	: in std_logic;
	rst	: in std_logic;	
	key_in	: in std_logic_vector(2*BLOCK_SIZE-1 downto 0); --key input
	input	: in std_logic_vector(BLOCK_SIZE-1 downto 0); --plaintext or ciphertext
	round_count : in std_logic_vector(4 downto 0); -- current round count
	mux_x_sel, mux_y_sel : in std_logic_vector(1 downto 0); --control for muxes
	ff_key_en, ff_x_en, ff_y_en : in std_logic; --enable for FFs
	output	: out std_logic_vector(BLOCK_SIZE-1 downto 0)); --final plaintext or ciphertext
end simon;

architecture datapath of simon is
----------- your signals here -----------
type KEY_EXPANSION_ARR is array (0 to N_ROUNDS-1) of std_logic_vector(WORD_SIZE-1 downto 0);
type ROUND_COUNT_ARR is array (0 to N_ROUNDS-1) of std_logic_vector(4 downto 0);
signal round_key : KEY_EXPANSION_ARR; --round keys
signal round_count_index : ROUND_COUNT_ARR; --index for round keys

begin


-----initialize round keys taken from input here-------

--round count array for key expansion
round_count_index <= ("00000","00001","00010", "00011","00100","00101","00110","00111",
                "01000","01001","01010","01011");
				
-- generate round keys
GEN_ROUND_KEYS: for i in 4 to N_ROUNDS-1 generate
----------- your code here -----------

end generate GEN_ROUND_KEYS;
 	
----------- your code here -----------



				

  
end datapath;