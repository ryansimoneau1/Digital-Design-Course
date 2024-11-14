library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use ieee.math_real.all;
entity RegisterFile is
    generic(
        -- LENGTH : positive := 32;
        WIDTH  : positive := 32);
    port(
        clk         : in std_logic;
        rst         : in std_logic;
        rd_addr0    : in std_logic_vector(4 downto 0);
        rd_addr1    : in std_logic_vector(4 downto 0);
        wr_addr     : in std_logic_vector(4 downto 0);
        wr_en       : in std_logic;
        JandL       : in std_logic;
        wr_data     : in std_logic_vector (WIDTH - 1 downto 0);
        rd_data0    : out std_logic_vector(WIDTH - 1 downto 0);
        rd_data1    : out std_logic_vector(WIDTH - 1 downto 0)
        );
end RegisterFile;
architecture async_read of RegisterFile is
    type reg_array is array(0 to 31) of std_logic_vector(WIDTH - 1 downto 0);
    signal regs : reg_array;
    signal rdD1, rdD2: std_logic_vector(WIDTH - 1 downto 0);
begin
    process (clk, rst) is
    begin
        if(rst = '1') then
            regs <= (others => (others => '0'));
        elsif (rising_edge(clk)) then
            regs(0) <= (others => '0');
            if(unsigned(wr_addr) > 0) then
                rdD1 <= regs(to_integer(unsigned(rd_addr0)));
                rdD2 <= regs(to_integer(unsigned(rd_addr1)));
                if (wr_en = '1' and unsigned(wr_addr) < 31) then
                    regs(to_integer(unsigned(wr_addr))) <= wr_data;
                end if;
            end if;

            if(JandL = '1') then
                if(wr_en = '1') then
                    regs(31) <= wr_data;
                else
                    rdD1 <= regs(31);
                    rdD2 <= regs(to_integer(unsigned(rd_addr1)));
                end if;
            end if;
            rd_data0 <= regs(to_integer(unsigned(rd_addr0)));
            rd_data1 <= regs(to_integer(unsigned(rd_addr1)));
        end if;
    end process;
end async_read;