library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity top is
	port
	(
		clk : in std_logic;
		reset : in std_logic;
		WriteData, DataAdr : out std_logic_vector(31 downto 0);
        MemWrite : out std_logic
	);
end entity;

architecture behave of top is
	
	-- Signals for ALU --
	signal SrcA : std_logic_vector(31 downto 0);
	signal SrcB : std_logic_vector(31 downto 0);
	signal ALU_Result : std_logic_vector(31 downto 0);
	signal Zero : std_logic;
	signal ALU_Control : std_logic_vector(2 downto 0);
	
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
	signal ResultSrc : std_logic_vector(1 downto 0);
	signal MemEnable : std_logic;
	

	signal PCplus4 : std_logic_vector(31 downto 0);
	
begin

	ALU : entity work.alu(behave)
		port map
		(
			A => SrcA,
			B => SrcB,
			ALU_Ctrl => ALU_Control,
			overflow => open,
			negative => open,
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
			a => ALU_Result,
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
			MemWrite => MemEnable,
			ALUSrc => ALUSrc,
			RegWrite => RegWrite,
			ResultSrc => ResultSrc,
			PCSrc => PCSrc,
			ALUControl => ALU_Control,
			ImmSrc => ImmSrc
		);
	
	
	-- Combinational logic for ALU --
	SrcB <= RD2	when ALUSrc = '0' 
			else ImmExt when ALUSrc = '1'
			else (others => '0');
			
	-- Combinational logic for regFile --
	Result <= ALU_Result when ResultSrc = "00"
			  else ReadData when ResultSrc = "01"
			  else PCplus4 when ResultSrc = "10"
			  else ImmExt when ResultSrc = "11"
			  else (others => '0');
	
	-- Combinational logic for PC --
	PCplus4 <= std_logic_vector(unsigned(PC) + 4);
	PCnext <= PCplus4 when PCSrc = "00"
			  else std_logic_vector(signed(unsigned(PC) + unsigned(ImmExt))) when PCSrc = "01"
			  else ALU_Result when PCSrc = "10"
			  else PCplus4;
	
	WriteData <= RD2 when MemEnable = '1' else (others => '0');
	DataAdr <= ALU_Result when MemEnable = '1' else (others => '0');
	
	MemWrite <= MemEnable;
	
end architecture;