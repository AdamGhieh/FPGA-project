library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity regfile is
	port 
	(
		Clk : in std_logic := '0';
		WE3 : in std_logic := '0';
		RST : in std_logic := '1';
		A1, A2, A3 : in std_logic_vector(4 downto 0) := (others => '0');
		WD3 : in std_logic_vector(31 downto 0) := (others => '0');
		RD1, RD2 : out std_logic_vector(31 downto 0) := (others => '0')
	);
end regfile;

architecture behave of regfile is

	type ramtype is array (31 downto 0) of std_logic_vector(31 downto 0);
	signal mem : ramtype;
	
	
	begin
		
		process(Clk)
		begin
			-- Check for rising edge of clock -- 
			if rising_edge(Clk) then
			
				--	Synchronous reset -- 
				if RST = '1' then
					for i in 31 downto 0 loop
						mem(i) <= x"00000000";
					end loop;
				end if;
		
				-- Write if enable is active --
				if WE3 = '1' then	
				mem(to_integer(unsigned(A3))) <= WD3; -- Write to register in address specified by A3
				end if;	
				
			end if;	
		end process;
		
		RD1 <= x"00000000" when A1 = "00000" else
			   mem(to_integer(unsigned(A1)));
			   
		RD2 <= x"00000000" when A2 = "00000" else
			   mem(to_integer(unsigned(A2)));
end behave;