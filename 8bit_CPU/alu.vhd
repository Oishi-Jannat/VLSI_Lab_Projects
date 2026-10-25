-- 8-bit ALU (LDI, ADD, SUB, XOR, SHR) shob NAND gate diye
library IEEE; use IEEE.STD_LOGIC_1164.ALL;
entity alu is
  port(ACC, IMM : in std_logic_vector(7 downto 0);
       LDI, ADDSUB, SUB, XORS, SHR : in std_logic;
       RES : out std_logic_vector(7 downto 0));
end alu;
architecture str of alu is
  signal b, s, x, sh : std_logic_vector(7 downto 0);
  signal c : std_logic_vector(8 downto 0);
  signal p1, p2, p3, p4 : std_logic_vector(7 downto 0);
begin
  c(0) <= SUB;   -- SUB = ACC + (~IMM) + 1
  g : for i in 0 to 7 generate
    bx : entity work.xor2_g     port map(a => IMM(i), b => SUB, y => b(i));
    fa : entity work.full_adder port map(a => ACC(i), b => b(i), cin => c(i), s => s(i), cout => c(i+1));
    xo : entity work.xor2_g     port map(a => ACC(i), b => IMM(i), y => x(i));
    -- result mux: nand4 of four nand2 terms (AND-OR)
    m1 : entity work.nand2 port map(a => LDI,    b => IMM(i), y => p1(i));
    m2 : entity work.nand2 port map(a => ADDSUB, b => s(i),   y => p2(i));
    m3 : entity work.nand2 port map(a => XORS,   b => x(i),   y => p3(i));
    m4 : entity work.nand2 port map(a => SHR,    b => sh(i),  y => p4(i));
    mo : entity work.nand4 port map(a => p1(i), b => p2(i), c => p3(i), d => p4(i), y => RES(i));
  end generate;
  sh(6 downto 0) <= ACC(7 downto 1);   -- SHR: 1 bit dane shift
  sh(7) <= '0';                        -- MSB te 0 dhoke
end str;
