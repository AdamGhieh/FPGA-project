library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity top is
	port
	(
		clk : in std_logic;
		reset : in std_logic;
		WriteData, DataAdr : out std_logic_vector(31 downto 0);
        MemWrite : out std_logic;
		PCout : out std_logic_vector(31 downto 0)
	);
end entity;

architecture behave of top is
	
	-- Signals for ALU --
	signal SrcA : std_logic_vector(31 downto 0);
	signal SrcB : std_logic_vector(31 downto 0);
	signal ALU_Result : std_logic_vector(31 downto 0);
	signal Zero, Carry, Overflow, Negative : std_logic;
	signal ALU_Control : std_logic_vector(3 downto 0);
	
	-- Signals for register file -- 
	signal RegWrite : std_logic;
	signal Result : std_logic_vector(31 downto 0);
	signal RD2 : std_logic_vector(31 downto 0);
	
	-- Signals for Extend unit --
	signal ImmSrc : std_logic_vector(2 downto 0);
	signal ImmExt : std_logic_vector(31 downto 0);
	
	-- Signals for PC -- 
	signal PCnext : std_logic_vector(31 downto 0);
	signal PC : std_logic_vector(31 downto 0);
	
	-- Signal for data memory -- 	
	signal ReadData : std_logic_vector(31 downto 0);

	-- Signal for instruction memory --
	signal Instr : std_logic_vector(31 downto 0);
	
	-- Signals for control unit --
	signal ALUSrc : std_logic;
	signal PCSrc : std_logic_vector(1 downto 0);
	signal ResultSrc : std_logic_vector(2 downto 0);
	signal MemEnable : std_logic;
	signal DataType : std_logic;
	signal DataSize : std_logic_vector(1 downto 0);

	signal PCplus4 : std_logic_vector(31 downto 0);
	signal PCTarget : std_logic_vector(31 downto 0);
	
begin

	ALU : entity work.alu(behave)
		port map
		(
			A => SrcA,
			B => SrcB,
			ALU_Ctrl => ALU_Control,
			overflow => Overflow,
			negative => Negative,
			carry => Carry,
			zero => Zero,
			result => ALU_Result
		);
	REG_FILE : entity work.regfile(behave)
		port map 
		(
			Clk => clk,
			WE3 => RegWrite,
			RST => reset,
			WD3 => Result,
			RD1 => SrcA,
			RD2 => RD2,
			A1 => Instr(19 downto 15),
			A2 => Instr(24 downto 20),
			A3 => Instr(11 downto 7)
		);
	Extend : entity work.Extend(behave)
		port map
		(
			imm => Instr(31 downto 7),
			immSrc => ImmSrc,
			immExt => ImmExt
		);
	ProgramCounter : entity work.pc(behave)
		port map
		(
			Clk => clk,
			RST => reset,
			PC_in => PCnext,
			PC_out => PC	
		);
	DataMem : entity work.dmem(behave)
		port map
		(
			clk => clk,
			we => MemEnable,
			reset => reset,
			a => ALU_Result,
			datatype => DataType,
			datasize => DataSize,
			wd => RD2,
			rd => ReadData
		);
	InstMem : entity work.i_cache(behav)
		port map
		(
			address_input => PC,
			data_output => Instr
		);
	Control : entity work.control(behave)
		port map
		(
			op => Instr(6 downto 0),
			funct3 => Instr(14 downto 12),
			funct7 => Instr(31 downto 25),
			Zero => Zero,
			Overflow => Overflow,
			Carry => Carry,
			Negative => Negative,
			MemWrite => MemEnable,
			ALUSrc => ALUSrc,
			RegWrite => RegWrite,
			ResultSrc => ResultSrc,
			PCSrc => PCSrc,
			ALUControl => ALU_Control,
			ImmSrc => ImmSrc,
			DataType => DataType,
			DataSize => DataSize
		);
	
	
	-- Combinational logic for ALU --
	SrcB <= RD2	when ALUSrc = '0' 
			else ImmExt when ALUSrc = '1'
			else (others => '0');
			
	-- Combinational logic for regFile --
	Result <= ALU_Result when ResultSrc = "000"
			  else ReadData when ResultSrc = "001"
			  else PCplus4 when ResultSrc = "010"
			  else ImmExt when ResultSrc = "011"
			  else PCTarget when ResultSrc = "100"
			  else (others => '0');
	
	-- Combinational logic for PC --
	PCplus4 <= std_logic_vector(unsigned(PC) + 4);
	PCTarget <= std_logic_vector(signed(unsigned(PC) + unsigned(ImmExt)));
	PCnext <= PCplus4 when PCSrc = "00"
			  else PCTarget when PCSrc = "01"
			  else ALU_Result when PCSrc = "10"
			  else PCplus4;
	
	WriteData <= RD2 when MemEnable = '1' else (others => '0');
	DataAdr <= ALU_Result when MemEnable = '1' else (others => '0');
	
	MemWrite <= MemEnable;
	PCout <= PC;
	
end architecture;