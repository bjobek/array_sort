library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.numeric_std.all;

entity ram_tb is
    --
end ram_tb;

architecture arch of ram_tb is
    signal clk, reset, wr: std_logic;
    signal dIn: std_logic_vector(7 downto 0);
    signal dOut: std_logic_vector(7 downto 0);
    signal addr: std_logic_vector(4 downto 0);
    constant clk_period: time := 10 ns;

begin
    testbench: entity work.single_port_ram(rtl)
    port map
    (
        clk => clk,
        rst => reset,
        wr => wr,
        din => dIn,
        dout => dOut,
        addr => to_integer(unsigned(addr)) -- type cast to natural/int
    );
    
    clock: process 
    begin
        clk <= '0';
        wait for clk_period/2;
        clk <= '1';
        wait for clk_period/2;
    end process;
    
    simulation: process
    begin
        dIn <= x"01";
        addr <= "00000";
        reset <= '1';
        wr <= '0';
        wait for clk_period;
        
        addr <= "00000";
        reset <= '0';
        wait for clk_period;
        
        addr <= "00001";
        wait for clk_period;
        
        addr <= "00010";
        wait for clk_period;
        
        addr <= "00011";
        wait for clk_period;
        
        addr <= "00101";
        wait for clk_period;
        
        addr <= "00111";
        wait for clk_period;
        
        wr <= '1';
        wait for clk_period;
        
        std.env.finish; -- stop simulation
    end process ;
end arch;
