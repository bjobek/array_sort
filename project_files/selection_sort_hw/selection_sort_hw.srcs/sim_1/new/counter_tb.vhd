library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity counter_tb is
    --
end counter_tb;

architecture arch of counter_tb is
    signal clk, load, inc, clear, tick: std_logic;
    signal dIn, dOut: std_logic_vector(3 downto 0);
    constant clk_period: time := 10 ns;

begin
    testbench: entity work.counter_block(Behavioral)
    generic map (4)
    port map
    (
        clk => clk,
        ld => load,
        inc => inc,
        clr => clear,
        tick => tick,
        dIn => dIn,
        dOut => dOut
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
        dIn <= "0000";
        clear <= '1';
        load <= '0';
        inc <= '0';
        wait for clk_period;
        
        clear <= '0';
        dIn <= "0001";
        load <= '1';
        wait for clk_period;
        
        load <= '0';
        inc <= '1';
        wait for clk_period*16;
        
        
        inc <= '0';
        wait for clk_period*5;
        inc <='1';
        wait for clk_period*5;
        clear <= '1';
        wait for clk_period*5;
        
        std.env.finish; -- stop simulation
    end process ;
end arch;
