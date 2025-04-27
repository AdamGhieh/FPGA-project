library IEEE;
use IEEE.STD_LOGIC_1164.all;
use IEEE.NUMERIC_STD.all;
 
entity dmem_tb is

end entity;


architecture tb of dmem_tb is

	signal clk, we, datatype, rst : std_logic := '0';
	signal a, wd, rd : std_logic_vector(31 downto 0) := (others => '0');
	signal datasize : std_logic_vector(1 downto 0) := (others => '0');
	
	constant ClockFrequency : integer := 100e6; -- 100 MHz
	constant clk_period : time    := 1000 ms / ClockFrequency;
begin 

	memory : entity work.dmem(behave)
		port map
		(
			clk => clk,
			we => we,
			datatype => datatype,
			reset => rst,
			a => a,
			wd => wd,
			rd => rd,
			datasize => datasize
		);
		
	Clk <= not Clk after clk_period / 2;
		
	process
	begin
		
		rst <= '1';
		wait for clk_period;
		
		rst <= '0';
		
		-- Write word to address 0x04 --
		a <= x"00000004";
		wd <= x"12345678";
		we <= '1';
		
		wait for clk_period;
		
		we <= '0';
		
		wait for clk_period;
		assert RD = x"12345678" report "Case 1: Failed";
		
		-- Enable off, try to write word -- 
		a <= x"00000008";
		wd <= x"DEADBEEF";
		
		wait for clk_period;
		
		assert rd /= x"DEADBEEF" report "Case 2: Failed";
		
		-- Write half-word to address 0x40 --
		a <= x"00000040";
		wd <= x"1212EFEF";
		datasize <= "01";
		we <= '1';
		
		wait for clk_period;
		
		-- Write half-word to address 0x42 --
		a <= x"00000042";
		wd <= x"EFEF1212";
		datasize <= "01";
		we <= '1';
		
		wait for clk_period;
		
		-- Read address 0x40 as signed -- 
		we <= '0';
		a <= x"00000040";
		datatype <= '0';
		
		wait for clk_period;
		assert RD = x"FFFFEFEF" report "Case 3: Failed";
		
		-- Read address 0x40 as unsigned --
		datatype <= '1';
		
		wait for clk_period;
		assert RD = x"0000EFEF" report "Case 4: Failed";
		
		
		
		-- Read address 0x42 as signed --
		a <= x"00000042";
		datatype <= '0';
		
		wait for clk_period;
		assert RD = x"00001212" report "Case 5: Failed";
		
		-- Read address 0x42 as unsigned --
		datatype <= '1';
		
		wait for clk_period;
		assert RD = x"00001212" report "Case 6: Failed";
		
		
		-- Write bytes to addresses from 0x50 to 0x54 --
		we <= '1';
		a <= x"00000050";
		datasize <= "10";
		wd <= x"FFFF0040";
		
		wait for clk_period;
		a <= x"00000051";
		wd <= x"FFFF0041";

		wait for clk_period;
		a <= x"00000052";
		wd <= x"FFFF0042";		

		wait for clk_period;
		a <= x"00000053";
		wd <= x"FFFF0043";

		wait for clk_period;
		a <= x"00000054";
		wd <= x"FFFF0044";
		
		wait for clk_period;
		
		we <= '0';
		datatype <= '0';
		
		-- Read bytes from 0x50 to 0x54 as unsigned --
		
		a <= x"00000050";
		wait for clk_period;
		assert rd = x"00000040" report "Case 7: Failed";
		
		
		a <= x"00000051";
		wait for clk_period;
		assert rd = x"00000041" report "Case 8: Failed";
		
		
		a <= x"00000052";
		wait for clk_period;
		assert rd = x"00000042" report "Case 9: Failed";
		
		
		a <= x"00000053";
		wait for clk_period;
		assert rd = x"00000043" report "Case 10: Failed";
		
		
		a <= x"00000054";
		wait for clk_period;
		assert rd = x"00000044" report "Case 11: Failed";
		
		
		a <= x"00000005";
		
		wait for clk_period;
		assert rd = x"00000056" report "Case 12: Failed";
		
		report "Test bench complete.";
		wait;
	end process;
end architecture; 