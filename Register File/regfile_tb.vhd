library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std_unsigned.all;
use ieee.numeric_std.all;

entity regfile_tb is 

end entity;

architecture tb of regfile_tb is

constant ClockFrequency : integer := 100e6; -- 100 MHz
constant clk_period : time    := 1000 ms / ClockFrequency;

signal Clk : std_logic := '0';
signal WE3 : std_logic := '0';
signal RST : std_logic := '0';
signal WD3 : std_logic_vector(31 downto 0) := x"00000000";
signal RD1 : std_logic_vector(31 downto 0) := x"00000000";
signal RD2 : std_logic_vector(31 downto 0) := x"00000000";
signal A1 : std_logic_vector(4 downto 0) := "00000";
signal A2 : std_logic_vector(4 downto 0) := "00000";
signal A3 : std_logic_vector(4 downto 0) := "00000";

begin
	
	REG_FILE : entity work.regfile(behave)
		port map 
		(
			Clk => Clk,
			WE3 => WE3,
			RST => RST,
			WD3 => WD3,
			RD1 => RD1,
			RD2 => RD2,
			A1 => A1,
			A2 => A2,
			A3 => A3
		);
	
	Clk <= not Clk after clk_period / 2;
	
-- Test process
stim_process : PROCESS
BEGIN
    -- Case 1: Initialize clock, reset, and control signals
    RST  <= '1';
    WE3  <= '0';
    WD3  <= (others => '0');
    A1   <= (others => '0');
    A2   <= (others => '0');
    A3   <= (others => '0');
    WAIT FOR clk_period;

    ASSERT RD1 = x"00000000" AND RD2 = x"00000000" REPORT "Case 1: FAIL" SEVERITY ERROR;

    -- Disable clear
    RST  <= '0';
    WAIT FOR clk_period;

    -- Case 2: Write disabled, attempt write
    WE3  <= '0';
    A3   <= "00100";  -- Register 4
    WD3  <= x"0ABCDEF0";
    A2   <= "00100";
    WAIT FOR clk_period;
    ASSERT RD2 /= x"0ABCDEF0" REPORT "Case 2: FAIL" SEVERITY ERROR;

    -- Case 3: Write enabled, write to register 4
    WE3  <= '1';
    WAIT FOR clk_period;
    ASSERT RD2 = x"0ABCDEF0" REPORT "Case 3: FAIL" SEVERITY ERROR;

    -- Case 4: Read back register 4
    A1   <= "00100";
    WAIT FOR clk_period;
    ASSERT RD1 = x"0ABCDEF0" REPORT "Case 4: FAIL" SEVERITY ERROR;

    -- Case 5: Write to register 1 and read back
    A3   <= "00001";
    WD3  <= x"DEADBEEF";
    WAIT FOR clk_period;
    A1   <= "00001";
    WAIT FOR clk_period;
    ASSERT RD1 = x"DEADBEEF" REPORT "Case 5: FAIL" SEVERITY ERROR;

    -- Case 6: Attempt write to register 0
    A3   <= "00000";
    WD3  <= x"FFFFFFFF";
    WAIT FOR clk_period;
    A1   <= "00000";
    WAIT FOR clk_period;
    ASSERT RD1 /= x"FFFFFFFF" REPORT "Case 6: FAIL" SEVERITY ERROR;

    -- Case 7: Read multiple registers while writing another
    A1   <= "00001";
    A2   <= "00100";
    A3   <= "01010";
    WD3  <= x"12345678";
    WAIT FOR clk_period;
    ASSERT RD1 = x"DEADBEEF" AND RD2 = x"0ABCDEF0" REPORT "Case 7: FAIL" SEVERITY ERROR;

    -- Case 8: Write to the same register twice
    A3   <= "00010";
    WD3  <= x"AAAA5555";
    WAIT FOR clk_period;
    WD3  <= x"5555AAAA";
    WAIT FOR clk_period;
    A1   <= "00010";
    WAIT FOR clk_period;
    ASSERT RD1 = x"5555AAAA" REPORT "Case 8: FAIL" SEVERITY ERROR;

    -- Case 9: Immediate read after write
    A3   <= "00011";
    WD3  <= x"CAFEBABE";
    WAIT FOR clk_period;
    A1   <= "00011";
    WAIT FOR clk_period;
    ASSERT RD1 = x"CAFEBABE" REPORT "Case 9: FAIL (No write-through or delay)" SEVERITY ERROR;

    -- Case 10: Read two different registers
    A1   <= "00001";
    A2   <= "00011";
    WAIT FOR clk_period;
    ASSERT RD1 = x"DEADBEEF" AND RD2 = x"CAFEBABE" REPORT "Case 10: FAIL" SEVERITY ERROR;

    -- Case 11: Disable write, attempt write, verify no change
    WE3  <= '0';
    A3   <= "00101";
    WD3  <= x"BEEFBEEF";
    WAIT FOR clk_period;
    A1   <= "00101";
    WAIT FOR clk_period;
    ASSERT RD1 /= x"BEEFBEEF" REPORT "Case 11: FAIL" SEVERITY ERROR;

    -- Case 12: Reset after writing
    WE3  <= '1';
    A3   <= "00110";
    WD3  <= x"11223344";
    WAIT FOR clk_period;
    RST  <= '1';
    WAIT FOR clk_period;
    RST  <= '0';
    A1   <= "00110";
    WAIT FOR clk_period;
    ASSERT RD1 = x"00000000" REPORT "Case 12: FAIL" SEVERITY ERROR;

    REPORT "Testbench completed successfully." SEVERITY NOTE;
    WAIT;
END PROCESS;

end tb;