library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity alu is
	port
	(
		A, B : in std_logic_vector(31 downto 0);
		ALU_ctrl : in std_logic_vector(3 downto 0);
		overflow, negative, zero, carry : out std_logic;
		result : out std_logic_vector(31 downto 0)
	);
end alu;

architecture behave of alu is

	constant ADDop : std_logic_vector(3 downto 0) := "0000";
	constant SUBop : std_logic_vector(3 downto 0) := "0001";
	constant ANDop : std_logic_vector(3 downto 0) := "0010";
	constant ORop : std_logic_vector(3 downto 0) := "0011";
	constant XORop : std_logic_vector(3 downto 0) := "0100";
	constant SLLop : std_logic_vector(3 downto 0) := "0101";
	constant SRLop : std_logic_vector(3 downto 0) := "0110";
	constant SLTop : std_logic_vector(3 downto 0) := "0111";
	constant SLTUop : std_logic_vector(3 downto 0) := "1000";
	constant SRAop : std_logic_vector(3 downto 0) := "1001";
	
	signal Temp_Result : std_logic_vector(32 downto 0);
	signal V : std_logic;
	
begin 
	alu : process(A, B, ALU_ctrl) 
	begin
	
		Temp_result <= (others => '0');
		
		case ALU_ctrl is 
		
			when ADDop =>	-- ADD Function --
				
				Temp_Result <= std_logic_vector(signed('0' & A) + signed('0' & B));
				
			when SUBop | SLTop | SLTUop => -- SUB Function (used for SLT and SLTU as well) --
			
				Temp_Result <= std_logic_vector(signed('0' & A) + ('0' & (not signed(B) + 1)));
			
			when ANDop =>	-- AND Function --
			
				Temp_Result(31 downto 0) <= A AND B;
				
			when ORop => -- OR Function --
			
				Temp_Result(31 downto 0) <= A OR B;
				
			when XORop => -- XOR Function --
			
				Temp_Result(31 downto 0) <= A XOR B;
				
			when SLLop  => -- Logical Left Shift (SLL) -- 
				
				Temp_Result(31 downto 0) <= std_logic_vector(shift_left(unsigned(A), to_integer(unsigned(B))));
			
			when SRLop => -- Logical Right Shift (SRL) --
				
				Temp_Result(31 downto 0) <= std_logic_vector(shift_right(unsigned(A), to_integer(unsigned(B))));
			
			when SRAop => -- Arithmetic right shift (SRA) --
				
				Temp_Result(31 downto 0) <= std_logic_vector(shift_right(signed(A), to_integer(unsigned(B))));
				
			when others =>
			
				Temp_result <= (others => '0');
				
		end case;
	end process;
	
	process(A, B, Temp_Result, ALU_ctrl)
	begin
		
		if(ALU_ctrl = ADDop) then
		
			V <= (A(31) and B(31) and not(Temp_Result(31))) or (not(A(31)) and not(B(31)) and Temp_Result(31));
			
		else
		
			V <= (A(31) and not(B(31)) and not(Temp_Result(31))) or (not(A(31)) and B(31) and Temp_Result(31));
		
		end if;
	end process;
	
	-- If less than option is chosen for ALU_ctrl, use LSB as sign bit, and set the rest to 0, otherwise use temp_result, for SLTU, inverse of carry is used to tell sign --
	result <= (x"0000000" & "000" & (Temp_Result(31) xor V)) when ALU_ctrl = SLTop else (x"0000000" & "000" & not Temp_Result(32)) when ALU_ctrl = SLTUop  else Temp_Result(31 downto 0);
		
	-- Overflow is calculated by comparing operands sign to result sign for arithmetic operation, overflow = 0 for any other operation --
	overflow <= V when ALU_ctrl = ADDop or ALU_ctrl = SUBop else '0';
	
	-- Zero flag checks for result value --
	zero <= '1' when to_integer(signed(Temp_Result(31 downto 0))) = 0 else '0';
		
	-- Signed bit of result --
	negative <= Temp_Result(31) when ALU_ctrl = ADDop or ALU_ctrl = SUBop else '0';
		
	-- Carry is the extra bit --
	carry <= Temp_Result(32)  when ALU_ctrl = ADDop or ALU_ctrl = SUBop else '0';
		
end behave;