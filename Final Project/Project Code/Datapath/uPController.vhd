library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity uPController is
    generic(WIDTH: positive := 32);
    port(

        clk             : in std_logic;
        rst             : in std_logic;

        -- Datapath Control Signals
        IorDC           : out std_logic;
        MemWriteC       : out std_logic;
        MemtoRegC       : out std_logic;
        IRWriteC        : out std_logic;
        JumpAndLinkC    : out std_logic;
        IsSignedC       : out std_logic;
        PCSourceC       : out std_logic_vector(1 downto 0);
        ALUSrcBC        : out std_logic_vector(1 downto 0);
        ALUSrcAC        : out std_logic;
        RegWriteC       : out std_logic;
        RegDstC         : out std_logic;
        PCWriteCondC    : out std_logic;
        PCWriteC        : out std_logic;

        -- ALU Controller control Signals
        ALUOpC          : out std_logic_vector(3 downto 0);

        -- DataPath to Controller Ports
        OpCodeC         : in std_logic_vector(WIDTH - 1 downto 0)

    );
end uPController;

architecture behavioral of uPController is
    type STATE_TYPE is(START, STARTC2, FETCH, FETCHC2, FETCHC3, FETCHC4, DCODE, RTYPE, RTYPEC2, ITYPE, BRANCHC1, BRANCHC2, LSW, LOAD, LOADC2, LOADC3, LOADC4, STORE, STOREC2, JUMP, JUMPJ, JUMPAL, BUG);
    signal state, next_state: STATE_TYPE;
