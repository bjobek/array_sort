library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity ram_tb is
    --
end ram_tb;

architecture arch of ram_tb is
    signal clk, load, clear, dIn, dOut: std_logic;
    constant clk_period: time := 10 ns;

begin
    testbench: entity work.ram_block(Behavioral)
    port map
    (
        clk => clk,
        ld => load,
        clr => clear,
        din => dIn,
        dout => dOut
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
        
        std.env.finish; -- stop simulation
    end process ;
end arch;
