library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity datapath is
	port
	(
		gClk : in std_logic;
		gRst : in std_logic
	);
end entity;

architecture behave of datapath is
	
	signal SrcA : std_logic_vector(31 downto 0);
	signal SrcB : std_logic_vector(31 downto 0);
	signal ALU_Result : std_logic_vector(31 downto 0);
	signal Zero : std_logic;
	signal ALU_Control : std_logic_vector(2 downto 0);
	
	ALU : entity work.alu(behave)
		port map
		(
			A => SrcA,
			B => SrcB,
			ALU_Control => ALU_Control,
			V => open,
			N => open,
			Z => Zero,
			ALU_Result => ALU_Result
		);

	signal RegWrite : std_logic;
	signal Result : std_logic_vector(31 downto 0);
	signal RD2 : std_logic_vector(31 downto 0);
	
	REG_FILE : entity work.regfile(behave)
		port map 
		(
			Clk => gClk,
			WE3 => RegWrite,
			RST => gRst,
			WD3 => Result,
			RD1 => SrcA,
			RD2 => RD2,
			A1 => ,
			A2 => ,
			A3 => 
		);
	
	signal ImmSrc : std_logic_vector(2 downto 0);
	signal ImmExt : std_logic_vector(31 downto 0);
	
	Extend : entity work.Extend(behave)
		port map
		(
			imm => ,
			immSrc => ImmSrc,
			immExt => ImmExt
		);
		
	signal PCnext : std_logic_vector(31 downto 0);
	signal PC : std_logic_vector(31 downto 0);
	
	PC : entity work.pc(behave)
		port map
		(
			Clk => gClk,
			RST => gRst,
			PC_in => PCnext,
			PC_out => PC	
		);
	
	signal ALUSrc : std_logic;
	signal PCSrc : std_logic_vector(1 downto 0);
	signal ResultSrc : std_logic_vector(1 downto 0);
	signal MemWrite : std_logic;
	
	Control : entity work.control(behave)
		port map
		(
			op => ,
			funct3 => ,
			funct7 => ,
			Zero => Zero,
			MemWrite => MemWrite,
			ALUSrc => ALUSrc,
			RegWrite => RegWrite,
			ResultSrc => ResultSrc,
			PCSrc => PCSrc,
			ALUControl => ALU_Control,
			ImmSrc => ImmSrc
		);
		
	signal PCplus4 : std_logic_vector(31 downto 0);
begin

	-- Combinational logic for ALU --
	
	SrcB <= RD2	when ALUSrc = '0'
			ImmExt when ALUSrc = '1'
			else (others => '0');
			
	-- Combinational logic for regFile --
	Result <= ALU_Result when ResultSrc = "00"
			  ReadData when ResultSrc = "01"
			  PCplus4 when ResultSrc = "10"
			  ImmExt when ResultSrc = "11"
			  else (others => 0);
	
	-- Combinational logic for PC --
	PCplus4 <= std_logic_vector(to_integer(unsigned(PC)) + 4)
	PCnext <= PCplus4 when PCSrc = "00"
			  std_logic_vector(to_integer(unsigned(PC)) + to_integer(signed(ImmExt))) when PCSrc = "01"
			  ALU_Result when PCSrc = "10";
			  else PCplus4;
	
end architecture;