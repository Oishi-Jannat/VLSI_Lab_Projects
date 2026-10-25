-- ACC (8 bit) + Z flag, NAND-based D flip-flop diye
library IEEE; use IEEE.STD_LOGIC_1164.ALL;
entity acc_z is
  port(CLK, RESET, EN : in std_logic;
       D : in std_logic_vector(7 downto 0);
       ACC : out std_logic_vector(7 downto 0);
       Z : out std_logic);
end acc_z;
architecture str of acc_z is
  signal q, m, dd, nd : std_logic_vector(7 downto 0);
  signal nreset, zq, znew, mz, dz, za, zb, a, b : std_logic;
begin
  ur : entity work.inv_g port map(a => RESET, y => nreset);
  g : for i in 0 to 7 generate
    mx : entity work.mux2_g port map(a => q(i), b => D(i), s => EN, y => m(i));  -- EN=0 hole value rakhe
    ar : entity work.and2_g port map(a => m(i), b => nreset, y => dd(i));        -- reset => 0
    ff : entity work.dff    port map(clk => CLK, d => dd(i), q => q(i));
    iv : entity work.inv_g  port map(a => D(i), y => nd(i));
  end generate;
  -- Z_new = 1 jodi D = 0x00 (shob bit 0)
  n1 : entity work.nand4 port map(a => nd(0), b => nd(1), c => nd(2), d => nd(3), y => a);
  n2 : entity work.nand4 port map(a => nd(4), b => nd(5), c => nd(6), d => nd(7), y => b);
  i1 : entity work.inv_g port map(a => a, y => za);
  i2 : entity work.inv_g port map(a => b, y => zb);
  zn : entity work.and2_g port map(a => za, b => zb, y => znew);
  mzx : entity work.mux2_g port map(a => zq, b => znew, s => EN, y => mz);
  zo : entity work.or2_g   port map(a => mz, b => RESET, y => dz);            -- reset => Z = 1
  zf : entity work.dff     port map(clk => CLK, d => dz, q => zq);
  ACC <= q; Z <= zq;
end str;
