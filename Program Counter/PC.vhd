library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity pc is
	port
	(
		Clk : in std_logic;
		RST : in std_logic;
		PC_in : in std_logic_vector(31 downto 0);
		PC_out : out std_logic_vector(31 downto 0)
	);
end pc;

architecture behave of pc is

signal PC_output : std_logic_vector(31 downto 0);


begin
	
	-- At rising edge, updates output to next calculated value -- 
	process(Clk)
	begin
		
		if(rising_edge(Clk)) then
		
			if(RST = '1') then
			
				PC_output <= (others => '0');
				
			else
			
				PC_output <= PC_in;
				
			end if;
			
		end if;
		
	end process;
	
	
	
	-- Updates output concurrently --
	PC_out <= PC_output;

end behave;