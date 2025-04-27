 library IEEE;
 use IEEE.STD_LOGIC_1164.all;
 use IEEE.NUMERIC_STD.all;
 
entity dmem is
    port
	(
		clk, we, datatype, reset : in    STD_LOGIC := '0';
	    a, wd : in    STD_LOGIC_VECTOR(31 downto 0) := (others => '0');
		datasize : in STD_LOGIC_VECTOR(1 downto 0) := "00";
        rd : out STD_LOGIC_VECTOR(31 downto 0) := (others => '0')
	);
end;
 
 
architecture behave of dmem is

	type ramtype is  array (63 downto 0) of STD_LOGIC_VECTOR(31 downto 0);
	signal mem : ramtype;
	signal readValue : STD_LOGIC_VECTOR(31 downto 0);
	
begin

    process(clk) is
	begin
        -- read or write memory -- 
			if rising_edge(clk) then
			
				--	Synchronous reset -- 
				if reset = '1' then
					for i in 63 downto 0 loop
						mem(i) <= x"00000000";
					end loop;
				end if;
				
				if (we = '1') then 
					
					case datasize is
						when "00" =>	-- Word Sized --
						
							mem(to_integer(unsigned(a(7 downto 2)))) <= wd;
							
						when "01" => 	-- Half-Word Sized --
						
							-- Check which half of the word is used for the half-word --
							if(a(1 downto 0) = "00" or a(1 downto 0) = "01") then
							
								mem(to_integer(unsigned(a(7 downto 2))))(15 downto 0) <= wd(15 downto 0);
								
							elsif(a(1 downto 0) = "10" or a(1 downto 0) = "11") then 
							
								mem(to_integer(unsigned(a(7 downto 2))))(31 downto 16) <= wd(15 downto 0);
						
							end if;
						
						when "10" =>	-- Byte Sized --
						
							-- Check which quarter of the word is used for the byte --
							if(a(1 downto 0) = "00") then
							
								mem(to_integer(unsigned(a(7 downto 2))))(7 downto 0) <= wd(7 downto 0);
								
							elsif(a(1 downto 0) = "01") then
							
								mem(to_integer(unsigned(a(7 downto 2))))(15 downto 8) <= wd(7 downto 0);
								
							elsif(a(1 downto 0) = "10") then
							
								mem(to_integer(unsigned(a(7 downto 2))))(23 downto 16) <= wd(7 downto 0);
							
							elsif(a(1 downto 0) = "11") then
							
								mem(to_integer(unsigned(a(7 downto 2))))(31 downto 24) <= wd(7 downto 0);
								
							end if;
						when others =>
					end case;
				end if;
			end if;   
    end process;
	
	rd <= 
	
	-- Word Sized --
	mem(to_integer(unsigned(a(7 downto 2)))) when datasize = "00" else
	
	
	-- Half-Word Sized --
	(31 downto 16 => mem(to_integer(unsigned(a(7 downto 2))))(15)) & mem(to_integer(unsigned(a(7 downto 2))))(15 downto 0) 	when datasize = "01" and a(1) = '0' and datatype = '0' else
	(31 downto 16 => '0') & mem(to_integer(unsigned(a(7 downto 2))))(15 downto 0) 										   	when datasize = "01" and a(1) = '0' and datatype = '1' else
	
	(31 downto 16 => mem(to_integer(unsigned(a(7 downto 2))))(31)) & mem(to_integer(unsigned(a(7 downto 2))))(31 downto 16) when datasize = "01" and a(1) = '1' and datatype = '0' else
	(31 downto 16 => '0') & mem(to_integer(unsigned(a(7 downto 2))))(31 downto 16) 											when datasize = "01" and a(1) = '1' and datatype = '1' else
	
	
	-- Byte-Sized --
	(31 downto 8 => mem(to_integer(unsigned(a(7 downto 2))))(7)) & mem(to_integer(unsigned(a(7 downto 2))))(7 downto 0)		when datasize = "10" and a(1 downto 0) = "00" and datatype = '0' else
	(31 downto 8 => '0') & mem(to_integer(unsigned(a(7 downto 2))))(7 downto 0)												when datasize = "10" and a(1 downto 0) = "00" and datatype = '1' else
	
	(31 downto 8 => mem(to_integer(unsigned(a(7 downto 2))))(15)) & mem(to_integer(unsigned(a(7 downto 2))))(15 downto 8)	when datasize = "10" and a(1 downto 0) = "01" and datatype = '0' else
	(31 downto 8 => '0') & mem(to_integer(unsigned(a(7 downto 2))))(15 downto 8)											when datasize = "10" and a(1 downto 0) = "01" and datatype = '1' else
	
	(31 downto 8 => mem(to_integer(unsigned(a(7 downto 2))))(23)) & mem(to_integer(unsigned(a(7 downto 2))))(23 downto 16)	when datasize = "10" and a(1 downto 0) = "10" and datatype = '0' else
	(31 downto 8 => '0') & mem(to_integer(unsigned(a(7 downto 2))))(23 downto 16)											when datasize = "10" and a(1 downto 0) = "10" and datatype = '1' else
	
	(31 downto 8 => mem(to_integer(unsigned(a(7 downto 2))))(31)) & mem(to_integer(unsigned(a(7 downto 2))))(31 downto 24)	when datasize = "10" and a(1 downto 0) = "11" and datatype = '0' else
	(31 downto 8 => '0') & mem(to_integer(unsigned(a(7 downto 2))))(31 downto 24)											when datasize = "10" and a(1 downto 0) = "11" and datatype = '1';
	
 end; 