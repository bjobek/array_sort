----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 09/10/2020 09:15:26 AM
-- Design Name: 
-- Module Name: control_path_tb - Behavioral
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

entity control_path_tb is
--  Port ( );
end control_path_tb;

architecture Behavioral of control_path_tb is


component control_path is
    generic(
        data_width : integer := 8;
        addr_width : integer := 5
    );
    port
    (
        clk: in std_logic;
        rst: in std_logic
    );
end component;

signal clk, rst : std_logic;
constant clk_period : time := 10 ns;
begin

uut: control_path
port map(clk => clk, rst => rst);

process
begin
clk <= '0';
wait for clk_period/2;
clk <= '1'; 
wait for clk_period/2;
end process;

process
begin
rst <='1';
wait for clk_period;
rst <='0';
wait;
end process;

end Behavioral;
