library ieee;
use ieee.std_logic_1164.all;

entity adder is
    generic (
        WIDTH : positive := 8); 
    port (
        x, y : in  std_logic_vector(WIDTH-1 downto 0); 
        cin  : in  std_logic;
        s    : out std_logic_vector(WIDTH-1 downto 0);
        cout : out std_logic);
end adder;

architecture RIPPLE_CARRY of adder is -- structural architecture

    component fa
        port(
            a : in std_logic; -- order of ports in component have possitional association when making entities in for generate
            b : in std_logic;
            FAcin : in std_logic;
            FAout : out std_logic;
            FAcout: out std_logic
        );
    end component;

signal carry: std_logic_vector(width downto 0);

begin  -- RIPPLE_CARRY
    carry(0)     <= cin;
    FAN: for i in 0 to (width-1) generate -- generate needs a label
        FAX: fa 
        port map (
            a      => x(i),
            b      => y(i),
            FAout  => s(i),
            FAcin  => carry(i),
            FAcout => carry(i+1)
        );
    end generate;
     cout <= carry(width);

end RIPPLE_CARRY;


architecture CARRY_LOOKAHEAD of adder is -- behavioral architecture

begin  -- CARRY_LOOKAHEAD

    process(x, y, cin)

        -- generate and propagate bits
        variable g, p : std_logic_vector(WIDTH-1 downto 0);

        -- internal carry bits
        variable carry : std_logic_vector(WIDTH downto 0);

        -- and'd p sequences
        variable p_ands : std_logic_vector(WIDTH-1 downto 0);

    begin

        -- calculate generate (g) and propogate (p) values

        for i in 0 to WIDTH-1 loop
        -- fill in code that defines each g and p bit
        end loop;  -- i

        carry(0) := cin;

        -- calculate each carry bit

        for i in 1 to WIDTH loop

            -- calculate and'd p terms for ith carry logic      
            -- the index j corresponds to the lowest Pj value in the sequence
            -- e.g., PiPi-1...Pj

            for j in 0 to i-1 loop
                p_ands(j) := '1';

                -- and everything from Pj to Pi-1
                for k in j to i-1 loop
                -- fill code
                end loop;
            end loop;

            carry(i) := g(i-1);

            -- handle all of the pg minterms
            for j in 1 to i-1 loop
            -- fill in code
            end loop;

            -- handle the final propagate of the carry in
            carry(i) := carry(i) or (p_ands(0) and cin);
        end loop;  -- i

        -- set the outputs
        for i in 0 to WIDTH-1 loop
        -- fill in code
        end loop;  -- i

        cout <= carry(WIDTH);

    end process;

end CARRY_LOOKAHEAD;


-- You don't have to change any of the code for the following
-- architecture. However, read the lab instructions to create
-- an RTL schematic of this entity so you can see how the
-- synthesized circuit differs from the previous carry
-- lookahead circuit.

architecture CARRY_LOOKAHEAD_BAD_SYNTHESIS of adder is
begin  -- CARRY_LOOKAHEAD_BAD_SYNTHESIS

    process(x, y, cin)

        -- generate and propagate bits
        variable g, p : std_logic_vector(WIDTH-1 downto 0);

        -- internal carry bits
        variable carry : std_logic_vector(WIDTH downto 0);

    begin

        -- calculate generate (g) and propogate (p) values

        for i in 0 to WIDTH-1 loop
            g(i) := x(i) and y(i);
            p(i) := x(i) or y(i);
        end loop;  -- i

        -- calculate carry bits (the order here is very important)
        -- Problem: defining the carries this way causes the synthesis
        -- tool to chain everything together like a ripple carry.
        -- See RTL view in synthesis tool.

        carry(0) := cin;
        for i in 0 to WIDTH-1 loop
            carry(i+1) := g(i) or (p(i) and carry(i));
        end loop;  -- i

        -- set the outputs

        for i in 0 to WIDTH-1 loop
            s(i) <= x(i) xor y(i) xor carry(i);
        end loop;  -- i

        cout <= carry(WIDTH);

    end process;

end CARRY_LOOKAHEAD_BAD_SYNTHESIS;



architecture HIERARCHICAL of adder is 

    signal BPOTG, BGOTG, BPGTT, BPTTG, BGTTG, CGTT : std_logic;

    component cla4
    port (
        xh, yh : in std_logic_vector (3 downto 0);
        cinh   : in std_logic;
        sh     : out std_logic_vector (3 downto 0);
        couth  : out std_logic;
        BPh    : out std_logic;
		BGh    : out std_logic    
    );
    end component;

    component cgen2
    port (
        C0, P0, G0, P1, G1 : in std_logic;
        C1, C2, BP, BG     : out std_logic  
    );
    end component;

begin  -- HIERARCHICAL
    H1: cla4
        port map(
            xh(3 downto 0) => x(3 downto 0) ,
            yh(3 downto 0) => y(3 downto 0) ,
            cinh           => cin ,
            couth          => open,
            BPh            => BPOTG,
            BGh            => BGOTG,
            sh(3 downto 0) => s(3 downto 0)        
        );
    H2: cla4
        port map(
            xh(3 downto 0) => x(7 downto 4),
            yh(3 downto 0) => y(7 downto 4),
            cinh           => CGTT,
            couth          => open,
            BPh            => BPTTG,
            BGh            => BGTTG,
            sh(3 downto 0) => s(7 downto 4)
        );
    CGEN4: cgen2
        port map(
            C0 => cin,
            C1 => CGTT,
            C2 => cout,
            P0 => BPOTG,
            G0 => BGOTG,
            P1 => BPTTG,
            G1 => BGTTG,
            BP => open,
            BG => open
        );

end HIERARCHICAL;
