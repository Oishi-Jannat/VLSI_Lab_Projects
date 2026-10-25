-- Shob gate NAND theke banano. Ekmatro primitive: nand2 / nand3 / nand4
library IEEE; use IEEE.STD_LOGIC_1164.ALL;

entity nand2 is port(a, b : in std_logic; y : out std_logic); end nand2;
architecture rtl of nand2 is begin y <= a nand b; end rtl;

library IEEE; use IEEE.STD_LOGIC_1164.ALL;
entity nand3 is port(a, b, c : in std_logic; y : out std_logic); end nand3;
architecture rtl of nand3 is begin y <= not (a and b and c); end rtl;

library IEEE; use IEEE.STD_LOGIC_1164.ALL;
entity nand4 is port(a, b, c, d : in std_logic; y : out std_logic); end nand4;
architecture rtl of nand4 is begin y <= not (a and b and c and d); end rtl;

-- NOT = NAND(a,a)
library IEEE; use IEEE.STD_LOGIC_1164.ALL;
entity inv_g is port(a : in std_logic; y : out std_logic); end inv_g;
architecture str of inv_g is begin
  u: entity work.nand2 port map(a => a, b => a, y => y);
end str;

-- AND = NOT(NAND)
library IEEE; use IEEE.STD_LOGIC_1164.ALL;
entity and2_g is port(a, b : in std_logic; y : out std_logic); end and2_g;
architecture str of and2_g is signal n : std_logic; begin
  u1: entity work.nand2 port map(a => a, b => b, y => n);
  u2: entity work.inv_g port map(a => n, y => y);
end str;

library IEEE; use IEEE.STD_LOGIC_1164.ALL;
entity and3_g is port(a, b, c : in std_logic; y : out std_logic); end and3_g;
architecture str of and3_g is signal n : std_logic; begin
  u1: entity work.nand3 port map(a => a, b => b, c => c, y => n);
  u2: entity work.inv_g port map(a => n, y => y);
end str;

library IEEE; use IEEE.STD_LOGIC_1164.ALL;
entity and4_g is port(a, b, c, d : in std_logic; y : out std_logic); end and4_g;
architecture str of and4_g is signal n : std_logic; begin
  u1: entity work.nand4 port map(a => a, b => b, c => c, d => d, y => n);
  u2: entity work.inv_g port map(a => n, y => y);
end str;

-- OR = NAND(NOT a, NOT b)
library IEEE; use IEEE.STD_LOGIC_1164.ALL;
entity or2_g is port(a, b : in std_logic; y : out std_logic); end or2_g;
architecture str of or2_g is signal na, nb : std_logic; begin
  u1: entity work.inv_g port map(a => a, y => na);
  u2: entity work.inv_g port map(a => b, y => nb);
  u3: entity work.nand2 port map(a => na, b => nb, y => y);
end str;

-- XOR = 4 ta NAND
library IEEE; use IEEE.STD_LOGIC_1164.ALL;
entity xor2_g is port(a, b : in std_logic; y : out std_logic); end xor2_g;
architecture str of xor2_g is signal n1, n2, n3 : std_logic; begin
  u1: entity work.nand2 port map(a => a,  b => b,  y => n1);
  u2: entity work.nand2 port map(a => a,  b => n1, y => n2);
  u3: entity work.nand2 port map(a => b,  b => n1, y => n3);
  u4: entity work.nand2 port map(a => n2, b => n3, y => y);
end str;

-- MUX2: y = a (s=0), y = b (s=1)
library IEEE; use IEEE.STD_LOGIC_1164.ALL;
entity mux2_g is port(a, b, s : in std_logic; y : out std_logic); end mux2_g;
architecture str of mux2_g is signal ns, n1, n2 : std_logic; begin
  u1: entity work.inv_g  port map(a => s, y => ns);
  u2: entity work.nand2 port map(a => a, b => ns, y => n1);
  u3: entity work.nand2 port map(a => b, b => s,  y => n2);
  u4: entity work.nand2 port map(a => n1, b => n2, y => y);
end str;

-- Full adder (XOR + NAND diye)
library IEEE; use IEEE.STD_LOGIC_1164.ALL;
entity full_adder is port(a, b, cin : in std_logic; s, cout : out std_logic); end full_adder;
architecture str of full_adder is signal x, n1, n2 : std_logic; begin
  u1: entity work.xor2_g port map(a => a, b => b,   y => x);
  u2: entity work.xor2_g port map(a => x, b => cin, y => s);
  u3: entity work.nand2 port map(a => a, b => b,   y => n1);
  u4: entity work.nand2 port map(a => x, b => cin, y => n2);
  u5: entity work.nand2 port map(a => n1, b => n2, y => cout);
end str;

-- Gated D latch (4 NAND)
library IEEE; use IEEE.STD_LOGIC_1164.ALL;
entity d_latch is port(d, en : in std_logic; q : out std_logic); end d_latch;
architecture str of d_latch is signal s, r, qi, qb : std_logic; begin
  u1: entity work.nand2 port map(a => d,  b => en, y => s);
  u2: entity work.nand2 port map(a => s,  b => en, y => r);
  u3: entity work.nand2 port map(a => s,  b => qb, y => qi);
  u4: entity work.nand2 port map(a => r,  b => qi, y => qb);
  q <= qi;
end str;

-- Rising-edge D flip-flop = master latch + slave latch (shob NAND)
library IEEE; use IEEE.STD_LOGIC_1164.ALL;
entity dff is port(clk, d : in std_logic; q : out std_logic); end dff;
architecture str of dff is signal nclk, m : std_logic; begin
  u1: entity work.inv_g   port map(a => clk, y => nclk);
  u2: entity work.d_latch port map(d => d, en => nclk, q => m);
  u3: entity work.d_latch port map(d => m, en => clk,  q => q);
end str;

-- N-input NAND (ROM er bit line er jonno). Shob input '1' hole output '0'
library IEEE; use IEEE.STD_LOGIC_1164.ALL;
entity nandn is
  generic(N : positive := 16);
  port(a : in std_logic_vector(N-1 downto 0); y : out std_logic);
end nandn;
architecture rtl of nandn is
  constant ONES : std_logic_vector(N-1 downto 0) := (others => '1');
begin
  y <= '0' when a = ONES else '1';
end rtl;
