-- 4-bit PC: +1 incrementer (NAND gate) + 4 ta NAND-based D flip-flop
library IEEE; use IEEE.STD_LOGIC_1164.ALL;
entity pc is port(CLK, RESET : in std_logic; PC_OUT : out std_logic_vector(3 downto 0)); end pc;
architecture str of pc is
  signal q, nxt, d : std_logic_vector(3 downto 0);
  signal nreset, c1, c2 : std_logic;
begin
  ur : entity work.inv_g  port map(a => RESET, y => nreset);
  -- next = q + 1
  n0 : entity work.inv_g  port map(a => q(0), y => nxt(0));
  x1 : entity work.xor2_g port map(a => q(1), b => q(0), y => nxt(1));
  a1 : entity work.and2_g port map(a => q(1), b => q(0), y => c1);
  x2 : entity work.xor2_g port map(a => q(2), b => c1, y => nxt(2));
  a2 : entity work.and2_g port map(a => q(2), b => c1, y => c2);
  x3 : entity work.xor2_g port map(a => q(3), b => c2, y => nxt(3));
  -- synchronous reset + flip-flop
  g : for i in 0 to 3 generate
    ar : entity work.and2_g port map(a => nxt(i), b => nreset, y => d(i));
    ff : entity work.dff    port map(clk => CLK, d => d(i), q => q(i));
  end generate;
  PC_OUT <= q;
end str;
