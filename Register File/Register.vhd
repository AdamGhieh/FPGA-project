library ieee;
use ieee.std_logic_1164.all;

-- Synchronous register with generic amount of bits stored and an activation and reset input	--
entity REG is
	generic 
	(
		INPUT_SIZE : natural
	);
	--	R is asynchronous reset, EN is activation --
	port 
	(
		DATA : in std_logic_vector(INPUT_SIZE - 1 downto 0);
		EN, Clk, R : in std_ulogic;
		STORED_VALUE : out std_logic_vector(INPUT_SIZE - 1 downto 0)	
	);
end REG;

architecture rtl of REG is
	--	STORED value is equivalent	--
	signal STORED : std_logic_vector(INPUT_SIZE - 1 downto 0);
	signal MUX_OUT : std_logic_vector(INPUT_SIZE - 1 downto 0);

begin
	-- Instantiate MUX for choosing to write or not --
	MUX : entity work.MUX(rtl)
		generic map
		(
			INPUT_SIZE => INPUT_SIZE
		)
		port map
		(
			I0 => STORED,
			I1 => DATA,
			S => EN,
			O => MUX_OUT
		);
	FlipFlop : entity work.FF(rtl)
		generic map
		(
			INPUT_SIZE => INPUT_SIZE
		)
		port map
		(
			D => MUX_OUT,
			Clk => Clk,
			R => R,
			Q => STORED
		);

	STORED_VALUE <= STORED;

end rtl;