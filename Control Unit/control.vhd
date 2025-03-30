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
		Zero : in std_logic;
		
		-- Output buses --
		MemWrite, ALUSrc, RegWrite : out std_logic;
		ResultSrc, PCSrc : out std_logic_vector(1 downto 0);
		ALUControl, ImmSrc : out std_logic_vector(2 downto 0)
	);
end control;

architecture behave of control is

	signal MemWrite1, ALUSrc1, RegWrite1 : std_logic;
	signal ResultSrc1, PCSrc1 : std_logic_vector(1 downto 0);
	signal ALUControl1, ImmSrc1 : std_logic_vector(2 downto 0);

begin

	process(op, funct3, funct7, Zero)
	begin
	
	---------------------------------------------------------------------------------------
	
		-- R-Type Instructions --
		if op = "0110011" and funct3 = "000" and funct7 = "0000000" then	-- ADD --
		
			PCSrc1 <= "00";
			ResultSrc1 <= "00";
			MemWrite1 <= '0';
			ALUControl1 <= "000";
			ALUSrc1 <= '0';
			ImmSrc1 <= "111"; 	-- Set Invalid Type so that Extend unit outputs 0s 
			RegWrite1 <= '1';
			
		elsif op = "0110011" and funct3 = "000" and funct7 = "0100000" then	-- SUB --
		
			PCSrc1 <= "00";
			ResultSrc1 <= "00";
			MemWrite1 <= '0';
			ALUControl1 <= "001";
			ALUSrc1 <= '0';
			ImmSrc1 <= "111";	-- Set Invalid Type so that Extend unit outputs 0s 
			RegWrite1 <= '1';
	
		elsif op = "0110011" and funct3 = "111" and funct7 = "0000000" then -- AND -- 
		
			PCSrc1 <= "00";
			ResultSrc1 <= "00";
			MemWrite1 <= '0';
			ALUControl1 <= "010";
			ALUSrc1 <= '0';
			ImmSrc1 <= "111";	-- Set Invalid Type so that Extend unit outputs 0s 
			RegWrite1 <= '1';
		
		elsif op = "0110011" and funct3 = "110" and funct7 = "0000000" then -- OR --
		
			PCSrc1 <= "00";
			ResultSrc1 <= "00";
			MemWrite1 <= '0';
			ALUControl1 <= "011";
			ALUSrc1 <= '0';
			ImmSrc1 <= "111";	-- Set Invalid Type so that Extend unit outputs 0s 
			RegWrite1 <= '1';
		
		elsif op = "0110011" and funct3 = "100" and funct7 = "0000000" then -- XOR --
		
			PCSrc1 <= "00";
			ResultSrc1 <= "00";
			MemWrite1 <= '0';
			ALUControl1 <= "100";
			ALUSrc1 <= '0';
			ImmSrc1 <= "111";	-- Set Invalid Type so that Extend unit outputs 0s 
			RegWrite1 <= '1';
		
		elsif op = "0110011" and funct3 = "001" and funct7 = "0000000" then -- SLL --
		
			PCSrc1 <= "00";
			ResultSrc1 <= "00";
			MemWrite1 <= '0';
			ALUControl1 <= "101";
			ALUSrc1 <= '0';
			ImmSrc1 <= "111";	-- Set Invalid Type so that Extend unit outputs 0s 
			RegWrite1 <= '1';
	
		elsif op = "0110011" and funct3 = "101" and funct7 = "0000000" then -- SRL --
		
			PCSrc1 <= "00";
			ResultSrc1 <= "00";
			MemWrite1 <= '0';
			ALUControl1 <= "110";
			ALUSrc1 <= '0';
			ImmSrc1 <= "111";	-- Set Invalid Type so that Extend unit outputs 0s 
			RegWrite1 <= '1';
		
		elsif op = "0110011" and funct3 = "010" and funct7 = "0000000" then -- SLT --
		
			PCSrc1 <= "00";
			ResultSrc1 <= "00";
			MemWrite1 <= '0';
			ALUControl1 <= "111";
			ALUSrc1 <= '0';
			ImmSrc1 <= "111";	-- Set Invalid Type so that Extend unit outputs 0s 
			RegWrite1 <= '1';
	
	
	---------------------------------------------------------------------------------------
	
		-- I-Type Instructions -- 
		elsif op = "0000011" and funct3 = "010" then						-- LW --
		
			PCSrc1 <= "00";
			ResultSrc1 <= "01";
			MemWrite1 <= '0';
			ALUControl1 <= "000";
			ALUSrc1 <= '1';
			ImmSrc1 <= "000"; 
			RegWrite1 <= '1';
		
		elsif op = "1100111" and funct3 = "000" then						-- JALR --
		
			PCSrc1 <= "10";
			ResultSrc1 <= "10";
			MemWrite1 <= '0';
			ALUControl1 <= "000";
			ALUSrc1 <= '1';
			ImmSrc1 <= "000"; 
			RegWrite1 <= '1';
		
		elsif op = "0010011" and funct3 = "000" then						-- ADDI --
		
			PCSrc1 <= "00";
			ResultSrc1 <= "00";
			MemWrite1 <= '0';
			ALUControl1 <= "000";
			ALUSrc1 <= '1';
			ImmSrc1 <= "000"; 
			RegWrite1 <= '1';
		
		elsif op = "0010011" and funct3 = "111" then						-- ANDI --
		
			PCSrc1 <= "00";
			ResultSrc1 <= "00";
			MemWrite1 <= '0';
			ALUControl1 <= "010";
			ALUSrc1 <= '1';
			ImmSrc1 <= "000"; 
			RegWrite1 <= '1';
		
		elsif op = "0010011" and funct3 = "001" then						-- SLLI --
		
			PCSrc1 <= "00";
			ResultSrc1 <= "00";
			MemWrite1 <= '0';
			ALUControl1 <= "101";
			ALUSrc1 <= '1';
			ImmSrc1 <= "000"; 
			RegWrite1 <= '1';
		
		elsif op = "0010011" and funct3 = "101" then						-- SRLI --
		
			PCSrc1 <= "00";
			ResultSrc1 <= "00";
			MemWrite1 <= '0';
			ALUControl1 <= "110";
			ALUSrc1 <= '1';
			ImmSrc1 <= "000"; 
			RegWrite1 <= '1';
		
		elsif op = "0010011" and funct3 = "010" then						-- SLTI --
		
			PCSrc1 <= "00";
			ResultSrc1 <= "00";
			MemWrite1 <= '0';
			ALUControl1 <= "111";
			ALUSrc1 <= '1';
			ImmSrc1 <= "000"; 
			RegWrite1 <= '1';
		
		
		---------------------------------------------------------------------------------------
		
		-- B-Type Instructions --
		elsif op = "1100011" and funct3 = "000" then						-- BEQ --
		
			PCSrc1 <= '0' & Zero;
			ResultSrc1 <= "00";
			MemWrite1 <= '0';
			ALUControl1 <= "001";
			ALUSrc1 <= '0';
			ImmSrc1 <= "010"; 
			RegWrite1 <= '0';
		
		elsif op = "1100011" and funct3 = "001" then						-- BNE --
		
			PCSrc1 <= '0' & not Zero;
			ResultSrc1 <= "00";
			MemWrite1 <= '0';
			ALUControl1 <= "001";
			ALUSrc1 <= '0';
			ImmSrc1 <= "010"; 
			RegWrite1 <= '0';
		
		
		---------------------------------------------------------------------------------------
		
		-- S-Type Instructions --
		elsif op = "0100011" and funct3 = "010" then						-- SW --
		
			PCSrc1 <= "00";
			ResultSrc1 <= "00";
			MemWrite1 <= '1';
			ALUControl1 <= "000";
			ALUSrc1 <= '1';
			ImmSrc1 <= "001"; 
			RegWrite1 <= '0';
		
		
		---------------------------------------------------------------------------------------
		
		-- J-Type Instructions --
		elsif op = "1101111"  then											-- JAL --
		
			PCSrc1 <= "01";
			ResultSrc1 <= "10";
			MemWrite1 <= '0';
			ALUControl1 <= "000";
			ALUSrc1 <= '0';
			ImmSrc1 <= "100";
			RegWrite1 <= '1';
			
		
		---------------------------------------------------------------------------------------
		
		-- U-Type Instructions --
		elsif op = "0110111"  then											-- LUI --
		
			PCSrc1 <= "00";
			ResultSrc1 <= "11";
			MemWrite1 <= '0';
			ALUControl1 <= "000";
			ALUSrc1 <= '0';
			ImmSrc1 <= "011";
			RegWrite1 <= '1';
		
		
		---------------------------------------------------------------------------------------
		
		else
		
			PCSrc1 <= "00";
			ResultSrc1 <= "00";
			MemWrite1 <= '0';
			ALUControl1 <= "000";
			ALUSrc1 <= '0';
			ImmSrc1 <= "000";
			RegWrite1 <= '0';
		
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


end behave;