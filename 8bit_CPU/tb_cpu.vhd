library IEEE; use IEEE.STD_LOGIC_1164.ALL;
entity tb_cpu is end tb_cpu;
architecture sim of tb_cpu is
  -- VHDL-93 e hex nai, tai nijer hex function
  function hex(v : std_logic_vector) return string is
    variable r : string(1 to (v'length + 3) / 4);
    variable p : std_logic_vector(1 to ((v'length + 3) / 4) * 4) := (others => '0');
    variable n : std_logic_vector(3 downto 0);
  begin
    p(p'length - v'length + 1 to p'length) := v;
    for i in r'range loop
      n := p(4*i-3 to 4*i);
      case n is
        when "0000" => r(i) := '0'; when "0001" => r(i) := '1'; when "0010" => r(i) := '2'; when "0011" => r(i) := '3';
        when "0100" => r(i) := '4'; when "0101" => r(i) := '5'; when "0110" => r(i) := '6'; when "0111" => r(i) := '7';
        when "1000" => r(i) := '8'; when "1001" => r(i) := '9'; when "1010" => r(i) := 'A'; when "1011" => r(i) := 'B';
        when "1100" => r(i) := 'C'; when "1101" => r(i) := 'D'; when "1110" => r(i) := 'E'; when "1111" => r(i) := 'F';
        when others => r(i) := 'X';
      end case;
    end loop;
    return r;
  end function;
  signal CLK : std_logic := '0';
  signal RESET : std_logic := '1';
  signal Q : std_logic_vector(7 downto 0);
  signal Z : std_logic;
  signal PC : std_logic_vector(3 downto 0);
  type arr8 is array (0 to 7) of std_logic_vector(7 downto 0);
  -- Appendix B Set 3 er expected ACC (cycle 0..7)
  constant EXP_ACC : arr8 := (x"00",x"80",x"40",x"30",x"3F",x"00",x"07",x"03");
  constant EXP_Z   : std_logic_vector(0 to 7) := "10000100";
begin
  DUT : entity work.cpu port map(CLK, RESET, Q, Z, PC);
  CLK <= not CLK after 5 ns;
  process begin
    -- cycle 0: RESET = 1 for one rising edge
    wait until rising_edge(CLK); wait for 1 ns;
    RESET <= '0';
    assert Q = EXP_ACC(0) and Z = EXP_Z(0) report "RESET FAIL" severity error;
    report "Cycle 0 RESET  ACC=" & hex(Q) & " Z=" & std_logic'image(Z) & " PC=" & hex(PC);
    for i in 1 to 7 loop
      wait until rising_edge(CLK); wait for 1 ns;
      report "Cycle " & integer'image(i) & "  ACC=" & hex(Q) & " Z=" & std_logic'image(Z) & " PC(next)=" & hex(PC);
      assert Q = EXP_ACC(i) and Z = EXP_Z(i) report "MISMATCH at cycle " & integer'image(i) severity error;
    end loop;
    report "SIMULATION FINISHED";
    wait;
  end process;
end sim;
