library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity pc is
	port
	(
		Clk : in std_logic;
		PC_Src : in std_logic;
		ImmExt : in std_logic_vector(31 downto 0);
		PC : out std_logic_vector(31 downto 0)
	);
end pc;

architecture behave of pc is

signal PC_Target  : std_logic_vector(31 downto 0);
signal PC_Next : std_logic_vector(31 downto 0);
signal PC_output : std_logic_vector(31 downto 0) := (others => '0'); -- output is initialized to 0 to make design functional (might update code to be more thorough with initial pc address)
signal PC_Plus4 : std_logic_vector(31 downto 0);

begin
	
	-- At rising edge, updates output to next calculated value -- 
	process(Clk)
	begin

		if(rising_edge(Clk)) then
			PC_output <= PC_Next;
		end if;
		
	end process;
	
	-- Calculates possible values for following PC value --
	PC_Target <= std_logic_vector(unsigned(PC_output) + unsigned(ImmExt));
	PC_Plus4 <= std_logic_vector(unsigned(PC_output) + 4);

	-- Selects next PC value based on PC_Src input --
	PC_Next <= PC_Plus4 when PC_Src = '0' else
			   PC_Target when PC_Src = '1' else (others => 'X');
	
	
	-- Updates output concurrently --
	PC <= PC_output;

end behave;