library ieee;
use ieee.std_logic_1164.all;

-- Rising edge D Flip-Flop with asynchronous reset bit	--
entity FF is
	--	Set a generic input size --
	generic
	(
		INPUT_SIZE : natural
	);
	
	port 
	(
		D : in std_logic_vector(INPUT_SIZE - 1 downto 0);
		Clk : in std_ulogic;
		R : in std_ulogic;
		Q : out std_logic_vector(INPUT_SIZE - 1 downto 0)
	);
	
end FF;

architecture rtl of FF is
begin
	-- Checks reset first, then rising edge of clock to set Q output --
	process(Clk)
	begin
		if(R = '1') then
			for i in INPUT_SIZE - 1 downto 0 loop
				Q(i) <= '0';
			end loop;
		elsif (rising_edge(Clk)) then
			Q <= D;
		end if;
	end process;
end rtl;