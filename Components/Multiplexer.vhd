library ieee;
use ieee.std_logic_1164.all;

--	Two to one multiplexer	--
entity MUX is
	-- Set generic value for input size	--
	generic 
	(
		INPUT_SIZE : natural
	);
	
	port 
	(
		I0 : in std_logic_vector(INPUT_SIZE - 1 downto 0);
		I1 : in std_logic_vector(INPUT_SIZE - 1 downto 0);
		S : in std_ulogic;
		O : out std_logic_vector(INPUT_SIZE - 1 downto 0)
	);
end MUX;

architecture rtl of MUX is
begin
	-- S bit selects if output is I0 or I1, for now "others" is set to I0 which is meant to be a feedback, will change in the future --
	with S select O <=
		I0 when '0',
		I1 when '1',
		I0 when others;
	
end rtl;