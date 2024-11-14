library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity MemDecodeLogic is
    port (
    addr         : in  std_logic_vector(31 downto 0);
    wren         : in  std_logic;
    rddata_sel   : out std_logic_vector(2 downto 0); -- 7 possible choices, so 3 select bits to accomodate
    sram_wren    : out std_logic;
    outport_wren : out std_logic;
    NWrEn        : out std_logic;
    GoWrEnNW     : out std_logic
    );
    end MemDecodeLogic;

architecture BHV of MemDecodeLogic is
    -- register locations
    constant IOPORT0: std_logic_vector(31 downto 0) := X"0000FFF8";
    constant INPORT1: std_logic_vector(31 downto 0) := X"0000FFFC";
    -- constant OUTPORT: std_logic_vector(31 downto 0) := X"00010000"; -- document says the same address as inport0, but that doesn't make any sense
    constant GO     : std_logic_vector(31 downto 0) := X"0000FFE8"; -- factorial 
    constant N      : std_logic_vector(31 downto 0) := X"0000FFEC"; -- factorial
    constant RESULT : std_logic_vector(31 downto 0) := X"0000FFF0"; -- factorial
    constant DONE   : std_logic_vector(31 downto 0) := X"0000FFE4"; -- factorial

    -- select values
    constant RAM    : std_logic_vector(2 downto 0) := "000";
    constant PORT0  : std_logic_vector(2 downto 0) := "001";
    constant PORT1  : std_logic_vector(2 downto 0) := "010";
    constant G0     : std_logic_vector(2 downto 0) := "011";
    constant Nn     : std_logic_vector(2 downto 0) := "100";
    constant RSLT   : std_logic_vector(2 downto 0) := "101";
    constant DNE    : std_logic_vector(2 downto 0) := "110";

begin
    process(addr, wren)
    begin

        -- default write enables to zero
        sram_wren    <= '0';
        outport_wren <= '0';
        NWrEn        <= '0';
        GoWrEnNW     <= '0';

        -- SRAM
        if(unsigned(addr) >= x"0000" and unsigned(addr) <= x"03FC") then
            rddata_sel <= RAM;
            if(wren = '1') then
                sram_wren    <= '1';
                outport_wren <= '0';
                NWrEn        <= '0';
                GoWrEnNW     <= '0';
            else
                sram_wren    <= '0';
                outport_wren <= '0';
                NWrEn        <= '0';
                GoWrEnNW     <= '0';
            end if;
        -- INPUT0 or OUTPUT
        elsif(addr = IOPORT0) then
            rddata_sel <= PORT0;
            if(wren = '1') then
                sram_wren    <= '0';
                outport_wren <= '1';
                NWrEn        <= '0';
                GoWrEnNW     <= '0';
            else
                sram_wren    <= '0';
                outport_wren <= '0';
                NWrEn        <= '0';
                GoWrEnNW     <= '0';
            end if;
        -- INPUT1
        elsif(addr = INPORT1) then
            rddata_sel <= PORT1;
            if(wren = '1') then
                sram_wren    <= '0';
                outport_wren <= '0';
                NWrEn        <= '0';
                GoWrEnNW     <= '0';
            end if;
        -- Go
        elsif(addr = GO) then -- make elsif for this
            rddata_sel <= G0;
            if(wren = '1') then
                sram_wren    <= '0';
                outport_wren <= '0';
                NWrEn        <= '0';
                GoWrEnNW     <= '1';
            else
                sram_wren    <= '0';
                outport_wren <= '0';
                NWrEn        <= '0';
                GoWrEnNW     <= '0';
            end if;
        -- N
        elsif(addr = N) then
            rddata_sel <= Nn;
            if(wren = '1') then
                sram_wren    <= '0';
                outport_wren <= '0';
                NWrEn        <= '1';
                GoWrEnNW     <= '0';
            else
                sram_wren    <= '0';
                outport_wren <= '0';
                NWrEn        <= '0';
                GoWrEnNW     <= '0';
            end if;
        -- RESULT
        elsif(addr = RESULT) then
            rddata_sel <= RSLT;
            sram_wren    <= '0'; -- what do I set these to for this case?
            outport_wren <= '0';
            NWrEn        <= '0';
            GoWrEnNW     <= '0';
        -- DONE
        elsif(addr = DONE) then
            rddata_sel <= DNE;
            sram_wren    <= '0'; -- what do I set these to for this case?
            outport_wren <= '0';
            NWrEn        <= '0';
            GoWrEnNW     <= '0';
        else
            rddata_sel <= (others => '0');
            sram_wren    <= '0'; -- what do I set these to for this case?
            outport_wren <= '0';
            NWrEn        <= '0';
            GoWrEnNW     <= '0';
        end if;
    end process;
end BHV;