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

entity control_path_block_tmp is
  
    Port (
        -- common ports 
       
        clk : in STD_LOGIC;
        rst : in STD_LOGIC
    
         );
end control_path_block_tmp;

architecture Behavioral of control_path_block_tmp is
       constant M : integer := 8;                
       constant MAX : integer := 5;
       constant data_width : integer := 8;
       constant addr_width : integer := 5;
 
    type state is (S0, S1, S2, S3,S4,S5,S6);
    signal prest, nxtst: state;  -- present state, next state
    


-- instantiate components
component top_block_tmp is
  
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
end component;
        signal clr : std_logic;
      signal  current_index_ctr_inc :  std_logic;
      signal    current_index_ctr_ld :  std_logic;
       signal   tmp_index_ctr_ld :  std_logic;
       signal  tmp_index_ctr_inc :  STD_LOGIC;
      signal     addr_mux_sel :  std_logic_vector(1 downto 0);
     signal value_mux_sel :  std_logic_vector(1 downto 0);
   signal ram_wr :  std_logic;
   signal smallest_val_reg_ld :  std_logic;
   signal    current_val_reg_ld :  std_logic;
     signal     smallest_index_reg_ld :  std_logic; 
    signal comp_out :  std_logic;
  signal   tmp_index_ctr_tick :   std_logic;
   signal  current_index_ctr_tick :  std_logic;


begin

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
          
          nxtst <= S6; 
      when S6 =>
          nxtst <= S1;
          

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
   current_index_ctr_ld <='0';
   value_mux_sel<= "00"; -- smallest val

   clr <= '0';
   ram_wr <= '0';
   
   case prest is 
      when S0=>
          clr <= '1';
          addr_mux_sel <= "10"; -- tmp_index_ctr
          
      when S1=>
          current_val_reg_ld <= '1';
          smallest_val_reg_ld<= '1';
          smallest_index_reg_ld<='1';
          --tmp_index_ctr_ld <='1';
      when S2=>
      
      when S3=>
        tmp_index_ctr_inc<='1';
         if (comp_out = '1') then
            smallest_index_reg_ld<='1';
            smallest_val_reg_ld<='1';        
         end if;
        
      when S4=>
          addr_mux_sel <= "00"; -- current_idx
          value_mux_sel<= "00"; -- smallest val
          ram_wr<='1'; 
          current_index_ctr_inc <= '1';

      when S5=>
          tmp_index_ctr_ld <='1';

          addr_mux_sel <= "01"; -- smallest idx
          value_mux_sel<= "01"; -- current val
          ram_wr<='1';
          
      
      when S6=> 
          addr_mux_sel <= "10"; -- tmp_index_ctr


   end case;
end process;

end Behavioral;
