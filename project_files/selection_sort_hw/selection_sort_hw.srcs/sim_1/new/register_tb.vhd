library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity register_tb is
    --
end register_tb;

architecture arch of register_tb is
    signal clk, load, clear, dIn, dOut: std_logic;
    constant clk_period: time := 10 ns;

begin
    testbench: entity work.register_block(Behavioral)
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
        dIn <= '1';
        
        clear <= '1';
        load <= '0';
        wait for clk_period;
        
        clear <= '0';
        load <= '1';
        wait for clk_period;
        
        std.env.finish; -- stop simulation
    end process ;
end arch;
