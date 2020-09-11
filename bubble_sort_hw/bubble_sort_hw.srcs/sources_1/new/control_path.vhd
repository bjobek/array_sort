----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 09/10/2020 03:11:17 PM
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

entity control_path is
  generic(
    addr_width : integer := 5;
    data_width : integer := 8
  );
  Port (
    rst,clk : in std_logic
     );
end control_path;

architecture Behavioral of control_path is


    component top_block
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
    prev_i_ld, curr_i_ld :in  std_logic;
    prev_v_ld, curr_v_ld :in  std_logic;
    prev_i_tick : out  std_logic;
    pc_ld, pc_dec : IN STD_LOGIC;
    pc_dout : out std_logic_vector(addr_width-1 downto 0);
    curr_i_inc, prev_i_inc : in std_logic;
    prev_i_rst,curr_i_rst : in std_logic;
    
    prev_idx_dout , curr_idx_dout : out std_logic_vector(addr_width-1 downto 0)

         
         );
    end component;

signal comp_out, mux_index_sel, mux_value_sel, ram_wr : std_logic;
signal prev_i_ld, curr_i_ld : std_logic;
signal prev_v_ld, curr_v_ld : std_logic;
signal prev_i_tick, pc_ld, pc_dec, curr_i_inc, prev_i_inc : std_logic;
type state is (S_STP, S_RST, S_LD_1, S_LD_2, S_SWP_1,S_SWP_2,S_COMP,S_INC_1,S_INC_2);
signal prest, nxtst: state;  -- present state, next state
signal pc_dout,prev_idx_dout , curr_idx_dout : std_logic_vector(addr_width-1 downto 0);
signal curr_i_rst, prev_i_rst : std_logic;
constant pc_max : integer := 2**addr_width -1;
begin

    uut: top_block
    port map(
            clk => clk,  rst => rst, comp_out => comp_out, mux_index_sel => mux_index_sel, mux_value_sel =>
                mux_value_sel, ram_wr => ram_wr, 
                prev_i_ld => prev_i_ld, curr_i_ld => curr_i_ld, prev_v_ld => prev_v_ld, 
                curr_v_ld => curr_v_ld, prev_i_tick => prev_i_tick, pc_ld => pc_ld, pc_dec => pc_dec,
                pc_dout => pc_dout, curr_i_inc => curr_i_inc, prev_i_inc => prev_i_inc,
                prev_idx_dout => prev_idx_dout, curr_idx_dout => curr_idx_dout, curr_i_rst => curr_i_rst, prev_i_rst => prev_i_rst
            );


-- state register
process (clk, rst)
begin
    
   if (rst = '1') then
   
	  prest <= S_RST; -- initial state
	  
   elsif rising_edge(clk) then
	  prest <= nxtst;
   end if;
end process;

-- next-state logic
process (prest, comp_out, pc_dout, prev_i_tick)
begin
   nxtst <= prest; -- stay in current state by default


   case prest is
      when S_STP =>
         
      when S_RST =>
        
      
        nxtst <= S_LD_1;
      when S_LD_1 =>
        if(unsigned(pc_dout) = 0) then
            nxtst <= S_STP;
        else
            nxtst <= S_LD_2;
        end if;
        
      when S_LD_2 =>
        nxtst <= S_COMP;
      when S_SWP_1 =>
        nxtst <= S_SWP_2;
      when S_SWP_2 =>
        nxtst <= S_INC_1;
      when S_COMP =>
       
       -- if(prev_i_tick = '1') then
        if(unsigned(prev_idx_dout) = unsigned(pc_dout )+1) then
              curr_i_rst <='1';
              prev_i_rst <='1';
      
            nxtst <= S_LD_1;
        elsif(comp_out = '1') then
            nxtst <= S_SWP_1;
        else 
            nxtst <= S_INC_1;
        end if;
      
      when S_INC_1 =>
        nxtst<=S_INC_2;
      when S_INC_2 =>
        nxtst <= S_COMP;
         
   end case;
end process;

-- Moore outputs logic
process (prest)
begin
   -- rst <= '0';
      curr_i_rst <='0';
    prev_i_rst <='0';
    mux_index_sel <= '0';
    mux_value_sel <= '0';
    ram_wr <= '0';

    prev_i_ld <= '0';
    curr_i_ld <= '0';
    prev_v_ld <= '0';
    curr_v_ld <= '0';
    pc_ld <= '0'; 
    pc_dec <='0';
    curr_i_inc <= '0';
    prev_i_inc <= '0';
    
   case prest is 
   
      when S_STP =>
         
      when S_RST =>
        curr_i_rst <='1';
        prev_i_rst <='1';
      when S_LD_1 =>
      --  curr_i_ld <= '1';
        prev_i_ld <='1';
        prev_v_ld <= '1';
        mux_index_sel <= '0';
        curr_i_inc <= '1';  
      when S_LD_2 =>
      --  prev_i_ld <='1';
        curr_v_ld <='1';
        pc_dec <='1';
      when S_SWP_1 =>
      --  mux_index_sel <= '1';

        mux_value_sel <= '1';
           
        ram_wr <='1';
      when S_SWP_2 =>
        mux_index_sel <= '1';

        mux_value_sel <= '0';
    
        ram_wr <='1';
      when S_COMP =>
        
        
      
      when S_INC_1 =>
        mux_index_sel <= '0';
        prev_v_ld <='1';
        curr_i_inc <= '1';
        prev_i_ld <='1';
      when S_INC_2 =>
        mux_index_sel <= '0';
        curr_v_ld <='1';
   
   end case;
end process;
       


end Behavioral;
