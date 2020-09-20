----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 09/09/2020 01:33:06 PM
-- Design Name: 
-- Module Name: mux_block_tb - Behavioral
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

entity mux_block_tb is
--  Port ( );
end mux_block_tb;

architecture Behavioral of mux_block_tb is

component mux_block is
    generic(
        width :  integer
    );
    Port ( dinA : in STD_LOGIC_VECTOR(width-1 downto 0);
           dinB : in STD_LOGIC_VECTOR(width-1 downto 0);
           sel  : in std_logic;
           dout : out STD_LOGIC_VECTOR(width-1 downto 0));
end component;

signal dinA, dinB, dout : std_logic_vector(3 downto 0);
signal sel : std_logic;
constant clock_period : time := 10 ns;
signal clk  : std_logic;

begin

uut : mux_block 
    generic map(4)
    port map(
        dinA => dinA, dinB => dinB, sel => sel, dout => dout
            );

 process
    begin 
        clk <= '0';
        wait for clock_period/2;
        clk <= '1';
        wait for clock_period/2;
    end process;
    
process
begin 
    dinA<= "1100";
    dinB<="0101";
    sel <='0';
    wait for clock_period*4;
    sel<='1';
    wait for clock_period*4;
end process;




end Behavioral;
