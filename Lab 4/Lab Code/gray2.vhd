library ieee;
use ieee.std_logic_1164.all;

entity gray2 is
    port (
        clk    : in  std_logic;
        rst    : in  std_logic;
        go     : in std_logic;
        output : out std_logic_vector(3 downto 0));
end gray2;

architecture behavioral of gray2 is
    type STATE_TYPE is (STATE0,STATE1,STATE2,STATE3,STATE4,STATE5,STATE6,STATE7
                       ,STATE8,STATE9,STATEA,STATEB,STATEC,STATED,STATEE,STATEF);
    signal state, next_state: STATE_TYPE;
    
begin
    process(clk,rst)
    begin
        if(rst = '1') then
            state  <= STATE0;
        elsif(rising_edge(clk)) then
            state <= next_state;
        end if;
    end process;

    process(state, go)
    begin
        case state is
            when STATE0 =>
            output <= "0000";
            if(go = '1') then
                next_state <= STATE1;
            end if;

            when STATE1 =>
            output <= "0001";
            if(go = '1') then
                next_state <= STATE2;
            end if;

            when STATE2 =>
            output <= "0011";
            if(go = '1') then
                next_state <= STATE3;
            end if;

            when STATE3 =>
            output <= "0010";
            if(go = '1') then
                next_state <= STATE4;
            end if;

            when STATE4 =>
            output <= "0110";
            if(go = '1') then
                next_state <= STATE5;
            end if;

            when STATE5 =>
            output <= "0111";
            if(go = '1') then
                next_state <= STATE6;
            end if;

            when STATE6 =>
            output <= "0101";
            if(go = '1') then
                next_state <= STATE7;
            end if;

            when STATE7 =>
            output <= "0100";
            if(go = '1') then
                next_state <= STATE8;
            end if;

            when STATE8 =>
            output <= "1100";
            if(go = '1') then
                next_state <= STATE9;
            end if;

            when STATE9 =>
            output <= "1101";
            if(go = '1') then
                next_state <= STATEA;
            end if;

            when STATEA =>
            output <= "1111";
            if(go = '1') then
                next_state <= STATEB;
            end if;

            when STATEB =>
            output <= "1110";
            if(go = '1') then
                next_state <= STATEC;
            end if;

            when STATEC =>
            output <= "1010";
            if(go = '1') then
                next_state <= STATED;
            end if;

            when STATED =>
            output <= "1011";
            if(go = '1') then
                next_state <= STATEE;
            end if;

            when STATEE =>
            output <= "1001";
            if(go = '1') then
                next_state <= STATEF;
            end if;

            when STATEF =>
            output <= "1000";
            if(go = '1') then
                next_state <= STATE0;
            end if;

            when others => null;
        end case;
    end process;
end behavioral;
    