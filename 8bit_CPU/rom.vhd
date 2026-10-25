-- Program ROM (16 x 12), shob NAND gate diye:
--   1) 4->16 address decoder (nand4, active-low line)
--   2) protita data bit = OR of selected rows = NAND(active-low row line gulo)
-- Row content ROM_BITS constant e lekha (eta-i "mask" - kon bit kothay 1)
library IEEE; use IEEE.STD_LOGIC_1164.ALL;
entity prog_rom is
  port(ADDR : in std_logic_vector(3 downto 0); DATA : out std_logic_vector(11 downto 0));
end prog_rom;
architecture str of prog_rom is
  type rom_t is array (0 to 15) of std_logic_vector(11 downto 0);
  constant ROM_BITS : rom_t := (
    0 => x"180",  -- LDI 0x80
    1 => x"900",  -- SHR
    2 => x"310",  -- SUB 0x10
    3 => x"20F",  -- ADD 0x0F
    4 => x"63F",  -- XOR 0x3F
    5 => x"207",  -- ADD 0x07
    6 => x"900",  -- SHR
    others => x"000");  -- NOP
  signal na : std_logic_vector(3 downto 0);
  signal nsel : std_logic_vector(15 downto 0);   -- active-low row select
begin
  gi : for i in 0 to 3 generate
    iv : entity work.inv_g port map(a => ADDR(i), y => na(i));
  end generate;
  -- decoder: row k = nand4 of address literals (bit i = ADDR(i) jodi k er bit i = 1, nahole ~ADDR(i))
  gk : for k in 0 to 15 generate
    signal l : std_logic_vector(3 downto 0);
  begin
    gl : for i in 0 to 3 generate
      l(i) <= ADDR(i) when ((k / 2**i) mod 2) = 1 else na(i);
    end generate;
    dk : entity work.nand4 port map(a => l(0), b => l(1), c => l(2), d => l(3), y => nsel(k));
  end generate;
  -- data bit j = NAND( nsel(k) jekhane ROM_BITS(k)(j)=1, baki input '1' )
  gj : for j in 0 to 11 generate
    signal t : std_logic_vector(15 downto 0);
  begin
    gt : for k in 0 to 15 generate
      t(k) <= nsel(k) when ROM_BITS(k)(j) = '1' else '1';
    end generate;
    dj : entity work.nandn generic map(N => 16) port map(a => t, y => DATA(j));
  end generate;
end str;
