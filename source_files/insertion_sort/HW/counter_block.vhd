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
           width : integer 
           );
    Port ( rst : in STD_LOGIC;
           ld : in STD_LOGIC;
           dec : in STD_LOGIC;
           clk : in STD_LOGIC;
           tick : out std_logic;
           din : in STD_LOGIC_VECTOR(width-1 downto 0);
           dout : out STD_LOGIC_VECTOR(width-1 downto 0));
end counter_block;

architecture Behavioral of counter_block is
    signal count_u : unsigned(width-1 downto 0);
begin
    process(clk)
    begin
        if(rst = '1') then

            count_u <= (others=>'0');
          --  tick<='0';
        elsif(rising_edge(clk)) then
            tick <= '0';
           if(count_u = 2**width-1) then
                   tick <= '1';
            end if;
                    
                if(ld = '1') then
                count_u <= unsigned(din);
                end if;
                if(dec = '1') then
                
               
                    
                
                    count_u <= (count_u - 1);
                end if;
            end if;    
       
    end process;
    
   
    
    dout <= STD_LOGIC_VECTOR(count_u);
    
    
end Behavioral;
