----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 09/03/2020 08:38:48 AM
-- Design Name: 
-- Module Name: comparator_block - Behavioral
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
use IEEE.NUMERIC_STD.ALL;
-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;
entity comparator_block is
 generic(
       width: integer         -- data width 
          ); 
    Port ( dinA : in STD_LOGIC_VECTOR(width-1 downto 0);
           dinB : in STD_LOGIC_VECTOR(width-1 downto 0);
           dout : out STD_LOGIC);
end comparator_block;

architecture Behavioral of comparator_block is
signal dinA_u, dinB_u : unsigned(width-1 downto 0);

begin
    dinA_u <= unsigned(dinA);
    dinB_u <= unsigned(dinB);

    process(dinA_u,dinB_u)
    begin
        if(dinA_u < dinB_u) then
            dout <= '1';
        else
            dout <='0';
        end if;
    end process;


end Behavioral;
