library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity control_tb is
end entity;

architecture testbench of control_tb is
	
	signal MemWrite_tb, ALUSrc_tb, RegWrite_tb : std_logic;
	signal ResultSrc_tb, PCSrc_tb : std_logic_vector(1 downto 0);
	signal ALUControl_tb, ImmSrc_tb : std_logic_vector(2 downto 0);
	signal op_tb : std_logic_vector(6 downto 0);
	signal funct3_tb : std_logic_vector(14 downto 12);
	signal funct7_tb : std_logic_vector(6 downto 0);
	signal Zero_tb : std_logic;	
	
begin

	Control : entity work.control(behave)
		port map
		(
			op => op_tb,
			funct3 => funct3_tb,
			funct7 => funct7_tb,
			Zero => Zero_tb,
			MemWrite => MemWrite_tb,
			ALUSrc => ALUSrc_tb,
			RegWrite => RegWrite_tb,
			ResultSrc => ResultSrc_tb,
			PCSrc => PCSrc_tb,
			ALUControl => ALUControl_tb,
			ImmSrc => ImmSrc_tb
		);
	
	process begin
	
		Zero_tb <= '0';
		
		-- Unknown Command --
		op_tb <= "0000000"; funct3_tb <= "000"; funct7_tb <= "0000000"; wait for 10 ns;
		
		assert PCSrc_tb = "00" and ResultSrc_tb = "00" and MemWrite_tb = '0' and ALUControl_tb = "000" and ALUSrc_tb = '0' and ImmSrc_tb = "000" and RegWrite_tb = '0'
		report "Case 1: Failed";
		wait for 10 ns;
		
	---------------------------------------------------------------------------------------------------------------------------------------------------------------------------
		-- ADD --
		op_tb <= "0110011"; funct3_tb <= "000"; funct7_tb <= "0000000"; wait for 10 ns;
		
		assert PCSrc_tb = "00" and ResultSrc_tb = "00" and MemWrite_tb = '0' and ALUControl_tb = "000" and ALUSrc_tb = '0' and ImmSrc_tb = "111" and RegWrite_tb = '1'
		report "Case 2: Failed";
		wait for 10 ns;
		
		-- SUB --
		op_tb <= "0110011"; funct3_tb <= "000"; funct7_tb <= "0100000"; wait for 10 ns;
		
		assert PCSrc_tb = "00" and ResultSrc_tb = "00" and MemWrite_tb = '0' and ALUControl_tb = "001" and ALUSrc_tb = '0' and ImmSrc_tb = "111" and RegWrite_tb = '1'
		report "Case 3: Failed";
		wait for 10 ns;
		
		-- AND --
		op_tb <= "0110011"; funct3_tb <= "111"; funct7_tb <= "0000000"; wait for 10 ns;
		
		assert PCSrc_tb = "00" and ResultSrc_tb = "00" and MemWrite_tb = '0' and ALUControl_tb = "010" and ALUSrc_tb = '0' and ImmSrc_tb = "111" and RegWrite_tb = '1'
		report "Case 4: Failed";
		wait for 10 ns;
		
		-- OR --
		op_tb <= "0110011"; funct3_tb <= "110"; funct7_tb <= "0000000"; wait for 10 ns;
		
		assert PCSrc_tb = "00" and ResultSrc_tb = "00" and MemWrite_tb = '0' and ALUControl_tb = "011" and ALUSrc_tb = '0' and ImmSrc_tb = "111" and RegWrite_tb = '1'
		report "Case 5: Failed";
		wait for 10 ns;
		
		-- XOR --
		op_tb <= "0110011"; funct3_tb <= "100"; funct7_tb <= "0000000"; wait for 10 ns;
		
		assert PCSrc_tb = "00" and ResultSrc_tb = "00" and MemWrite_tb = '0' and ALUControl_tb = "100" and ALUSrc_tb = '0' and ImmSrc_tb = "111" and RegWrite_tb = '1'
		report "Case 6: Failed";
		wait for 10 ns;
		
		-- SLL --
		op_tb <= "0110011"; funct3_tb <= "001"; funct7_tb <= "0000000"; wait for 10 ns;
		
		assert PCSrc_tb = "00" and ResultSrc_tb = "00" and MemWrite_tb = '0' and ALUControl_tb = "101" and ALUSrc_tb = '0' and ImmSrc_tb = "111" and RegWrite_tb = '1'
		report "Case 7: Failed";
		wait for 10 ns;
		
		-- SRL --
		op_tb <= "0110011"; funct3_tb <= "101"; funct7_tb <= "0000000"; wait for 10 ns;
		
		assert PCSrc_tb = "00" and ResultSrc_tb = "00" and MemWrite_tb = '0' and ALUControl_tb = "110" and ALUSrc_tb = '0' and ImmSrc_tb = "111" and RegWrite_tb = '1'
		report "Case 8: Failed";
		wait for 10 ns;
		
		-- SLT --
		op_tb <= "0110011"; funct3_tb <= "010"; funct7_tb <= "0000000"; wait for 10 ns;
		
		assert PCSrc_tb = "00" and ResultSrc_tb = "00" and MemWrite_tb = '0' and ALUControl_tb = "111" and ALUSrc_tb = '0' and ImmSrc_tb = "111" and RegWrite_tb = '1'
		report "Case 9: Failed";
		wait for 10 ns;

	---------------------------------------------------------------------------------------------------------------------------------------------------------------------------
		-- LW --
		op_tb <= "0000011"; funct3_tb <= "010"; wait for 10 ns;
		
		assert PCSrc_tb = "00" and ResultSrc_tb = "01" and MemWrite_tb = '0' and ALUControl_tb = "000" and ALUSrc_tb = '1' and ImmSrc_tb = "000" and RegWrite_tb = '1'
		report "Case 10: Failed";
		wait for 10 ns;
		
		-- JALR --
		op_tb <= "1100111"; funct3_tb <= "000"; wait for 10 ns;
		
		assert PCSrc_tb = "10" and ResultSrc_tb = "10" and MemWrite_tb = '0' and ALUControl_tb = "000" and ALUSrc_tb = '1' and ImmSrc_tb = "000" and RegWrite_tb = '1'
		report "Case 11: Failed";
		wait for 10 ns;
		
		-- ADDI --
		op_tb <= "0010011"; funct3_tb <= "000"; wait for 10 ns;
		
		assert PCSrc_tb = "00" and ResultSrc_tb = "00" and MemWrite_tb = '0' and ALUControl_tb = "000" and ALUSrc_tb = '1' and ImmSrc_tb = "000" and RegWrite_tb = '1'
		report "Case 12: Failed";
		wait for 10 ns;
		
		-- ANDI --
		op_tb <= "0010011"; funct3_tb <= "111"; wait for 10 ns;
		
		assert PCSrc_tb = "00" and ResultSrc_tb = "00" and MemWrite_tb = '0' and ALUControl_tb = "010" and ALUSrc_tb = '1' and ImmSrc_tb = "000" and RegWrite_tb = '1'
		report "Case 13: Failed";
		wait for 10 ns;
		
		-- SLLI --
		op_tb <= "0010011"; funct3_tb <= "001"; wait for 10 ns;
		
		assert PCSrc_tb = "00" and ResultSrc_tb = "00" and MemWrite_tb = '0' and ALUControl_tb = "101" and ALUSrc_tb = '1' and ImmSrc_tb = "000" and RegWrite_tb = '1'
		report "Case 14: Failed";
		wait for 10 ns;
		
		-- SRLI --
		op_tb <= "0010011"; funct3_tb <= "101"; wait for 10 ns;
		
		assert PCSrc_tb = "00" and ResultSrc_tb = "00" and MemWrite_tb = '0' and ALUControl_tb = "110" and ALUSrc_tb = '1' and ImmSrc_tb = "000" and RegWrite_tb = '1'
		report "Case 15: Failed";
		wait for 10 ns;
		
		-- SLTI --
		op_tb <= "0010011"; funct3_tb <= "010"; wait for 10 ns;
		
		assert PCSrc_tb = "00" and ResultSrc_tb = "00" and MemWrite_tb = '0' and ALUControl_tb = "111" and ALUSrc_tb = '1' and ImmSrc_tb = "000" and RegWrite_tb = '1'
		report "Case 16: Failed";
		wait for 10 ns;
		
	---------------------------------------------------------------------------------------------------------------------------------------------------------------------------
		-- BEQ (Zero = 0) --
		op_tb <= "1100011"; funct3_tb <= "000"; Zero_tb <= '0'; wait for 10 ns;
		
		assert PCSrc_tb = "00" and ResultSrc_tb = "00" and MemWrite_tb = '0' and ALUControl_tb = "001" and ALUSrc_tb = '0' and ImmSrc_tb = "010" and RegWrite_tb = '0'
		report "Case 17: Failed";
		wait for 10 ns;
		
		-- BEQ (Zero = 1)  --
		op_tb <= "1100011"; funct3_tb <= "000"; Zero_tb <= '1'; wait for 10 ns;
		
		assert PCSrc_tb = "01" and ResultSrc_tb = "00" and MemWrite_tb = '0' and ALUControl_tb = "001" and ALUSrc_tb = '0' and ImmSrc_tb = "010" and RegWrite_tb = '0'
		report "Case 18: Failed";
		wait for 10 ns;
		
		-- BNE (Zero = 0) --
		op_tb <= "1100011"; funct3_tb <= "001"; Zero_tb <= '0'; wait for 10 ns;
		
		assert PCSrc_tb = "01" and ResultSrc_tb = "00" and MemWrite_tb = '0' and ALUControl_tb = "001" and ALUSrc_tb = '0' and ImmSrc_tb = "010" and RegWrite_tb = '0'
		report "Case 19: Failed";
		wait for 10 ns;
		
		-- BNE (Zero = 1)  --
		op_tb <= "1100011"; funct3_tb <= "001"; Zero_tb <= '1'; wait for 10 ns;
		
		assert PCSrc_tb = "00" and ResultSrc_tb = "00" and MemWrite_tb = '0' and ALUControl_tb = "001" and ALUSrc_tb = '0' and ImmSrc_tb = "010" and RegWrite_tb = '0'
		report "Case 20: Failed";
		wait for 10 ns;
	---------------------------------------------------------------------------------------------------------------------------------------------------------------------------	

		-- SW --
		op_tb <= "0100011"; funct3_tb <= "010"; wait for 10 ns;
		
		assert PCSrc_tb = "00" and ResultSrc_tb = "00" and MemWrite_tb = '1' and ALUControl_tb = "000" and ALUSrc_tb = '1' and ImmSrc_tb = "001" and RegWrite_tb = '0'
		report "Case 21: Failed";
		wait for 10 ns;
		
	---------------------------------------------------------------------------------------------------------------------------------------------------------------------------

		-- JAL --
		op_tb <= "1101111"; wait for 10 ns;
		
		assert PCSrc_tb = "01" and ResultSrc_tb = "10" and MemWrite_tb = '0' and ALUControl_tb = "000" and ALUSrc_tb = '0' and ImmSrc_tb = "100" and RegWrite_tb = '1'
		report "Case 22: Failed";
		wait for 10 ns;
		
	---------------------------------------------------------------------------------------------------------------------------------------------------------------------------

		-- LUI --
		op_tb <= "0110111"; wait for 10 ns;
		
		assert PCSrc_tb = "00" and ResultSrc_tb = "11" and MemWrite_tb = '0' and ALUControl_tb = "000" and ALUSrc_tb = '0' and ImmSrc_tb = "011" and RegWrite_tb = '1'
		report "Case 23: Failed";
		wait;
	
	end process;
end testbench;