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

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity top_block is
    generic(
        M : integer := 8;                
        MAX : integer := 5;
        data_width : integer := 8;
        addr_width : integer := 5
           );
    Port (
        -- common ports 
        clr : in STD_LOGIC;
        clk : in STD_LOGIC
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

   component comparator_block is
            Port ( dinA : in STD_LOGIC_VECTOR(M-1 downto 0);
                   dinB : in STD_LOGIC_VECTOR(M-1 downto 0);
                   dout : out STD_LOGIC);
   end component;

    component counter_block is
        Port ( clr : in STD_LOGIC;
               ld : in STD_LOGIC;
               tick : in std_logic;
               inc : in STD_LOGIC;
               clk : in STD_LOGIC;
               din : in STD_LOGIC_VECTOR(MAX-1 downto 0);
               dout : out STD_LOGIC_VECTOR(MAX-1 downto 0));
    end component;
   
    component mux_block is
        Port ( dinA : in STD_LOGIC_VECTOR(data_width-1 downto 0);
               dinB : in STD_LOGIC_VECTOR(data_width-1 downto 0);
               dinC : in STD_LOGIC_VECTOR(data_width-1 downto 0);
               sel  : in std_logic_vector(1 downto 0);
               dinD : in STD_LOGIC_VECTOR(data_width-1 downto 0);
               dout : out STD_LOGIC_VECTOR(data_width-1 downto 0));
    end component;

    component single_port_ram is
        port
        (
            din	: in std_logic_vector(data_width-1 downto 0);
            addr	: in natural range 0 to 2**addr_width-1;
            wr		: in std_logic;
            clk		: in std_logic;
            dout		: out std_logic_vector(7 downto 0)
        );
    end component ;
   
    component register_block is
        Port ( clr : in STD_LOGIC;
               ld : in STD_LOGIC;
                clk : in STD_LOGIC;
               din : in STD_LOGIC;
               dout : out STD_LOGIC);
    end component;

    type state is (S0, S1, S2, S3,S4,S5);
    signal prest, nxtst: state;  -- present state, next state

    -- current index ctr
    signal current_index_ctr_ld : std_logic;
    signal current_index_ctr_dout : std_logic_vector(data_width-1 downto 0); 
    signal current_index_ctr_tick : std_logic;
    signal current_index_ctr_inc : std_logic;
   -- tmp_index_ctr
    signal tmp_index_ctr_ld : std_logic;
    signal tmp_index_ctr_tmp : STD_LOGIC;
    signal tmp_index_ctr_dout : std_logic_vector(data_width-1 downto 0); 
    signal tmp_index_ctr_tick : std_logic;
    signal tmp_index_ctr_din : std_logic_vector(data_width-1 downto 0);
   -- 3:1 addr  mux
    signal addr_mux_dinA : std_logic_vector(data_width-1 downto 0);
    signal addr_mux_dinB : std_logic_vector(data_width-1 downto 0);
    signal addr_mux_dinC : std_logic_vector(data_width-1 downto 0);
    signal addr_mux_dout : std_logic_vector(data_width-1 downto 0);
    signal addr_mux_sel : std_logic_vector(1 downto 0);
   -- 2:1 value mux
    signal value_mux_dinA : std_logic_vector(data_width-1 downto 0);
    signal value_mux_dinB : std_logic_vector(data_width-1 downto 0);
    signal value_mux_dout : std_logic_vector(data_width-1 downto 0);
    signal value_mux_sel : std_logic_vector(1 downto 0);
   -- ram
   signal ram_wr : std_logic;
   signal ram_din, ram_dout : std_logic_vector(data_width-1 downto 0);
   signal ram_addr : std_logic_vector(addr_width-1 downto 0);
   -- smallest value register
   signal smallest_val_reg_din, smallest_val_reg_dout : std_logic_vector(data_width-1 downto 0);
   signal smallest_val_reg_ld : std_logic;
   -- current value register
   signal current_val_reg_din, current_val_reg_dout : std_logic_vector(data_width-1 downto 0);
   signal current_val_reg_ld : std_logic;
   -- smallest index register
   signal smallest_index_reg_din, smallest_index_reg : std_logic_vector(data_width-1 downto 0);
   signal smallest_index_reg_ld : std_logic; 
   -- comparator 
   signal comp_dinA, comp_dinB : std_logic_vector(data_width-1 downto 0);
   signal comp_out : std_logic;

begin
-- instantiate components

    current_index_ctr: counter_block
    port map(   
            ld => current_index_ctr_ld, 
            inc => current_index_ctr_inc,
            clr => clr,
            clk => clk,
            tick => current_index_ctr_tick,
            din => open,
            dout => current_index_ctr_dout
            );
    tmp_index_ctr: counter_block
    port map(
            ld => tmp_index_ctr_ld, 
            inc => tmp_index_ctr_inc,
            clr => clr,
            clk => clk,
            tick => tmp_index_ctr_tick,
            din => current_index_ctr_dout
            dout => tmp_index_ctr_dout
            );
    addr_mux: mux_block
    port map();
    value_mux: mux_block
    port map();
    ram: single_port_ram 
    port map();
    smallest_val_reg: register_block 
    port map();
    current_val_reg: register_block 
    port map();
    smallest_index_reg: register_block 
    port map();
    comparator : comparator_block
    port map();
    




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
process (prest, _din_, _din_, ...)
begin
   nxtst <= prest; -- stay in current state by default

   case prest is
      when S0 =>
         if _condition_ then nxtst <= _st_;
            else nxtst <= _st_; -- unnecessary if the same
         end if;
      when S1 =>
         if _condition_ then nxtst <= _st_;
            else nxtst <= _st_;
         end if;

      ...

         end if;
   end case;
end process;

-- Moore outputs logic
process (prest)
begin
   case prest is 
      when _st_ | _st_ | _st_ | ... =>  
         _dout_ <= '0';
      when _st_ | _st_ | ... =>
         _dout_ <= '1'; 
   end case;
end process;
       
-- Mealy outputs logic 
process (prest, _din_, _din_, ...)
begin
   case prest is 
      when _st_ =>
         if _condition_ then 
            _dout_ <= '0';
         else
            _dout_ <= '1';
      when _st_ =>
         if _condition_ then 
            _dout_ <= '0';
         else
            _dout_ <= '1';
      ...

   end case;
end process;



end Behavioral;
