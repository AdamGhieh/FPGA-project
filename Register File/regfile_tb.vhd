library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std_unsigned.all;
use ieee.numeric_std.all;

entity regfile_tb is 

end entity;

architecture tb of regfile_tb is

constant ClockFrequency : integer := 100e6; -- 100 MHz
constant ClockPeriod    : time    := 1000 ms / ClockFrequency;

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
	
	Clk <= not Clk after ClockPeriod / 2;
	
	process is
	begin
		
		wait for 1 ns;
		
		RST <= '1';
		wait for 1 ps;
		
		RST <= '0';
		A1 <= "00000";
		A2 <= "00000";
		wait for 10 ns;
		
		RST <= '0';
		WE3 <= '1';
		A1 <= "00110";
		A2 <= "10101";
		A3 <= "00010";
		WD3 <= x"ABCDEF12";
		wait for 10 ns;
		
		RST <= '0';
		WE3 <= '1';
		A1 <= "00010";
		A2 <= "00010";
		A3 <= "00011";
		WD3 <= x"21FEDCBA";
		wait for 10 ns;
		
		RST <= '0';
		WE3 <= '0';
		A1 <= "00010";
		A2 <= "00011";
		A3 <= "00011";
		WD3 <= x"00000000";
		wait for 10 ns;
		
		RST <= '0';
		WE3 <= '1';
		A1 <= "00111";
		A2 <= "11111";
		A3 <= "00000";
		WD3 <= x"FFFFFFFF";
		wait for 10 ns;
		
		RST <= '0';
		WE3 <= '0';
		A1 <= "00000";
		A2 <= "00010";
		A3 <= "00111";
		WD3 <= x"BBBBBBBB";
		wait for 10 ns;
		
		RST <= '1';
		WE3 <= '0';
		A1 <= "10111";
		A2 <= "01110";
		A3 <= "00101";
		WD3 <= x"BCBCDDDC";
		wait for 50 ps;
		
		RST <= '0';
		
		-- Declare end of test and wait indefinitely --
		assert false report "Reached end of test";
		wait;
	end process;

end tb;