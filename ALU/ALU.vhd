library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity alu is
	port
	(
		A, B : in std_logic_vector(31 downto 0);
		ALU_Control : in std_logic_vector(2 downto 0);
		V, N, Z : out std_logic;
		ALU_Result : out std_logic_vector(31 downto 0)
	);
end alu;

architecture behave of alu is

	signal Temp_Result : std_logic_vector(32 downto 0);
	signal Overflow : std_logic_vector(31 downto 0);
	
begin 
	alu : process(A, B, ALU_Control) 
	begin
		case ALU_Control is 
		
			when "000" =>	-- ADD Function --
				
				Temp_Result <= std_logic_vector(unsigned('0' & A) + unsigned('0' & B));
				Overflow <= std_logic_vector(unsigned('0' & A(30 downto 0)) + unsigned('0' & B(30 downto 0)));
				
			when "001" => -- SUB Function --
			
				Temp_Result <= std_logic_vector(signed('0' & A) - signed('0' & B));
				Overflow <= std_logic_vector(signed('0' & A(30 downto 0)) - signed('0' & B(30 downto 0)));
			
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
				Overflow <= (others => '0');
			
			when others =>
			
				Temp_result <= (others => 'X');
				Overflow <= (others => 'X');
				
		end case;
	end process;
	
		ALU_Result <= (x"0000000" & "000" & Temp_Result(31)) when ALU_Control = "111"  else Temp_Result(31 downto 0);
		V <= Temp_Result(32) XOR overflow(31);
		Z <= '1' when to_integer(signed(Temp_Result(31 downto 0))) = 0 else '0';
		N <= Temp_Result(31);
		
end behave;