library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity alu is
	port
	(
		A, B : in std_logic_vector(31 downto 0);
		ALU_ctrl : in std_logic_vector(2 downto 0);
		overflow, negative, zero : out std_logic;
		result : out std_logic_vector(31 downto 0)
	);
end alu;

architecture behave of alu is

	signal Temp_Result : std_logic_vector(32 downto 0);
	
begin 
	alu : process(A, B, ALU_ctrl) 
	begin
	
		Temp_result <= (others => '0');
		
		case ALU_ctrl is 
		
			when "000" =>	-- ADD Function --
				
				Temp_Result <= std_logic_vector(signed('0' & A) + signed('0' & B));
				
			when "001" => -- SUB Function --
			
				Temp_Result <= std_logic_vector(signed('0' & A) - signed('0' & B));
			
			when "010" =>	-- AND Function --
			
				Temp_Result(31 downto 0) <= A AND B;
				
			when "011" => -- OR Function --
			
				Temp_Result(31 downto 0) <= A OR B;
				
			when "100" => -- XOR Function --
			
				Temp_Result(31 downto 0) <= A XOR B;
				
			when "101" => -- Logical Left Shift (SLL) --
				
				Temp_Result(31 downto 0) <= std_logic_vector(shift_left(unsigned(A), to_integer(unsigned(B))));
			
			when "110" => -- Logical Right Shift (SRL) --
				
				Temp_Result(31 downto 0) <= std_logic_vector(shift_right(unsigned(A), to_integer(unsigned(B))));
			
			when "111"	 => -- Less Than (SLT) --
			
				Temp_Result <= std_logic_vector(signed('0' & A) - signed('0' & B));
			
			when others =>
			
				Temp_result <= (others => '0');
				
		end case;
	end process;
	
		-- If less than option is chosen for ALU_ctrl, use LSB as sign bit, and set the rest to 0, otherwise use temp_result --
		result <= (x"0000000" & "000" & Temp_Result(31)) when ALU_ctrl = "111"  else Temp_Result(31 downto 0);
		
		-- Overflow is calculated by comparing operands sign to result sign for arithmetic operation, overflow = 0 for any other operation --
		overflow <= (A(31) and B(31) and not(Temp_Result(31))) or (not(A(31)) and not(B(31)) and Temp_Result(31)) when ALU_ctrl = "000" else
		     (A(31) and not(B(31)) and not(Temp_Result(31))) or (not(A(31)) and B(31) and Temp_Result(31)) when ALU_ctrl = "001" else '0';
	
		-- Zero flag checks for result value --
		zero <= '1' when to_integer(signed(Temp_Result(31 downto 0))) = 0 else '0';
		
		-- Signed bit of result --
		negative <= '0' when ALU_ctrl = "111" else Temp_Result(31);
		
end behave;