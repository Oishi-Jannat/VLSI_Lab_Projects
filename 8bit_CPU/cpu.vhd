library IEEE; use IEEE.STD_LOGIC_1164.ALL;
entity cpu is
  port(CLK, RESET : in std_logic;
       Q : out std_logic_vector(7 downto 0);
       Z : out std_logic;
       PC : out std_logic_vector(3 downto 0));
end cpu;
architecture struct of cpu is
  signal pc_s : std_logic_vector(3 downto 0);
  signal instr : std_logic_vector(11 downto 0);
  signal acc_s, res_s : std_logic_vector(7 downto 0);
  signal ldi_s, addsub_s, sub_s, xor_s, shr_s, en_s : std_logic;
begin
  U_PC  : entity work.pc          port map(CLK => CLK, RESET => RESET, PC_OUT => pc_s);
  U_ROM : entity work.prog_rom    port map(ADDR => pc_s, DATA => instr);
  U_CU  : entity work.control_unit port map(OPCODE => instr(11 downto 8), LDI => ldi_s, ADDSUB => addsub_s,
                                            SUB => sub_s, XORS => xor_s, SHR => shr_s, ACC_EN => en_s);
  U_ALU : entity work.alu         port map(ACC => acc_s, IMM => instr(7 downto 0), LDI => ldi_s, ADDSUB => addsub_s,
                                           SUB => sub_s, XORS => xor_s, SHR => shr_s, RES => res_s);
  U_REG : entity work.acc_z       port map(CLK => CLK, RESET => RESET, EN => en_s, D => res_s, ACC => acc_s, Z => Z);
  Q <= acc_s; PC <= pc_s;
end struct;
