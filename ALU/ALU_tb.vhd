library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity alu_tb is

end alu_tb;

architecture tb of alu_tb is

	signal A, B : std_logic_vector(31 downto 0);
	signal ALU_Control : std_logic_vector(3 downto 0);
	signal V, N, Z, C : std_logic;
	signal ALU_Result : std_logic_vector(31 downto 0);

begin 
	
	testALU : entity work.alu(behave)
		port map
		(
			A => A,
			B => B,
			ALU_ctrl => ALU_Control,
			overflow => V,
			negative => N,
			zero => Z,
			result => ALU_Result,
			carry => C
		);
		
	process
	begin
	
		-- Test ADD (No Overflow)
		A <= X"7FFFFFFE"; B <= X"00000001"; ALU_Control <= "0000"; 
		
		wait for 10 ns;
		
		assert ALU_Result = x"7FFFFFFF" report "Case 1: Failed (incorrect result)";
		assert V = '0' report "Case 1: Failed (Invalid V flag)";
		assert N = '0' report "Case 1: Failed (Invalid N flag)";
		assert Z = '0' report "Case 1: Failed (Invalid Z flag)";
		assert C = '0' report "Case 1: Failed (Invalid C flag)";
		
		-- ADD Test (Overflow)
		A <= X"7FFFFFFF"; B <= X"00000001"; ALU_Control <= "0000"; 
		
		wait for 10 ns;
		
		assert ALU_Result = x"80000000" report "Case 2: Failed (incorrect result)";
		assert V = '1' report "Case 2: Failed (Invalid V flag)";
		assert N = '1' report "Case 2: Failed (Invalid N flag)";
		assert Z = '0' report "Case 2: Failed (Invalid Z flag)";
		assert C = '0' report "Case 2: Failed (Invalid C flag)";
		
		-- SUB Test (Negative)
		A <= X"00000002"; B <= X"00000003"; ALU_Control <= "0001"; 
		
		wait for 10 ns;
		
		assert ALU_Result = x"FFFFFFFF" report "Case 3: Failed (incorrect result)";
		assert V = '0' report "Case 3: Failed (Invalid V flag)";
		assert N = '1' report "Case 3: Failed (Invalid N flag)";
		assert Z = '0' report "Case 3: Failed (Invalid Z flag)";
		assert C = '0' report "Case 3: Failed (Invalid C flag)";
		
		-- Test Zero Flag
		A <= X"00000005"; B <= X"00000005"; ALU_Control <= "0001"; 
		
		wait for 10 ns;
		
		assert ALU_Result = x"00000000" report "Case 4: Failed (incorrect result)";
		assert V = '0' report "Case 4: Failed (Invalid V flag)";
		assert N = '0' report "Case 4: Failed (Invalid N flag)";
		assert Z = '1' report "Case 4: Failed (Invalid Z flag)";
		assert C = '1' report "Case 4: Failed (Invalid C flag)";
		
		-- AND Test
		A <= X"0000000F"; B <= X"00000007"; ALU_Control <= "0010"; 
		
		wait for 10 ns;
	
		assert ALU_Result = x"00000007" report "Case 5: Failed (incorrect result)";
		assert V = '0' report "Case 5: Failed (Invalid V flag)";
		assert N = '0' report "Case 5: Failed (Invalid N flag)";
		assert Z = '0' report "Case 5: Failed (Invalid Z flag)";
		assert C = '0' report "Case 5: Failed (Invalid C flag)";
		
		-- OR Test
		A <= X"0000000F"; B <= X"00000007"; ALU_Control <= "0011"; 
		
		wait for 10 ns;
		
		assert ALU_Result = x"0000000F" report "Case 6: Failed (incorrect result)";
		assert V = '0' report "Case 6: Failed (Invalid V flag)";
		assert N = '0' report "Case 6: Failed (Invalid N flag)";
		assert Z = '0' report "Case 6: Failed (Invalid Z flag)";
		assert C = '0' report "Case 6: Failed (Invalid C flag)";
	
		-- XOR Test
		A <= X"0000000F"; B <= X"00000007"; ALU_Control <= "0100";

		wait for 10 ns;
		
		assert ALU_Result = x"00000008" report "Case 7: Failed (incorrect result)";
		assert V = '0' report "Case 7: Failed (Invalid V flag)";
		assert N = '0' report "Case 7: Failed (Invalid N flag)";
		assert Z = '0' report "Case 7: Failed (Invalid Z flag)";
		assert C = '0' report "Case 7: Failed (Invalid C flag)";
		
		-- Shift Left Test
        A <= X"00000001"; B <= X"00000002"; ALU_Control <= "0101"; 
		
		wait for 10 ns;
		
		assert ALU_Result = x"00000004" report "Case 8: Failed (incorrect result)";
		assert V = '0' report "Case 8: Failed (Invalid V flag)";
		assert N = '0' report "Case 8: Failed (Invalid N flag)";
		assert Z = '0' report "Case 8: Failed (Invalid Z flag)";
		assert C = '0' report "Case 8: Failed (Invalid C flag)";
		
        -- Shift Right Test
        A <= X"00000008"; B <= X"00000002"; ALU_Control <= "0110"; 
		
		wait for 10 ns;
		
		assert ALU_Result = x"00000002" report "Case 9: Failed (incorrect result)";
		assert V = '0' report "Case 9: Failed (Invalid V flag)";
		assert N = '0' report "Case 9: Failed (Invalid N flag)";
		assert Z = '0' report "Case 9: Failed (Invalid Z flag)";
		assert C = '0' report "Case 9: Failed (Invalid C flag)";
		
        -- SLT Test
        A <= X"FFFFFFF5"; B <= X"00000007"; ALU_Control <= "0111"; 
		
		wait for 10 ns;
		
		assert ALU_Result = x"00000001" report "Case 10: Failed (incorrect result)";
		assert V = '0' report "Case 10: Failed (Invalid V flag)";
		assert N = '0' report "Case 10: Failed (Invalid N flag)";
		assert Z = '0' report "Case 10: Failed (Invalid Z flag)";
		assert C = '0' report "Case 10: Failed (Invalid C flag)";
		
        A <= X"FF000000"; B <= X"F0000000"; ALU_Control <= "0111"; 
		
		wait for 10 ns;
		
		assert ALU_Result = x"00000000" report "Case 11: Failed (incorrect result)";
		assert V = '0' report "Case 11: Failed (Invalid V flag)";
		assert N = '0' report "Case 11: Failed (Invalid N flag)";
		assert Z = '0' report "Case 11: Failed (Invalid Z flag)";
		assert C = '0' report "Case 11: Failed (Invalid C flag)";
		
        -- With overflow 
		
		A <= X"7FFFFFFF"; B <= X"FFFFFFFF"; ALU_Control <= "0111"; 
		
		wait for 10 ns;
		
		assert ALU_Result = x"00000000" report "Case 12: Failed (incorrect result)";
		assert V = '0' report "Case 12: Failed (Invalid V flag)";
		assert N = '0' report "Case 12: Failed (Invalid N flag)";
		assert Z = '0' report "Case 12: Failed (Invalid Z flag)";		
		assert C = '0' report "Case 12: Failed (Invalid C flag)";
		
		-- SLTU Test
        A <= X"FFFFFFF5"; B <= X"00000007"; ALU_Control <= "1000"; 
		
		wait for 10 ns;
		
		assert ALU_Result = x"00000000" report "Case 13: Failed (incorrect result)";
		assert V = '0' report "Case 13: Failed (Invalid V flag)";
		assert N = '0' report "Case 13: Failed (Invalid N flag)";
		assert Z = '0' report "Case 13: Failed (Invalid Z flag)";
		assert C = '0' report "Case 13: Failed (Invalid C flag)";
		
        A <= X"FF000000"; B <= X"F0000000"; ALU_Control <= "1000"; 
		
		wait for 10 ns;
		
		assert ALU_Result = x"00000000" report "Case 14: Failed (incorrect result)";
		assert V = '0' report "Case 14: Failed (Invalid V flag)";
		assert N = '0' report "Case 14: Failed (Invalid N flag)";
		assert Z = '0' report "Case 14: Failed (Invalid Z flag)";
		assert C = '0' report "Case 14: Failed (Invalid C flag)";
        
		A <= X"00000000"; B <= X"FFFFFFFB" ; ALU_Control <= "1000"; 
		
		wait for 10 ns;
		
		assert ALU_Result = x"00000001" report "Case 15: Failed (incorrect result)";
		assert V = '0' report "Case 15: Failed (Invalid V flag)";
		assert N = '0' report "Case 15: Failed (Invalid N flag)";
		assert Z = '0' report "Case 15: Failed (Invalid Z flag)";
		assert C = '0' report "Case 15: Failed (Invalid C flag)";
		
		-- SRA Test 
		A <= X"FFFFFFF8"; B <= X"00000002"; ALU_Control <= "1001";
		
		wait for 10 ns;
		
		assert ALU_Result = x"FFFFFFFE" report "Case 16: Failed (incorrect result)";
		assert V = '0' report "Case 16: Failed (Invalid V flag)";
		assert N = '0' report "Case 16: Failed (Invalid N flag)";
		assert Z = '0' report "Case 16: Failed (Invalid Z flag)";
		assert C = '0' report "Case 16: Failed (Invalid C flag)";
		
		report  "Test Bench Complete";
		wait;
		

		
	end process;

end tb;