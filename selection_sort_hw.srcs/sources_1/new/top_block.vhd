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

entity top_block is
  
    Port (
        -- common ports 
       
        clk : in STD_LOGIC;
        rst : in STD_LOGIC
        -- current index ctr
        
       -- tmp_index_ctr
       -- 3:1 addr  mux
       
       -- 2:1 value mux
       -- ram

       -- smallest value register
       -- current value register
       -- smallest index register 
       -- comparator 
         );
end top_block;

architecture Behavioral of top_block is
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

    type state is (S0, S1, S2, S3,S4,S5,S6);
    signal prest, nxtst: state;  -- present state, next state
    
    signal clr : std_logic;
    -- current index ctr
    signal current_index_ctr_ld : std_logic;
    signal current_index_ctr_dout : std_logic_vector(addr_width-1 downto 0); 
    signal current_index_ctr_tick : std_logic;
    signal current_index_ctr_inc : std_logic;
   -- tmp_index_ctr
   
    signal tmp_index_ctr_ld : std_logic;
    signal tmp_index_ctr_inc : STD_LOGIC;
    signal tmp_index_ctr_dout : std_logic_vector(addr_width-1 downto 0); 
    signal tmp_index_ctr_tick : std_logic;
   -- 3:1 addr  mux
    signal addr_mux_dout : std_logic_vector(addr_width-1 downto 0);
    signal addr_mux_sel : std_logic_vector(1 downto 0);
   -- 2:1 value mux
    signal value_mux_dout : std_logic_vector(data_width-1 downto 0);
    signal value_mux_sel : std_logic_vector(1 downto 0);
   -- ram
   signal ram_wr : std_logic;
   signal ram_addr : std_logic_vector(addr_width-1 downto 0);
   signal ram_dout : std_logic_vector(data_width-1 downto 0);
   -- smallest value register
   signal  smallest_val_reg_dout : std_logic_vector(data_width-1 downto 0);
   signal smallest_val_reg_ld : std_logic;
   -- current value register
   signal  current_val_reg_dout : std_logic_vector(data_width-1 downto 0);
   signal current_val_reg_ld : std_logic;
   -- smallest index register
   signal  smallest_index_reg_dout : std_logic_vector(addr_width-1 downto 0);
   signal smallest_index_reg_ld : std_logic; 
   -- comparator 
   signal comp_out : std_logic;

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
            addr => to_integer(unsigned(addr_mux_dout)), -- type cast to natural
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
    




-- state register
process (clk, rst)
begin
   if (rst = '1') then
	  prest <= S0; -- initial state
   elsif rising_edge(clk) then
	  prest <= nxtst;
   end if;
end process;

-- next-state logic
process (prest,tmp_index_ctr_tick,current_index_ctr_tick)
begin
   nxtst <= prest; -- stay in current state by default
  
   case prest is
      when S0 =>
        
          nxtst <= S1;
      when S1 =>
         
          
          nxtst <= S2;
      when S2 =>
        
         if (tmp_index_ctr_tick='1') then
             if(current_index_ctr_tick = '1') then
                 nxtst<= S6;
             else
                 nxtst<= S4;
             end if;

                 
         else
             
             nxtst <= S3;
         end if;
      when S3 =>
       
     
        
        nxtst <= S2;
      when S4 =>
         
          nxtst <= S5;
      when S5 =>
          
          nxtst <= S1; 
      when S6 =>
          

   end case;
end process;

       
-- Mealy outputs logic 
process (prest,comp_out)
begin
    --Default Values
   current_index_ctr_inc <= '0';
   tmp_index_ctr_inc <= '0';
   current_val_reg_ld <= '0';
   smallest_val_reg_ld<= '0';
   smallest_index_reg_ld<='0';
   tmp_index_ctr_ld <='0';
   clr <= '0';
   addr_mux_sel <= "10"; -- tmp_index_ctr
   ram_wr <= '0';
   
   case prest is 
      when S0=>
          clr <= '1';
          addr_mux_sel <= "10"; -- tmp_index_ctr
      when S1=>
          current_val_reg_ld <= '1';
          smallest_val_reg_ld<= '1';
          smallest_index_reg_ld<='1';
          tmp_index_ctr_ld <='1';
      when S2=>
      
      when S3=>
        tmp_index_ctr_inc<='1';
         if (comp_out = '1') then
            smallest_index_reg_ld<='1';
            smallest_val_reg_ld<='1';        
         end if;
        
      when S4=>
          addr_mux_sel <= "00";
          value_mux_sel<= "00";
          ram_wr<='1'; 
      when S5=>
          addr_mux_sel <= "01";
          value_mux_sel<= "01";
          ram_wr<='1';
          current_index_ctr_inc <= '1';
          
      
      when S6=> 
    

   end case;
end process;

end Behavioral;
