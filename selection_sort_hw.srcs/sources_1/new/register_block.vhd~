----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 09/03/2020 08:37:45 AM
-- Design Name: 
-- Module Name: register_block - Behavioral
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

entity register_block is
    Port ( clr : in STD_LOGIC;
           ld : in STD_LOGIC;
            clk : in STD_LOGIC;
           din : in STD_LOGIC;
           dout : out STD_LOGIC);
end register_block;

architecture Behavioral of register_block is

begin

    process(clk)
    begin
        if(rising_edge(clk)) then
            if(clr = '1') then
                dout <= '0';
            elsif(ld = '1') then
                dout <= din;
            end if;
        end if;

    end process;


end Behavioral;
