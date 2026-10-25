-- Opcode decoder, shob NAND gate diye
-- LDI 0001, ADD 0010, SUB 0011, XOR 0110, SHR 1001
library IEEE; use IEEE.STD_LOGIC_1164.ALL;
entity control_unit is
  port(OPCODE : in std_logic_vector(3 downto 0);
       LDI, ADDSUB, SUB, XORS, SHR, ACC_EN : out std_logic);
end control_unit;
architecture str of control_unit is
  signal n : std_logic_vector(3 downto 0);
  signal l, a, s, x, h, nl, na, nx, nh : std_logic;
begin
  g : for i in 0 to 3 generate
    iv : entity work.inv_g port map(a => OPCODE(i), y => n(i));
  end generate;
  ul : entity work.and4_g port map(a => n(3), b => n(2), c => n(1), d => OPCODE(0), y => l);
  ua : entity work.and3_g port map(a => n(3), b => n(2), c => OPCODE(1), y => a);   -- ADD (0010) ba SUB (0011)
  us : entity work.and4_g port map(a => n(3), b => n(2), c => OPCODE(1), d => OPCODE(0), y => s);
  ux : entity work.and4_g port map(a => n(3), b => OPCODE(2), c => OPCODE(1), d => n(0), y => x);
  uh : entity work.and4_g port map(a => OPCODE(3), b => n(2), c => n(1), d => OPCODE(0), y => h);
  LDI <= l; ADDSUB <= a; SUB <= s; XORS <= x; SHR <= h;
  -- ACC_EN = l OR a OR x OR h = NAND(~l,~a,~x,~h)
  i1 : entity work.inv_g port map(a => l, y => nl);
  i2 : entity work.inv_g port map(a => a, y => na);
  i3 : entity work.inv_g port map(a => x, y => nx);
  i4 : entity work.inv_g port map(a => h, y => nh);
  ue : entity work.nand4 port map(a => nl, b => na, c => nx, d => nh, y => ACC_EN);
end str;
