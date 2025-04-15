 library IEEE;
 use IEEE.STD_LOGIC_1164.all;
 use IEEE.NUMERIC_STD.all;
 
entity dmem is
    port
	(
		clk, we : in    STD_LOGIC := '0';
	    a, wd : in    STD_LOGIC_VECTOR(31 downto 0) := (others => '0');
        rd : out STD_LOGIC_VECTOR(31 downto 0) := (others => '0')
	);
end;
 
 
architecture behave of dmem is

	type ramtype is  array (63 downto 0) of STD_LOGIC_VECTOR(31 downto 0);
	signal mem: ramtype;
	
begin
    process(clk) is
	begin
        -- read or write memory -- 
			if rising_edge(clk) then
				if (we = '1') then 
					mem(to_integer(unsigned(a(7 downto 2)))) <= wd;
				end if;
			end if;   
    end process;
	
	rd <= mem(to_integer(unsigned(a(7 downto 2)))); -- address 100 is 1100100, ignore 2 last bits
 end; 