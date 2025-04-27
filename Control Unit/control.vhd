library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity control is
	port
	(
		-- Input buses --
		op : in std_logic_vector(6 downto 0);
		funct3 : in std_logic_vector(14 downto 12);
		funct7 : in std_logic_vector(6 downto 0);
		Zero, Negative, Carry, Overflow : in std_logic;
		
		-- Output buses --
		MemWrite, ALUSrc, RegWrite, DataType : out std_logic;
		PCSrc, DataSize : out std_logic_vector(1 downto 0);
		ImmSrc, ResultSrc : out std_logic_vector(2 downto 0);
		ALUControl : out std_logic_vector(3 downto 0)
	);
end control;

architecture behave of control is

	signal MemWrite1, ALUSrc1, RegWrite1, DataType1 : std_logic;
	signal PCSrc1, DataSize1 : std_logic_vector(1 downto 0);
	signal ImmSrc1, ResultSrc1 : std_logic_vector(2 downto 0);
	signal ALUControl1 : std_logic_vector(3 downto 0);

begin

	process(op, funct3, funct7, Zero, Carry, Negative, Overflow)
	begin
	
	---------------------------------------------------------------------------------------
	
		-- R-Type Instructions --
		if op = "0110011" and funct3 = "000" and funct7 = "0000000" then	-- ADD --
		
			PCSrc1 <= "00";
			ResultSrc1 <= "000";
			MemWrite1 <= '0';
			ALUControl1 <= "0000";
			ALUSrc1 <= '0';
			ImmSrc1 <= "111"; 	-- Set Invalid Type so that Extend unit outputs 0s 
			RegWrite1 <= '1';
			DataType1 <= '0';
			DataSize1 <= "00";
			
		elsif op = "0110011" and funct3 = "000" and funct7 = "0100000" then	-- SUB --
		
			PCSrc1 <= "00";
			ResultSrc1 <= "000";
			MemWrite1 <= '0';
			ALUControl1 <= "0001";
			ALUSrc1 <= '0';
			ImmSrc1 <= "111";	-- Set Invalid Type so that Extend unit outputs 0s 
			RegWrite1 <= '1';
			DataType1 <= '0';
			DataSize1 <= "00";
	
		elsif op = "0110011" and funct3 = "111" and funct7 = "0000000" then -- AND -- 
		
			PCSrc1 <= "00";
			ResultSrc1 <= "000";
			MemWrite1 <= '0';
			ALUControl1 <= "0010";
			ALUSrc1 <= '0';
			ImmSrc1 <= "111";	-- Set Invalid Type so that Extend unit outputs 0s 
			RegWrite1 <= '1';
			DataType1 <= '0';
			DataSize1 <= "00";
		
		elsif op = "0110011" and funct3 = "110" and funct7 = "0000000" then -- OR --
		
			PCSrc1 <= "00";
			ResultSrc1 <= "000";
			MemWrite1 <= '0';
			ALUControl1 <= "0011";
			ALUSrc1 <= '0';
			ImmSrc1 <= "111";	-- Set Invalid Type so that Extend unit outputs 0s 
			RegWrite1 <= '1';
			DataType1 <= '0';
			DataSize1 <= "00";
		
		elsif op = "0110011" and funct3 = "100" and funct7 = "0000000" then -- XOR --
		
			PCSrc1 <= "00";
			ResultSrc1 <= "000";
			MemWrite1 <= '0';
			ALUControl1 <= "0100";
			ALUSrc1 <= '0';
			ImmSrc1 <= "111";	-- Set Invalid Type so that Extend unit outputs 0s 
			RegWrite1 <= '1';
			DataType1 <= '0';
			DataSize1 <= "00";
		
		elsif op = "0110011" and funct3 = "001" and funct7 = "0000000" then -- SLL --
		
			PCSrc1 <= "00";
			ResultSrc1 <= "000";
			MemWrite1 <= '0';
			ALUControl1 <= "0101";
			ALUSrc1 <= '0';
			ImmSrc1 <= "111";	-- Set Invalid Type so that Extend unit outputs 0s 
			RegWrite1 <= '1';
			DataType1 <= '0';
			DataSize1 <= "00";
	
		elsif op = "0110011" and funct3 = "101" and funct7 = "0000000" then -- SRL --
		
			PCSrc1 <= "00";
			ResultSrc1 <= "000";
			MemWrite1 <= '0';
			ALUControl1 <= "0110";
			ALUSrc1 <= '0';
			ImmSrc1 <= "111";	-- Set Invalid Type so that Extend unit outputs 0s 
			RegWrite1 <= '1';
			DataType1 <= '0';
			DataSize1 <= "00";
		
		elsif op = "0110011" and funct3 = "010" and funct7 = "0000000" then -- SLT --
		
			PCSrc1 <= "00";
			ResultSrc1 <= "000";
			MemWrite1 <= '0';
			ALUControl1 <= "0111";
			ALUSrc1 <= '0';
			ImmSrc1 <= "111";	-- Set Invalid Type so that Extend unit outputs 0s 
			RegWrite1 <= '1';
			DataType1 <= '0';
			DataSize1 <= "00";
			
		elsif op = "0110011" and funct3 = "101" and funct7 = "0100000" then -- SRA --
		
			PCSrc1 <= "00";
			ResultSrc1 <= "000";
			MemWrite1 <= '0';
			ALUControl1 <= "1001";
			ALUSrc1 <= '0';
			ImmSrc1 <= "111";	-- Set Invalid Type so that Extend unit outputs 0s 
			RegWrite1 <= '1';
			DataType1 <= '0';
			DataSize1 <= "00";
			
		elsif op = "0110011" and funct3 = "011" and funct7 = "0000000" then -- SLTU --
		
			PCSrc1 <= "00";
			ResultSrc1 <= "000";
			MemWrite1 <= '0';
			ALUControl1 <= "1000";
			ALUSrc1 <= '0';
			ImmSrc1 <= "111";	-- Set Invalid Type so that Extend unit outputs 0s 
			RegWrite1 <= '1';
			DataType1 <= '0';
			DataSize1 <= "00";
	
	
	---------------------------------------------------------------------------------------
	
		-- I-Type Instructions -- 
		elsif op = "0000011" and funct3 = "010" then						-- LW --
		
			PCSrc1 <= "00";
			ResultSrc1 <= "001";
			MemWrite1 <= '0';
			ALUControl1 <= "0000";
			ALUSrc1 <= '1';
			ImmSrc1 <= "000"; 
			RegWrite1 <= '1';
			DataType1 <= '0';
			DataSize1 <= "00";
		
		elsif op = "0000011" and funct3 = "000" then						-- LB --
		
			PCSrc1 <= "00";
			ResultSrc1 <= "001";
			MemWrite1 <= '0';
			ALUControl1 <= "0000";
			ALUSrc1 <= '1';
			ImmSrc1 <= "000"; 
			RegWrite1 <= '1';
			DataType1 <= '0';
			DataSize1 <= "10";
		
		elsif op = "0000011" and funct3 = "100" then						-- LBU --
		
			PCSrc1 <= "00";
			ResultSrc1 <= "001";
			MemWrite1 <= '0';
			ALUControl1 <= "0000";
			ALUSrc1 <= '1';
			ImmSrc1 <= "000"; 
			RegWrite1 <= '1';
			DataType1 <= '1';
			DataSize1 <= "10";
		
		elsif op = "0000011" and funct3 = "001" then						-- LH --
		
			PCSrc1 <= "00";
			ResultSrc1 <= "001";
			MemWrite1 <= '0';
			ALUControl1 <= "0000";
			ALUSrc1 <= '1';
			ImmSrc1 <= "000"; 
			RegWrite1 <= '1';
			DataType1 <= '0';
			DataSize1 <= "01";
		
		elsif op = "0000011" and funct3 = "101" then						-- LHU --
		
			PCSrc1 <= "00";
			ResultSrc1 <= "001";
			MemWrite1 <= '0';
			ALUControl1 <= "0000";
			ALUSrc1 <= '1';
			ImmSrc1 <= "000"; 
			RegWrite1 <= '1';
			DataType1 <= '1';
			DataSize1 <= "01";
		
		elsif op = "1100111" and funct3 = "000" then						-- JALR --
		
			PCSrc1 <= "10";
			ResultSrc1 <= "010";
			MemWrite1 <= '0';
			ALUControl1 <= "0000";
			ALUSrc1 <= '1';
			ImmSrc1 <= "000"; 
			RegWrite1 <= '1';
			DataType1 <= '0';
			DataSize1 <= "00";
		
		elsif op = "0010011" and funct3 = "000" then						-- ADDI --
		
			PCSrc1 <= "00";
			ResultSrc1 <= "000";
			MemWrite1 <= '0';
			ALUControl1 <= "0000";
			ALUSrc1 <= '1';
			ImmSrc1 <= "000"; 
			RegWrite1 <= '1';
			DataType1 <= '0';
			DataSize1 <= "00";
		
		elsif op = "0010011" and funct3 = "111" then						-- ANDI --
		
			PCSrc1 <= "00";
			ResultSrc1 <= "000";
			MemWrite1 <= '0';
			ALUControl1 <= "0010";
			ALUSrc1 <= '1';
			ImmSrc1 <= "000"; 
			RegWrite1 <= '1';
			DataType1 <= '0';
			DataSize1 <= "00";
		
		elsif op = "0010011" and funct3 = "001" and funct7 = "0000000" then	-- SLLI --
		
			PCSrc1 <= "00";
			ResultSrc1 <= "000";
			MemWrite1 <= '0';
			ALUControl1 <= "0101";
			ALUSrc1 <= '1';
			ImmSrc1 <= "000"; 
			RegWrite1 <= '1';
			DataType1 <= '0';
			DataSize1 <= "00";
		
		elsif op = "0010011" and funct3 = "101" and funct7 = "0000000" then	-- SRLI --
		
			PCSrc1 <= "00";
			ResultSrc1 <= "000";
			MemWrite1 <= '0';
			ALUControl1 <= "0110";
			ALUSrc1 <= '1';
			ImmSrc1 <= "000"; 
			RegWrite1 <= '1';
			DataType1 <= '0';
			DataSize1 <= "00";
		
		elsif op = "0010011" and funct3 = "010" then						-- SLTI --
		
			PCSrc1 <= "00";
			ResultSrc1 <= "000";
			MemWrite1 <= '0';
			ALUControl1 <= "0111";
			ALUSrc1 <= '1';
			ImmSrc1 <= "000"; 
			RegWrite1 <= '1';
			DataType1 <= '0';
			DataSize1 <= "00";
		
		elsif op = "0010011" and funct3 = "110" then						-- ORI --
		
			PCSrc1 <= "00";
			ResultSrc1 <= "000";
			MemWrite1 <= '0';
			ALUControl1 <= "0011";
			ALUSrc1 <= '1';
			ImmSrc1 <= "000"; 
			RegWrite1 <= '1';
			DataType1 <= '0';
			DataSize1 <= "00";
		
		elsif op = "0010011" and funct3 = "100" then						-- XORI --
		
			PCSrc1 <= "00";
			ResultSrc1 <= "000";
			MemWrite1 <= '0';
			ALUControl1 <= "0100";
			ALUSrc1 <= '1';
			ImmSrc1 <= "000"; 
			RegWrite1 <= '1';
			DataType1 <= '0';
			DataSize1 <= "00";
		
		elsif op = "0010011" and funct3 = "101" and funct7 = "0100000" then -- SRAI --
		
			PCSrc1 <= "00";
			ResultSrc1 <= "000";
			MemWrite1 <= '0';
			ALUControl1 <= "1001";
			ALUSrc1 <= '1';
			ImmSrc1 <= "101"; 
			RegWrite1 <= '1';
			DataType1 <= '0';
			DataSize1 <= "00";
		
		elsif op = "0010011" and funct3 = "011" then						-- SLTUI --
		
			PCSrc1 <= "00";
			ResultSrc1 <= "000";
			MemWrite1 <= '0';
			ALUControl1 <= "1000";
			ALUSrc1 <= '1';
			ImmSrc1 <= "000"; 
			RegWrite1 <= '1';
			DataType1 <= '0';
			DataSize1 <= "00";
		
		
		---------------------------------------------------------------------------------------
		
		-- B-Type Instructions --
		elsif op = "1100011" and funct3 = "000" then						-- BEQ --
		
			PCSrc1 <= '0' & Zero;
			ResultSrc1 <= "000";
			MemWrite1 <= '0';
			ALUControl1 <= "0001";
			ALUSrc1 <= '0';
			ImmSrc1 <= "010"; 
			RegWrite1 <= '0';
			DataType1 <= '0';
			DataSize1 <= "00";
		
		elsif op = "1100011" and funct3 = "001" then						-- BNE --
		
			PCSrc1 <= '0' & not Zero;
			ResultSrc1 <= "000";
			MemWrite1 <= '0';
			ALUControl1 <= "0001";
			ALUSrc1 <= '0';
			ImmSrc1 <= "010"; 
			RegWrite1 <= '0';
			DataType1 <= '0';
			DataSize1 <= "00";
		
		elsif op = "1100011" and funct3 = "100" then						-- BLT --
		
			PCSrc1 <= '0' & (Negative xor Overflow);
			ResultSrc1 <= "000";
			MemWrite1 <= '0';
			ALUControl1 <= "0001";
			ALUSrc1 <= '0';
			ImmSrc1 <= "010"; 
			RegWrite1 <= '0';
			DataType1 <= '0';
			DataSize1 <= "00";
		
		elsif op = "1100011" and funct3 = "110" then						-- BLTU --
		
			PCSrc1 <= '0' & not Carry;
			ResultSrc1 <= "000";
			MemWrite1 <= '0';
			ALUControl1 <= "0001";
			ALUSrc1 <= '0';
			ImmSrc1 <= "010"; 
			RegWrite1 <= '0';
			DataType1 <= '0';
			DataSize1 <= "00";
		
		elsif op = "1100011" and funct3 = "101" then						-- BGE --
		
			PCSrc1 <= '0' & not(Negative xor Overflow);
			ResultSrc1 <= "000";
			MemWrite1 <= '0';
			ALUControl1 <= "0001";
			ALUSrc1 <= '0';
			ImmSrc1 <= "010"; 
			RegWrite1 <= '0';
			DataType1 <= '0';
			DataSize1 <= "00";
			
		elsif op = "1100011" and funct3 = "111" then						-- BGEU --
		
			PCSrc1 <= '0' & (Carry and (not Zero));
			ResultSrc1 <= "000";
			MemWrite1 <= '0';
			ALUControl1 <= "0001";
			ALUSrc1 <= '0';
			ImmSrc1 <= "010"; 
			RegWrite1 <= '0';
			DataType1 <= '0';
			DataSize1 <= "00";
		
		
		---------------------------------------------------------------------------------------
		
		-- S-Type Instructions --
		elsif op = "0100011" and funct3 = "010" then						-- SW --
		
			PCSrc1 <= "00";
			ResultSrc1 <= "000";
			MemWrite1 <= '1';
			ALUControl1 <= "0000";
			ALUSrc1 <= '1';
			ImmSrc1 <= "001"; 
			RegWrite1 <= '0';
			DataType1 <= '0';
			DataSize1 <= "00";
		
		elsif op = "0100011" and funct3 = "001" then						-- SH --
		
			PCSrc1 <= "00";
			ResultSrc1 <= "000";
			MemWrite1 <= '1';
			ALUControl1 <= "0000";
			ALUSrc1 <= '1';
			ImmSrc1 <= "001"; 
			RegWrite1 <= '0';
			DataType1 <= '0';
			DataSize1 <= "01";
		
		elsif op = "0100011" and funct3 = "000" then						-- SB --
		
			PCSrc1 <= "00";
			ResultSrc1 <= "000";
			MemWrite1 <= '1';
			ALUControl1 <= "0000";
			ALUSrc1 <= '1';
			ImmSrc1 <= "001"; 
			RegWrite1 <= '0';
			DataType1 <= '0';
			DataSize1 <= "10";
		
		
		---------------------------------------------------------------------------------------
		
		-- J-Type Instructions --
		elsif op = "1101111"  then											-- JAL --
		
			PCSrc1 <= "01";
			ResultSrc1 <= "010";
			MemWrite1 <= '0';
			ALUControl1 <= "0000";
			ALUSrc1 <= '0';
			ImmSrc1 <= "100";
			RegWrite1 <= '1';
			DataType1 <= '0';
			DataSize1 <= "00";
			
		
		---------------------------------------------------------------------------------------
		
		-- U-Type Instructions --
		elsif op = "0110111"  then											-- LUI --
		
			PCSrc1 <= "00";
			ResultSrc1 <= "011";
			MemWrite1 <= '0';
			ALUControl1 <= "0000";
			ALUSrc1 <= '0';
			ImmSrc1 <= "011";
			RegWrite1 <= '1';
			DataType1 <= '0';
			DataSize1 <= "00";
		
		elsif op = "0010111"  then											-- AUIPC --
		
			PCSrc1 <= "00";
			ResultSrc1 <= "100";
			MemWrite1 <= '0';
			ALUControl1 <= "0000";
			ALUSrc1 <= '0';
			ImmSrc1 <= "011";
			RegWrite1 <= '1';
			DataType1 <= '0';
			DataSize1 <= "00";
		
		
		---------------------------------------------------------------------------------------
		
		else
		
			PCSrc1 <= "00";
			ResultSrc1 <= "000";
			MemWrite1 <= '0';
			ALUControl1 <= "0000";
			ALUSrc1 <= '0';
			ImmSrc1 <= "000";
			RegWrite1 <= '0';
			DataType1 <= '0';
			DataSize1 <= "00";
		
		end if;
		
		---------------------------------------------------------------------------------------
	end process;
	
	PCSrc <= PCSrc1;
	MemWrite <= MemWrite1;
	ALUSrc <= ALUSrc1;
	RegWrite <= RegWrite1;
	ResultSrc <= ResultSrc1;
	ALUControl <= ALUControl1;
	ImmSrc <= ImmSrc1;
	DataType <= DataType1;
	DataSize <= DataSize1;


end behave;