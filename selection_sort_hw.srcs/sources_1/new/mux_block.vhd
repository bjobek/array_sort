----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 09/03/2020 08:37:45 AM
-- Design Name: 
-- Module Name: mux_block - Behavioral
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

entity mux_block is
    generic(
        data_width :  integer := 8
    );
    Port ( dinA : in STD_LOGIC_VECTOR(data_width-1 downto 0);
           dinB : in STD_LOGIC_VECTOR(data_width-1 downto 0);
           dinC : in STD_LOGIC_VECTOR(data_width-1 downto 0);
           sel  : in std_logic_vector(1 downto 0);
           dinD : in STD_LOGIC_VECTOR(data_width-1 downto 0);
           dout : out STD_LOGIC_VECTOR(data_width-1 downto 0));
end mux_block;

architecture Behavioral of mux_block is

begin
    with sel select dout <=
        dinA when "00",
        dinB when "01",
        dinC when "10",
        dinD when others;

end Behavioral;
