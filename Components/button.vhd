library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity button is
	port
	(
		clk : in std_logic;
		bi : in std_logic;
		bo : out std_logic := '0'
	);
end entity;


architecture behave of button is

signal button : std_logic := '0';

begin
	
	process(clk, button)
		variable oldb : std_logic := '1';
		variable count : std_logic_vector(19 downto 0);
	begin
		if(rising_edge(clk)) then
			if (bi xor oldb) = '1' then
				count := (others => '0');
				oldb := bi;
			else
				count := std_logic_vector(unsigned(count) + 1);
				if ((count = x"F423F") and (oldb xor bi) = '0') then
					button <= oldb;
				end if;
			end if;			
		end if;
		bo <= button;
	end process;
end architecture;