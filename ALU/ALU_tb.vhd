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
		A <= X"7FFFFFFE"; B <= X"00000001"; ALU_Control <= "000"; 
		
		wait for 10 ns;
		
		assert ALU_Result = x"7FFFFFFF" report "Case 1: Failed (incorrect result)";
		assert V = '0' report "Case 1: Failed (Invalid V flag)";
		assert N = '0' report "Case 1: Failed (Invalid N flag)";
		assert Z = '0' report "Case 1: Failed (Invalid Z flag)";
		
		
		-- ADD Test (Overflow)
		A <= X"7FFFFFFF"; B <= X"00000001"; ALU_Control <= "000"; 
		
		wait for 10 ns;
		
		assert ALU_Result = x"80000000" report "Case 2: Failed (incorrect result)";
		assert V = '1' report "Case 2: Failed (Invalid V flag)";
		assert N = '1' report "Case 2: Failed (Invalid N flag)";
		assert Z = '0' report "Case 2: Failed (Invalid Z flag)";
		
		
		-- SUB Test (Negative)
		A <= X"00000002"; B <= X"00000003"; ALU_Control <= "001"; 
		
		wait for 10 ns;
		
		assert ALU_Result = x"FFFFFFFF" report "Case 3: Failed (incorrect result)";
		assert V = '0' report "Case 3: Failed (Invalid V flag)";
		assert N = '1' report "Case 3: Failed (Invalid N flag)";
		assert Z = '0' report "Case 3: Failed (Invalid Z flag)";
		
		
		-- Test Zero Flag
		A <= X"00000005"; B <= X"00000005"; ALU_Control <= "001"; 
		
		wait for 10 ns;
		
		assert ALU_Result = x"00000000" report "Case 4: Failed (incorrect result)";
		assert V = '0' report "Case 4: Failed (Invalid V flag)";
		assert N = '0' report "Case 4: Failed (Invalid N flag)";
		assert Z = '1' report "Case 4: Failed (Invalid Z flag)";
		
		
		-- AND Test
		A <= X"0000000F"; B <= X"00000007"; ALU_Control <= "010"; 
		
		wait for 10 ns;
	
		assert ALU_Result = x"00000007" report "Case 5: Failed (incorrect result)";
		assert V = '0' report "Case 5: Failed (Invalid V flag)";
		assert N = '0' report "Case 5: Failed (Invalid N flag)";
		assert Z = '0' report "Case 5: Failed (Invalid Z flag)";
		
		
		-- OR Test
		A <= X"0000000F"; B <= X"00000007"; ALU_Control <= "011"; 
		
		wait for 10 ns;
		
		assert ALU_Result = x"0000000F" report "Case 6: Failed (incorrect result)";
		assert V = '0' report "Case 6: Failed (Invalid V flag)";
		assert N = '0' report "Case 6: Failed (Invalid N flag)";
		assert Z = '0' report "Case 6: Failed (Invalid Z flag)";
	
	
		-- XOR Test
		A <= X"0000000F"; B <= X"00000007"; ALU_Control <= "100";

		wait for 10 ns;
		
		assert ALU_Result = x"00000008" report "Case 7: Failed (incorrect result)";
		assert V = '0' report "Case 7: Failed (Invalid V flag)";
		assert N = '0' report "Case 7: Failed (Invalid N flag)";
		assert Z = '0' report "Case 7: Failed (Invalid Z flag)";
		
		
		-- Shift Left Test
        A <= X"00000001"; B <= X"00000002"; ALU_Control <= "101"; 
		
		wait for 10 ns;
		
		assert ALU_Result = x"00000004" report "Case 8: Failed (incorrect result)";
		assert V = '0' report "Case 8: Failed (Invalid V flag)";
		assert N = '0' report "Case 8: Failed (Invalid N flag)";
		assert Z = '0' report "Case 8: Failed (Invalid Z flag)";
		
		
        -- Shift Right Test
        A <= X"00000008"; B <= X"00000002"; ALU_Control <= "110"; 
		
		wait for 10 ns;
		
		assert ALU_Result = x"00000002" report "Case 9: Failed (incorrect result)";
		assert V = '0' report "Case 9: Failed (Invalid V flag)";
		assert N = '0' report "Case 9: Failed (Invalid N flag)";
		assert Z = '0' report "Case 9: Failed (Invalid Z flag)";
		
		
        -- SLT Test
        A <= X"00000005"; B <= X"00000007"; ALU_Control <= "111"; 
		
		wait for 10 ns;
		
		assert ALU_Result = x"00000001" report "Case 10: Failed (incorrect result)";
		assert V = '0' report "Case 10: Failed (Invalid V flag)";
		assert N = '0' report "Case 10: Failed (Invalid N flag)";
		assert Z = '0' report "Case 10: Failed (Invalid Z flag)";
		
		report  "Test Bench Complete";
		wait;
		
	end process;

end tb;