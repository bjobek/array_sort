----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 09/09/2020 10:51:41 AM
-- Design Name: 
-- Module Name: control_path - Behavioral
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

entity top_block is
    Generic(
       data_width : integer := 8;
       addr_width : integer := 5
           );
    Port ( 
    clk : std_logic;
    rst : std_logic;
    comp_out : std_logic;
    mux_index_sel : std_logic;
    mux_value_sel : std_logic;
    ram_wr : std_logic;
    prev_i_din, curr_i_din :std_logic_vector(addr_width-1 downto 0)
    prev_i_ld, curr_i_ld : std_logic;
    prev_v_ld, curr_v_ld : std_logic;

         
         );
end top_block;

architecture Behavioral of top_block is

architecture Behavioral of top_block is
       
   component comparator_block is
            Generic(
                width : integer
                    );
            Port ( dinA : in STD_LOGIC_VECTOR(width-1 downto 0);
                   dinB : in STD_LOGIC_VECTOR(width-1 downto 0);
                   dout : out STD_LOGIC);
   end component;

    component counter_block is
        Generic(width : integer);
        Port ( clr : in STD_LOGIC;
               ld : in STD_LOGIC;
               tick : out std_logic;
               inc : in STD_LOGIC;
               clk : in std_logic;
               din : in STD_LOGIC_VECTOR(width-1 downto 0);
               dout : out STD_LOGIC_VECTOR(width-1 downto 0));
    end component;
   
    component mux_block is
        Generic(width : integer);
        Port ( dinA : in STD_LOGIC_VECTOR(width-1 downto 0);
               dinB : in STD_LOGIC_VECTOR(width-1 downto 0);
               dinC : in STD_LOGIC_VECTOR(width-1 downto 0);
               sel  : in std_logic_vector(1 downto 0);
               dinD : in STD_LOGIC_VECTOR(width-1 downto 0);
               dout : out STD_LOGIC_VECTOR(width-1 downto 0));
    end component;

    component single_port_ram is
        generic( 
            data_width : integer;
            addr_width : integer
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
    end component ;
   
    component register_block is
        Generic(width : integer);
        Port ( clr : in STD_LOGIC;
               ld : in STD_LOGIC;
                clk : in STD_LOGIC;
               din : in STD_LOGIC_VECTOR(width-1 downto 0);
               dout : out STD_LOGIC_VECTOR(width-1 downto 0));
    end component;



    signal ram_dout : (data_width -1 downto 0);
    
    signal prev_v_dout, curr_v_dout : (data_width-1 downto 0);
    signal prev_i_dout, curr_i_dout : (data_width-1 downto 0);
    signal mux_index_dout, mux_value_dout : (data_width-1 downto 0);
    signal mux_index_sel, mux_value_sel : std_logic;
        

begin
    mux_index : mux_block
        generic map (2);
        port map(
                dinA => curr_i_din, 
                dinB => prev_i_din,
                sel => mux_index_sel
                );
    mux_value : mux_block
        generic map (2);
        port map(
                dinA => curr_v_din, 
                dinB => prev_v_din,
                sel => mux_value_sel
                );
    ram : single_port_ram
        generic map(
                data_width => 8;
                addr_width => 5
                   )
        port map(
                din => mux_value, addr => mux_index, rst => rst, clk => clk, dout=> ram_dout, wr => ram_wr 
                );
    
    curr_i : counter_block
        generic map(addr_width)
        port map(
                rst => rst, ld => curr_i_ld, inc => '0', clk => clk, tick => open, din => curr_i_din,
                dout => curr_i_dout 
                );
    prev_i : counter_block
        generic map(addr_width)
        port map(
                rst => rst, ld => prev_i_ld, inc => '0', clk => clk, tick => open, din => prev_i_din,
                dout => prev_i_dout 
                );
    curr_v : register_block
        generic map(data_width)
        port map(
                rst => rst, ld => curr_v_ld, clk => clk, din => ram_dout, dout => curr_v_dout
                );

    curr_v : register_block
        generic map(data_width)
        port map(
                rst => rst, ld => curr_v_ld, clk => clk, din => ram_dout, dout => curr_v_dout
                );


end Behavioral;
