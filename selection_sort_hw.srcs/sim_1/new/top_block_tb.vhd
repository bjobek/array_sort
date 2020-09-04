----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 09/04/2020 07:25:08 AM
-- Design Name: 
-- Module Name: top_block_tb - Behavioral
-- Project Name: 
-- Target Devices: 
-- Tool Versions: 
-- Description: 
-- 
-- Dependencies: 
-- 
-- Revision:
-- Revision 0.01 - File Created
-- Additional Comments:
-- 
----------------------------------------------------------------------------------


library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity top_block_tb is
--  Port ( );
end top_block_tb;

architecture Behavioral of top_block_tb is


    component top_block
        port(
           clk : in STD_LOGIC;
           rst : in std_logic 
            );
    end component;

    signal clk, rst : std_logic;
    constant clk_period : time := 10 ns;

begin

    uut : top_block
    port map(
            clk => clk, rst => rst                
            );

    process
    begin
        clk <= '0';
        wait for clk_period/2;
        clk <= '1';
        wait for clk_period/2;
    end process;

    process
    begin
        rst <= '1';
        wait for clk_period*2;
        rst <='0';
        wait;  
    end process;
end Behavioral;
