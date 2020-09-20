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
    clk : in std_logic;
    rst : in std_logic;
    comp_out : out std_logic;
    mux_index_sel : in std_logic;
    mux_value_sel : in std_logic;
    ram_wr : in std_logic;
    prev_i_din, curr_i_din : in std_logic_vector(addr_width-1 downto 0);
    prev_i_ld, curr_i_ld :in  std_logic;
    prev_v_ld, curr_v_ld :in  std_logic;
   -- curr_i_tick : out  std_logic;
    curr_i_dec, prev_i_dec : in std_logic;
    
    prev_idx_dout , curr_idx_dout : out std_logic_vector(addr_width-1 downto 0)

         
         );
end top_block;

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
        Port ( clk : in STD_LOGIC;
               ld : in STD_LOGIC;
               tick : out std_logic;
               dec : in STD_LOGIC;
               rst : in std_logic;
               din : in STD_LOGIC_VECTOR(width-1 downto 0);
               dout : out STD_LOGIC_VECTOR(width-1 downto 0));
    end component;
   
    component mux_block is
        Generic(width : integer);
        Port ( dinA : in STD_LOGIC_VECTOR(width-1 downto 0);
               dinB : in STD_LOGIC_VECTOR(width-1 downto 0);
               sel  : in std_logic;
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
        Port ( rst : in STD_LOGIC;
               ld : in STD_LOGIC;
                clk : in STD_LOGIC;
               din : in STD_LOGIC_VECTOR(width-1 downto 0);
               dout : out STD_LOGIC_VECTOR(width-1 downto 0));
    end component;



    signal ram_dout : std_logic_vector(data_width-1 downto 0);
    
    signal prev_v_dout, curr_v_dout : std_logic_vector(data_width-1 downto 0);
    signal prev_i_dout, curr_i_dout : std_logic_vector(addr_width-1 downto 0);
    signal mux_index_dout : std_logic_vector(addr_width-1 downto 0);
    signal mux_value_dout : std_logic_vector(data_width-1 downto 0);
        

begin
    mux_index : mux_block
        generic map (addr_width)
        port map(
                dinA => curr_i_dout, 
                dinB => prev_i_dout,
                sel => mux_index_sel,
                dout => mux_index_dout

                );
    mux_value : mux_block
        generic map (data_width)
        port map(
                dinA => curr_v_dout, 
                dinB => prev_v_dout,
                sel => mux_value_sel,
                dout => mux_value_dout
                );
    ram : single_port_ram
        generic map(
                data_width => 8,
                addr_width => 5
                   )
        port map(
                din => mux_value_dout, addr => to_integer(unsigned(mux_index_dout)), rst => rst, clk => clk, dout=> ram_dout, wr => ram_wr 
                );
    
    curr_i : counter_block
        generic map(addr_width)
        port map(
                rst => rst, ld => curr_i_ld, dec => curr_i_dec, clk => clk, tick => open, din => curr_i_din,
                dout => curr_i_dout 
                );
    prev_i : counter_block
        generic map(addr_width)
        port map(
                rst => rst, ld => prev_i_ld, dec => prev_i_dec, clk => clk, tick => open, din => prev_i_din,
                dout => prev_i_dout 
                );
    curr_v : register_block
        generic map(data_width)
        port map(
                rst => rst, ld => curr_v_ld, clk => clk, din => ram_dout, dout => curr_v_dout
                );

    prev_v : register_block
        generic map(data_width)
        port map(
                rst => rst, ld => prev_v_ld, clk => clk, din => ram_dout, dout => prev_v_dout
                );
    comp : comparator_block
        generic map(data_width)
        port map(
               dinA => curr_v_dout, dinB => prev_v_dout, dout => comp_out 
                );   

    prev_idx_dout <= prev_i_dout;
    curr_idx_dout <= curr_i_dout;

end Behavioral;
