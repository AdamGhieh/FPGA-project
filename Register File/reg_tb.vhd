library ieee;
use ieee.std_logic_1164.all;

entity reg_tb is

end reg_tb;

architecture tb of reg_tb is

constant ClockFrequency : integer := 100e6; -- 100 MHz
constant ClockPeriod    : time    := 1000 ms / ClockFrequency;

signal DATA, STORED_VALUE : std_logic_vector(31 downto 0);
signal EN, R : std_ulogic;
signal Clk : std_ulogic := '1';

begin 
	REG : entity work.REG(rtl)
		generic map
		(
			INPUT_SIZE => 32
		)
		
		port map
		(
				DATA => DATA,
				STORED_VALUE => STORED_VALUE,
				EN => EN,
				Clk => Clk,
				R => R
		);
		
	Clk <= not Clk after ClockPeriod / 2;
	
	process is
	begin
		DATA <= x"AAAAAAAA";
		EN <= '1';
		R <= '1';
		wait for 10 ns;
		
		DATA <= x"A0C8098B";
		EN <= '1';
		R <= '0';
		wait for 10 ns;
		
		DATA <= x"0DF9A000";
		EN <= '1';
		R <= '0';
		wait for 10 ns;
		
		DATA <= x"EE94D876";
		EN <= '0';
		R <= '0';
		wait for 10 ns;
		
		DATA <= x"EE94D876";
		EN <= '1';
		R <= '0';
		wait for 10 ns;
		
		DATA <= x"FFFFFFFF";
		EN <= '1';
		R <= '1';
		wait for 10 ns;
		
		DATA <= x"FFFFFFFF";
		EN <= '1';
		R <= '0';
		wait for 10 ns;
		
		DATA <= "XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX";
		EN <= 'X';
		R <= '1';
		wait for 10 ns;
		
		DATA <= x"00000000";
		EN <= '0';
		R <= '0';
		wait for 10 ns;
		
		-- Declare end of test and wait indefinitely --
		assert false report "Reached end of test";
		wait;
		
	end process;
end tb;