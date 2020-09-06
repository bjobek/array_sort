----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 09/03/2020 08:37:45 AM
-- Design Name: 
-- Module Name: counter_block - Behavioral
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

entity counter_block is
    generic(
           MAX : integer 
           );
    Port ( clr : in STD_LOGIC;
           ld : in STD_LOGIC;
           inc : in STD_LOGIC;
           clk : in STD_LOGIC;
           tick : out std_logic;
           din : in STD_LOGIC_VECTOR(MAX-1 downto 0);
           dout : out STD_LOGIC_VECTOR(MAX-1 downto 0));
end counter_block;

architecture Behavioral of counter_block is
    signal count_u : unsigned(MAX-1 downto 0);
begin
    process(clk)
    begin
      
        if(rising_edge(clk)) then
            tick <= '0';
           --if(count_u = 2**MAX-1) then
            --       tick <= '1';
            --end if;
                    
            if(clr='1') then 
                count_u <= (others=>'0');
            elsif(ld = '1') then
                count_u <= unsigned(din);
            elsif(inc = '1') then
                if(count_u = 2**MAX-1) then
                    tick <='1'; 
                    count_u <= (others => '0');
                else
                    count_u <= (count_u + 1);
                end if;
            end if;    
        end if;
    end process;
    dout <= STD_LOGIC_VECTOR(count_u);

end Behavioral;
