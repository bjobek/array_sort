library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity comparator_tb is
    --
end comparator_tb;

architecture arch of comparator_tb is
    signal clk, dOut: std_logic;
    signal dinA, dinB: std_logic_vector(7 downto 0);
    constant clk_period: time := 10 ns;

begin
    testbench: entity work.comparator_block(Behavioral)
    port map
    (
        dinA => dinA,
        dinB => dinB,
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
        dinA <= x"01";
        dinB <= x"00";
        wait for clk_period;
        dinA <= x"01";
        dinB <= x"02";
        wait for clk_period;
        dinA <= x"03";
        dinB <= x"03";  
        wait for clk_period;
        dinA <= x"00";
        dinB <= x"00";    
        wait for clk_period;
        
        std.env.finish; -- stop simulation
    end process;
end arch;