begin

    process(clk, rst)
	begin
		if (rst = '1') then 
			state <= START;
		elsif (rising_edge(clk)) then
			state <= next_state;
		end if;
    end process;
    
    process(state)

    --ALUOp Values
    constant ADD  : std_logic_vector(3 downto 0) := "0000";
    constant SUB  : std_logic_vector(3 downto 0) := "0001";
    constant FUN  : std_logic_vector(3 downto 0) := "0010";
    constant BEQ  : std_logic_vector(3 downto 0) := "0011";
    constant BNE  : std_logic_vector(3 downto 0) := "0100";
    constant BLEZ : std_logic_vector(3 downto 0) := "0101";
    constant BGTZ : std_logic_vector(3 downto 0) := "0110";
    constant BLTZ : std_logic_vector(3 downto 0) := "0111";
    constant BGEZ : std_logic_vector(3 downto 0) := "1000";
    constant ANDP : std_logic_vector(3 downto 0) := "1001";
    constant ORP  : std_logic_vector(3 downto 0) := "1010";
    constant XORP : std_logic_vector(3 downto 0) := "1011";
    constant SLTI : std_logic_vector(3 downto 0) := "1100";
    constant SLTIU: std_logic_vector(3 downto 0) := "1101";

    begin

        IorDC           <= '0';       
        MemWriteC       <= '0';
        MemtoRegC       <= '0';
        IRWriteC        <= '0';
        JumpAndLinkC    <= '0';
        IsSignedC       <= '0';
        PCSourceC       <= "00";
        ALUSrcBC        <= "00";
        ALUSrcAC        <= '0';
        RegWriteC       <= '0';
        RegDstC         <= '0';
        PCWriteCondC    <= '0';
        PCWriteC        <= '0';
        ALUOpC          <= x"0";

        case state is
            when START =>
                PCWriteC    <= '1';
                PCSourceC   <= "11";
                next_state  <= STARTC2;

            when STARTC2 =>
                next_state  <= FETCH;

            when FETCH =>
                IorDC       <= '0';
                ALUSrcAC    <= '0';
                ALUSrcBC    <= "01";
                PCSourceC   <= "00";
                next_state  <= FETCHC2;

            when FETCHC2 =>
                ALUSrcAC    <= '0';
                ALUSrcBC    <= "01";
                PCSourceC   <= "00";
                next_state  <= FETCHC3;

            when FETCHC3 =>
            ALUSrcAC    <= '0';
            ALUSrcBC    <= "01";
            PCSourceC   <= "00";
            ALUOpC      <= ADD; -- adds 4 to Current PC value
            next_state  <= FETCHC4;

            when FETCHC4 =>
                ALUSrcAC    <= '0';
                ALUSrcBC    <= "01";
                PCSourceC   <= "00";
                PCWriteC    <= '1';
                IRWriteC    <= '1'; -- latch the current value of the PC into the IR
                next_state  <= DCODE;

            when DCODE =>
                -- Check for R-Type
                if(OpCodeC(31 downto 26) = "000000") then
                    next_state  <= RTYPE;
                -- Check for I-Type
                elsif(OpCodeC(31 downto 26) >= "001001" OR OpCodeC(31 downto 26) <= "001110") then
                    if(OpCodeC(31 downto 26) = "001001") then
                        ALUOpC  <= ADD;
                    elsif(OpCodeC(31 downto 26) = "001010") then
                        ALUOpC  <= SUB;
                    elsif(OpCodeC(31 downto 26) = "001100") then
                        ALUOpC  <= ANDP;
                    elsif(OpCodeC(31 downto 26) = "001101") then
                        ALUOpC  <= ORP;
                    elsif(OpCodeC(31 downto 26) = "001110") then
                        ALUOpC  <= XORP;
                    end if;
                    next_state  <= ITYPE;

                -- Check for Jump
                elsif(OpCodeC(31 downto 26) = "000010" or OpCodeC(31 downto 26) = "000011") then
                    next_state  <= JUMP;
                -- Check for BRANCHC1
                elsif(OpCodeC(31 downto 26) >= "001001" OR OpCodeC(31 downto 26) <= "001110") then
                    next_state  <= BRANCHC1;
                -- Check for Load/Store
                elsif(OpCodeC(31 downto 26) = "010011" or OpCodeC(31 downto 26) = "011011") then
                    next_state  <= LSW;
                else
                    next_state  <= BUG;
                end if;

            when RTYPE =>
                ALUSrcAC    <= '1';
                ALUSrcBC    <= "00";
                ALUOpC      <= FUN;
                next_state  <= RTYPEC2;

            when RTYPEC2 =>
                if(OpcodeC(5 downto 0) = "001000") then
                    PCSourceC <= "00";
                    PCWriteC <= '1';
                    next_state <= FETCH; 
                else 
                    MemToRegC   <= '0';
                    RegDstC     <= '1';
                    RegWriteC   <= '1';
                    next_state  <= FETCH;
                end if;

            when ITYPE =>
                if(OpCodeC(31 downto 26) = "001010") then
                    IsSignedC    <= '1';
                end if;
                ALUSrcAC    <= '1';
                ALUSrcBC    <= "10";
                MemToRegC   <= '0';
				RegDstC     <= '0';
				RegWriteC   <= '1';
				next_state  <= FETCH;

            when JUMP =>
                if (OpCodeC(31 downto 26) = "000010") then 
                    next_state <= JUMPJ;
                else
                    next_state <= JUMPAL;
                end if;

            when JUMPJ =>
                PCSourceC   <= "10";
                PCWriteC    <= '1';
                next_state  <= FETCH;

            when JUMPAL => 
                JumpAndLinkC    <='1';
                ALUSrcAC        <= '0';
                MemToRegC       <= '0';
                RegWriteC       <= '1';
                PCWriteC        <= '1';
                PCSourceC        <= "10";
                next_state      <= FETCH;
                

            when BRANCHC1 =>
                ALUSrcAC    <= '0';
                ALUSrcBC    <= "11";
                ALUOpC      <= ADD; -- sum the PC and the Offset

                next_state <= BRANCHC2;

            when BRANCHC2 =>
                ALUSrcAC    <= '1';
                ALUSrcBC    <= "00";
                if   (OpCodeC(31 downto 26) = "000100") then
                    ALUOpC      <= BEQ;
                elsif(OpCodeC(31 downto 26) = "000101") then
                    ALUOpC      <= BNE;
                elsif(OpCodeC(31 downto 26) = "000110") then
                    ALUOpC      <= BLEZ;
                elsif(OpCodeC(31 downto 26) = "000111") then
                    ALUOpC      <= BGTZ;
                elsif(OpCodeC(31 downto 26) = "000001") then
                    if(OpCodeC(20 downto 16) = "00001") then
                        ALUOpC  <= BGEZ;
                    else
                        ALUOpC  <= BLTZ;
                    end if;
                end if;
                PCSourceC   <= "01";
                PCWriteC    <= '1';
                next_state <= FETCH;    

            when LSW =>
                if(OpCodeC(31 downto 26) = "100011") then
                    next_state  <= LOAD;
                else
                    next_state  <= STORE;
                end if;

			when LOAD =>
				IsSignedC   <= '1';
				ALUSrcAC    <= '1';
				ALUSrcBC    <= "10";
				ALUOpC      <= ADD;
				next_state  <= LOADC2;
				
			when LOADC2 =>
				IsSignedC   <= '1';
				ALUSrcAC    <= '1';
				ALUSrcBC    <= "10";
				ALUOpC      <= ADD;
				IorDC       <= '1'; 
                next_state  <= LOADC3;

            when LOADC3 =>
                IorDC       <= '1'; 
                next_state  <= LOADC4;

            when LOADC4 =>
                MemToRegC   <= '1';
                RegDstC     <= '0';
                RegWriteC   <= '1';
                next_state  <= FETCH;

            when STORE =>
                IsSignedC   <= '1';
                ALUSrcAC    <= '1';
                ALUSrcBC    <= "10";
                ALUOpC      <= ADD; -- add the offset to 
                next_state  <= STOREC2;
            
            when STOREC2 =>
                ALUSrcAC    <= '1';
                ALUSrcBC    <= "10";
                ALUOpC      <= ADD;
                IorDC       <= '1';
                MemWriteC   <= '1';
                next_state  <= FETCH;

            when BUG =>
                next_state  <= BUG; -- infinite loop

            when others =>
                IorDC           <= '0';       
                MemWriteC       <= '0';
                MemtoRegC       <= '0';
                IRWriteC        <= '0';
                JumpAndLinkC    <= '0';
                IsSignedC       <= '0';
                PCSourceC       <= "00";
                ALUSrcBC        <= "00";
                ALUSrcAC        <= '0';
                RegWriteC       <= '0';
                RegDstC         <= '0';
                PCWriteCondC    <= '0';
                PCWriteC        <= '0';
                ALUOpC          <= x"0";
                next_state      <= FETCH;
        end case;
    end process;
end behavioral;