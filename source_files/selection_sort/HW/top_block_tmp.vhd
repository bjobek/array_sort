----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 09/03/2020 08:31:02 AM
-- Design Name: 
-- Module Name: top_block - Behavioral
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
use IEEE.numeric_std.all;
-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity top_block_tmp is
  
    Port (
        -- common ports 
          current_index_ctr_inc : in std_logic;
          current_index_ctr_ld : in std_logic;
          tmp_index_ctr_ld : in std_logic;
         tmp_index_ctr_inc : in STD_LOGIC;
           addr_mux_sel : in std_logic_vector(1 downto 0);
     value_mux_sel : in std_logic_vector(1 downto 0);
    ram_wr : in std_logic;
    smallest_val_reg_ld : in std_logic;
       current_val_reg_ld : in std_logic;
          smallest_index_reg_ld : in std_logic; 
    comp_out : out std_logic;
     tmp_index_ctr_tick : out  std_logic;
     current_index_ctr_tick : out std_logic;



        clr : in std_logic;
        clk : in STD_LOGIC;
        
        rst : in STD_LOGIC
        
    
         );
end top_block_tmp;

architecture Behavioral of top_block_tmp is
       constant M : integer := 8;                
       constant MAX : integer := 5;
       constant data_width : integer := 8;
       constant addr_width : integer := 5;
       
   component comparator_block is
            Port ( dinA : in STD_LOGIC_VECTOR(M-1 downto 0);
                   dinB : in STD_LOGIC_VECTOR(M-1 downto 0);
                   dout : out STD_LOGIC);
   end component;

    component counter_block is
        Generic(MAX : integer);
        Port ( clr : in STD_LOGIC;
               ld : in STD_LOGIC;
               tick : out std_logic;
               inc : in STD_LOGIC;
               clk : in std_logic;
               din : in STD_LOGIC_VECTOR(MAX-1 downto 0);
               dout : out STD_LOGIC_VECTOR(MAX-1 downto 0));
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

    
    
    -- current index ctr
   
    signal current_index_ctr_dout : std_logic_vector(addr_width-1 downto 0); 
 
   -- tmp_index_ctr
   
   
    signal tmp_index_ctr_dout : std_logic_vector(addr_width-1 downto 0); 
   -- 3:1 addr  mux
    signal addr_mux_dout : std_logic_vector(addr_width-1 downto 0);
   -- 2:1 value mux
    signal value_mux_dout : std_logic_vector(data_width-1 downto 0);
   -- ram

   signal ram_dout : std_logic_vector(data_width-1 downto 0);
   -- smallest value register
   signal  smallest_val_reg_dout : std_logic_vector(data_width-1 downto 0);
   -- current value register
   signal  current_val_reg_dout : std_logic_vector(data_width-1 downto 0);
   -- smallest index register
   signal  smallest_index_reg_dout : std_logic_vector(addr_width-1 downto 0);
   -- comparator 

begin
-- instantiate components

    current_index_ctr: counter_block
    generic map (5) --no semicolon here
    port map(   
            ld => current_index_ctr_ld, 
            inc => current_index_ctr_inc,
            clr => clr,
            clk => clk,
            tick => current_index_ctr_tick,
            din => (others=>'0'),
            dout => current_index_ctr_dout
            );
    tmp_index_ctr: counter_block
    generic map(5)
    port map(
            ld => tmp_index_ctr_ld, 
            inc => tmp_index_ctr_inc,
            clr => clr,
            clk => clk,
            tick => tmp_index_ctr_tick,
            din => current_index_ctr_dout,
            dout => tmp_index_ctr_dout
            );
    addr_mux: mux_block
    generic map(5)
    port map(
            dinA => current_index_ctr_dout,
            dinB => smallest_index_reg_dout,
            dinC => tmp_index_ctr_dout,
            sel => addr_mux_sel,
            dinD => (others=>'0'),
            dout => addr_mux_dout 
            );
    value_mux: mux_block
    generic map(8)
    port map(
            dinA => smallest_val_reg_dout,
            dinB => current_val_reg_dout,
            dinC => (others => '0'),
            sel => value_mux_sel,
            dinD => (others=>'0'),
            dout => value_mux_dout 
            );
    ram: single_port_ram 
    port map(
            rst => rst,
            din => value_mux_dout,	
            addr => to_integer(unsigned(addr_mux_dout)), -- type cast to natural/int
            wr => ram_wr,	
            clk	=> clk,
            dout => ram_dout
            );
    smallest_val_reg: register_block 
    generic map(8)
    port map(
           clr => clr,         
           ld => smallest_val_reg_ld,
           clk => clk,
           din => ram_dout,
           dout => smallest_val_reg_dout
         );
    current_val_reg: register_block 
    generic map(8)   
    port map(
           clr => clr,         
           ld => current_val_reg_ld,
           clk => clk,
           din => ram_dout,
           dout => current_val_reg_dout
            );
    smallest_index_reg: register_block 
    generic map(5)
    port map(
            
           clr => clr,         
           ld => smallest_index_reg_ld,
           clk => clk,
           din => addr_mux_dout,
           dout => smallest_index_reg_dout
            );
    comparator : comparator_block
    port map(
            dinA => ram_dout,
            dinB => smallest_val_reg_dout,
            dout => comp_out 
            );
    


end Behavioral;
