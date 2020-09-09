----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 09/09/2020 01:32:17 PM
-- Design Name: 
-- Module Name: counter_block_tb - Behavioral
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

entity counter_block_tb is
--  Port ( );
end counter_block_tb;

architecture Behavioral of counter_block_tb is


component counter_block is
    generic(
           width : integer 
           );
    Port ( rst : in STD_LOGIC;
           ld : in STD_LOGIC;
           dec : in STD_LOGIC;
           clk : in STD_LOGIC;
           tick : out std_logic;
           din : in STD_LOGIC_VECTOR(width-1 downto 0);
           dout : out STD_LOGIC_VECTOR(width-1 downto 0));
end component;

constant clock_period : time := 10 ns;
signal rst, ld, dec, clk, tick : std_logic;
signal din, dout : std_logic_vector(3 downto 0);

begin
    uut: counter_block
    generic map(4)
    port map(rst => rst, ld => ld, dec => dec, clk => clk, tick => tick, din => din, dout => dout);
    process
    begin 
        clk <= '0';
        wait for clock_period/2;
        clk <= '1';
        wait for clock_period/2;
    end process;

    process
    begin
        rst <='1';
        dec <='0';
        ld <='0';
        wait for clock_period;
        rst <='0';
        wait for clock_period;
        din <= "1111";
        ld<='1';
        wait for clock_period;
        ld <='0';
        dec<='1';
        wait for clock_period*100;
    end process;
end Behavioral;
