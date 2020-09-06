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
        0 => x"10", 1 => x"12", 2 => x"18", 3 => x"1F", 4 => x"13", 5 => x"19",6 => x"1D",
        7 => x"21", 8 => x"22", 9 => x"23", 10 => x"04", 11 => x"05", 12 => x"06",13 => x"07",
        14 => x"08", 15 => x"09", 16 => x"0A", 17 => x"0B", 18 => x"0C", 19 => x"0D",20 => x"0E",
        21 => x"FF", 22 => x"FF", 23 => x"FF", 24 => x"FF", 25 => x"FF", 26 => x"FF",27 => x"FF",
        28 => x"FF", 29 => x"03", 30 => x"01", 31 => x"00"
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