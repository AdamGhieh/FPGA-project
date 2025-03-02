library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity alu_tb is

end alu_tb;

architecture tb of alu_tb is

	signal A, B : std_logic_vector(31 downto 0);
	signal ALU_Control : std_logic_vector(2 downto 0);
	signal V, N, Z : std_logic;
	signal ALU_Result : std_logic_vector(31 downto 0);

begin 
	
	ALU : entity work.alu(behave)
		port map
		(
			A => A,
			B => B,
			ALU_Control => ALU_Control,
			V => V,
			N => N,
			Z => Z,
			ALU_Result => ALU_Result
		);
		
	process
	begin
	
		-- Test ADD (No Overflow)
		A <= X"7FFFFFFE"; B <= X"00000001"; ALU_Control <= "000"; wait for 10 ns;
		
		-- ADD Test (Overflow)
		A <= X"7FFFFFFF"; B <= X"00000001"; ALU_Control <= "000"; wait for 10 ns;
		
		-- SUB Test (Negative)
		A <= X"00000002"; B <= X"00000003"; ALU_Control <= "001"; wait for 10 ns;
		
		-- Test Zero Flag
		A <= X"00000005"; B <= X"00000005"; ALU_Control <= "001"; wait for 10 ns;
		
		-- AND Test
		A <= X"0000000F"; B <= X"00000007"; ALU_Control <= "010"; wait for 10 ns;
		
		-- OR Test
		A <= X"0000000F"; B <= X"00000007"; ALU_Control <= "011"; wait for 10 ns;
		
		-- XOR Test
		A <= X"0000000F"; B <= X"00000007"; ALU_Control <= "100"; wait for 10 ns;
		
		-- Shift Left Test
        A <= X"00000001"; B <= X"00000002"; ALU_Control <= "101"; wait for 10 ns;

        -- Shift Right Test
        A <= X"00000008"; B <= X"00000002"; ALU_Control <= "110"; wait for 10 ns;

        -- SLT Test
        A <= X"00000005"; B <= X"00000007"; ALU_Control <= "111"; wait for 10 ns;

		assert false report "Complete";
		wait;
		
	end process;

end tb;