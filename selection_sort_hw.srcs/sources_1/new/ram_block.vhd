----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 09/03/2020 08:37:45 AM
-- Design Name: 
-- Module Name: ram_block - Behavioral
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
library ieee;
use ieee.std_logic_1164.all;
--use ieee.numeric_std.all;

entity single_port_ram is
    generic(
           addr_width : integer := 5;
           data_width : integer:= 8
           );
	port
	(
		din	: in std_logic_vector(data_width-1 downto 0);
		rst : in std_logic;
		addr	: in natural range 0 to 2**addr_width-1;
		wr		: in std_logic;
		clk		: in std_logic;
		dout		: out std_logic_vector(7 downto 0)
	);
	
end entity;

architecture rtl of single_port_ram is

	-- Build a 2-D array type for the RAM
	--subtype word_t is std_logic_vector(data_width-1 downto 0);
	type memory_t is array(2**addr_width-1 downto 0) of std_logic_vector(data_width-1 downto 0);
	
	-- Declare the RAM signal.
	signal ram : memory_t;
	

	
	-- Register to hold the address
	signal addr_reg : natural range 0 to 2**addr_width-1;

begin

	process(clk,rst)
	begin
	    if(rst = '1') then
	    --ram <= (others=>(others=>'0'));
	    ram(2**addr_width-1 downto 0) <=
        (
        0 => x"45", 1 => x"72", 2 => x"72", 3 => x"6F", 4 => x"72", 5 => x"73",6 => x"3A",
        7 => x"45", 8 => x"72", 9 => x"72", 10 => x"6F", 11 => x"72", 12 => x"73",13 => x"3A",
        14 => x"45", 15 => x"72", 16 => x"72", 17 => x"6F", 18 => x"72", 19 => x"73",20 => x"3A",
        21 => x"45", 22 => x"72", 23 => x"72", 24 => x"6F", 25 => x"72", 26 => x"73",27 => x"3A",
        28 => x"45", 29 => x"72", 30 => x"72", 31 => x"6F"
        );
        
	    
		elsif(rising_edge(clk)) then
			if(wr = '1') then
				ram(addr) <= din;
			end if;
			
			-- Register the address for reading
			addr_reg <= addr;
		end if;
	
	end process;
	
	dout <= ram(addr_reg);
	
end rtl;
