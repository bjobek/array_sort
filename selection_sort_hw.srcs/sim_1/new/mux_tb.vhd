library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity mux_tb is
    --
end mux_tb;

architecture arch of mux_tb is
    signal clk, dinA, dinB, dinC, dinD, dOut: std_logic;
    signal sel: std_logic_vector(1 downto 0);
    constant clk_period: time := 10 ns;
        
begin
    testbench: entity work.mux_block(Behavioral)
    port map
    (
        dinA => dinA,
        dinB => dinB,
        dinC => dinC,
        dinD => dinD,
        dout => dOut,
        sel => sel
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
        dinA <= '1';
        dinB <= '0';
        dinC <= '1';
        dinD <= '0';
        
        sel <= "00";     
        wait for clk_period;
        sel <= "01";     
        wait for clk_period;
        sel <= "10";     
        wait for clk_period;
        sel <= "11";     
        wait for clk_period;
        
        std.env.finish; -- stop simulation
    end process ;
end arch;
