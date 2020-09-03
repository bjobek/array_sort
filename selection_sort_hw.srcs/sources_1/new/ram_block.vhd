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

entity single_port_ram is
    generic(
           addr_width : integer := 5;
           data_width : integer := 8
           );
	port
	(
		din	: in std_logic_vector(data_width-1 downto 0);
		addr	: in natural range 0 to 2**addr_width-1;
		wr		: in std_logic;
		clk		: in std_logic;
		dout		: out std_logic_vector(7 downto 0)
	);
	
end entity;

architecture rtl of single_port_ram is

	-- Build a 2-D array type for the RAM
	subtype word_t is std_logic_vector(data_width-1 downto 0);
	type memory_t is array(2**addr_width-1 downto 0) of word_t;
	
	-- Declare the RAM signal.
	signal ram : memory_t;
	
	-- Register to hold the address
	signal addr_reg : natural range 0 to 2**addr_width-1;

begin

	process(clk)
	begin
		if(rising_edge(clk)) then
			if(wr = '1') then
				ram(addr) <= din;
			end if;
			
			-- Register the address for reading
			addr_reg <= addr;
		end if;
	
	end process;
	
	dout <= ram(addr_reg);
	
end rtl;
