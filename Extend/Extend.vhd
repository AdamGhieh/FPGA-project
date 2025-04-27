library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity extend is
	port
	(
		imm : in std_logic_vector(31 downto 7);
		immSrc : in std_logic_vector(2 downto 0);
		immExt : out std_logic_vector(31 downto 0)
	);
end extend;

architecture behave of extend is

constant I_Type : std_logic_vector(2 downto 0) := "000";
constant I_Type_SRA : std_logic_vector(2 downto 0) := "101";
constant S_Type : std_logic_vector(2 downto 0) := "001";
constant B_Type : std_logic_vector(2 downto 0) := "010";
constant U_Type : std_logic_vector(2 downto 0) := "011";
constant J_Type : std_logic_vector(2 downto 0) := "100";

signal Ext : std_logic_vector(31 downto 0); -- signal representing extended and formatted immediate value

begin
	
	-- Process formats immediate value depending on type of instruction and stores it in Ext
	process(imm, immSrc)
	
		variable sign : std_logic;
		
	begin	
	
		sign := imm(31);
		
		case immSrc is
			
			when I_Type =>
			
				Ext(31 downto 12) <= (others => sign);
				Ext(11 downto 0) <= imm(31 downto 20);
			
			when I_Type_SRA =>
				
				Ext(31 downto 5) <= (others => sign);
				Ext(4 downto 0) <= imm(24 downto 20);
				
			when S_Type =>
				
				Ext(31 downto 12) <= (others => sign);
				Ext(11 downto 5) <= imm(31 downto 25);
				Ext(4 downto 0) <= imm(11 downto 7);
				
			when B_Type =>
				
				Ext(31 downto 13) <= (others => sign);
				Ext(12 downto 5) <= imm(31) & imm(7) & imm(30 downto 25);
				Ext(4 downto 0) <= imm(11 downto 8) & '0';
	
			when U_Type =>
			
				Ext(31 downto 12) <= imm(31 downto 12);
				Ext(11 downto 0) <= (others => '0');
				
			when J_Type =>
				
				Ext(31 downto 21) <= (others => sign);
				Ext(20 downto 0) <= imm(31) & imm(19 downto 12) & imm(20) & imm(30 downto 21) & '0';
	
			when others =>
				Ext <= (others => '0');
		end case;
	end process;
	
	-- Updates outputted immediate value with calculated value
	immExt <= Ext;

end behave;
