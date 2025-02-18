library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std_unsigned.all;
use ieee.numeric_std.all;

entity regfile is
	port 
	(
		Clk : in std_logic;
		WE3 : in std_logic;
		RST : in std_logic;
		A1, A2, A3 : in std_logic_vector(4 downto 0);
		WD3 : in std_logic_vector(31 downto 0);
		RD1, RD2 : out std_logic_vector(31 downto 0)
	);
end regfile;

architecture behave of regfile is

	type ramtype is array (31 downto 0) of std_logic_vector(31 downto 0);
	signal mem : ramtype;
	
	begin
	
		regFile : process(RST, Clk)
		begin
		--	Asynchronous reset -- 
			if RST = '1' then
			
				for i in 31 downto 0 loop
					mem(i) <= x"00000000";
				end loop;
			
			-- Check for rising edge of clock -- 
			elsif rising_edge(Clk) then
			
				-- Can either read or write in one clock cycle --
				if WE3 = '1' then	
					mem(to_integer(unsigned(A3))) <= WD3; -- Write to register in address specified by A3
				else
				
					-- Hard code R0 to 0 --
					if A1 = x"00000000" then RD1 <= x"00000000";
					else RD1 <= mem(to_integer(unsigned(A1)));	-- Read register in address specified by A1
					end if;
					-- Hard code R0 to 0 --
					if A2 = x"00000000" then RD2 <= x"00000000";
					else RD2 <= mem(to_integer(unsigned(A2))); -- Read register in address specified by A1
					end if;
					
				end if;
			end if;					
		end process;
end behave;