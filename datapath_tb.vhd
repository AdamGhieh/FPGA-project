library IEEE;
use IEEE.STD_LOGIC_1164.all;
use IEEE.NUMERIC_STD_UNSIGNED.all;
 
entity testbench is
end;
 
 
architecture test of testbench is
   component top
       port
	   (
			clk, reset : in   STD_LOGIC;
            WriteData, DataAdr, PCout : out STD_LOGIC_VECTOR(31 downto 0);
            MemWrite : out STD_LOGIC
		);
   end component;

   signal WriteData, DataAdr, PCout : STD_LOGIC_VECTOR(31 downto 0);
   signal clk, reset, MemWrite : STD_LOGIC;
	
begin
   -- instantiate device to be tested
   dut: top port map(clk, reset, WriteData, DataAdr, PCout, MemWrite);
   -- Generate clock with 10 ns period
   process begin
        clk <= '1';
        wait for 5 ns;
        clk <= '0';
        wait for 5 ns;
   end process;
   -- Generate reset for first two clock cycles
   process begin
       reset <= '1';
       wait for 22 ns;
       reset <= '0';
       wait;
   end process;

   process(clk) begin
        if(PCout = x"00000014") then
			report "Testbench Complete: Program reached end address";
		elsif (PCout = x"0000004C") then
			report "Error address reached";
		end if;
   end process;
   
   
end; 
