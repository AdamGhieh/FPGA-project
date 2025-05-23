library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_ARITH.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;

entity pc_tb is
end pc_tb;

architecture testbench of pc_tb is
    signal Clk : std_logic := '0';
    signal RST : std_logic := '0';
    signal PC_in : std_logic_vector(31 downto 0);
    signal PC_out : std_logic_vector(31 downto 0);
    
    -- Instantiate the PC module
    component pc
        port (
            Clk : in std_logic;
            RST : in std_logic;
            PC_in : in std_logic_vector(31 downto 0);
            PC_out : out std_logic_vector(31 downto 0)
        );
    end component;

begin
    dut: pc port map (
        Clk => Clk,
        RST => RST,
        PC_in => PC_in,
        PC_out => PC_out
    );
    
    -- Clock process
    process
    begin
        while true loop
            Clk <= '0'; wait for 5 ns;
            Clk <= '1'; wait for 5 ns;
        end loop;
    end process;
    
    -- Test process
    process
    begin
        RST <= '1'; wait for 10 ns;
        RST <= '0'; wait for 10 ns;
        
        PC_in <= x"00000004"; wait for 10 ns;
        PC_in <= x"00000008"; wait for 10 ns;
        PC_in <= x"0000000C"; wait for 10 ns;
        
        assert false report "Simulation finished" severity note;
        wait;
    end process;

end testbench;
