library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity control_path is
    generic(
        data_width : integer := 8;
        addr_width : integer := 5
    );
    port
    (
        clk: in std_logic;
        rst: in std_logic
    );
end control_path;

architecture Behavioral of control_path is
    type state is (S_RST, S_LD1, S_LD2, S_COMP, S_SWP1, S_SWP2, S_DEC_1,S_DEC_2, S_INC,S_STP);
    signal pre_state, nxt_state: state;  -- present state, next state

    -- program counter
    signal PC: unsigned(addr_width-1 downto 0);
    signal PC_1 : unsigned(addr_width-1 downto 0);

    -- curr_index_val counter
    signal curr_index_val_load: std_logic;
    signal curr_index_val_reset: std_logic;
    signal curr_index_val_dec: std_logic;
    signal curr_index_val_data: std_logic_vector(addr_width-1 downto 0);

    -- prev_index_val counter
    signal prev_index_val_load: std_logic;
    signal prev_index_val_reset: std_logic;
    signal prev_index_val_dec: std_logic;
    signal prev_index_val_data: std_logic_vector(addr_width-1 downto 0);

    -- mux_index
    signal mux_index_control: std_logic;

    -- mux_val
    signal mux_val_control: std_logic;
    
    -- RAM
    signal ram_wr: std_logic;
    signal ram_reset: std_logic;

    -- curr_val register
    signal curr_val_reg_load: std_logic;
    signal curr_val_reg_clear: std_logic;

    -- prev_val register
    signal prev_val_reg_load: std_logic;
    signal prev_val_reg_clear: std_logic;

    -- comparator
    signal comp: std_logic;

begin
    top: entity work.top_block(Behavioral)
    generic map(data_width => 8, addr_width => 5)
    port map
    (
        clk => clk,
        rst => rst,
        comp_out => comp,
        mux_index_sel => mux_index_control,
        mux_value_sel => mux_val_control,
        ram_wr => ram_wr,
       
        prev_i_ld => prev_index_val_load,
        curr_i_ld => curr_index_val_load,
        prev_v_ld => prev_val_reg_load,
        curr_v_ld => curr_val_reg_load,
        prev_idx_dout => prev_index_val_data,
        curr_idx_dout => curr_index_val_data,
        curr_i_dec => curr_index_val_dec,
        prev_i_dec => prev_index_val_dec,
        curr_i_din => std_logic_vector(PC), -- feil
        prev_i_din => std_logic_vector((PC_1)) -- feil
    );

    -- state register
    process (clk, rst)
    begin
        if (rst = '1') then
            pre_state <= S_RST; -- initial state
        elsif rising_edge(clk) then
            pre_state <= nxt_state;
        end if;
    end process;

    -- next-state logic
    process (pre_state, comp)
    begin
        nxt_state <= pre_state; -- stay in current state by default

        case pre_state is
            when S_STP =>
                nxt_state <= S_STP;
        
            when S_RST =>
                nxt_state <= S_LD1;
                

            when S_LD1 =>
               
                    nxt_state <= S_LD2;
            
            when S_LD2 =>
                if (unsigned(prev_index_val_data) = ("11111")) then
                    nxt_state <= S_STP;
                else
                    nxt_state <= S_COMP;
                end if;            
            when S_COMP =>
                if comp = '1' then
                    nxt_state <= S_SWP1;
                elsif unsigned(prev_index_val_data) = "00000" then
                    nxt_state <= S_INC;
                else
                    nxt_state <= S_DEC_1;
                end if;
            
            when S_SWP1 =>
                nxt_state <= S_SWP2;
            
            when S_SWP2 =>
                nxt_state <= S_DEC_1;
            
            when S_DEC_1 =>
                if unsigned(prev_index_val_data) = "00000" then
                nxt_state <= S_INC;
                else
                
                nxt_state <= S_DEC_2;
                end if;
            when S_DEC_2 =>
                nxt_state <= S_COMP;

            when S_INC =>
                nxt_state <= S_LD1;
        end case;
    end process;

    -- Moore outputs logic 
    process (pre_state)
    begin
        -- Init values
        ram_reset <= '0';

        curr_index_val_load <= '0';
        curr_index_val_reset <= '0';
        curr_index_val_dec <= '0';
         prev_index_val_load <= '0';
        prev_index_val_reset <= '0';
        prev_index_val_dec <= '0';
        ram_wr <='0';
        mux_val_control <='0';
        mux_index_control <='0';
        curr_val_reg_load <='0';
        prev_val_reg_load <='0';
        curr_val_reg_clear <='0';
        prev_val_reg_clear <='0';
  

        case pre_state is 
            when S_STP =>
            
            when S_RST =>
                
                PC <= "00001";
                PC_1<="00000";
                ram_reset <= '1';
                curr_val_reg_clear<='1';
                prev_val_reg_clear<='1';

            when S_LD1 =>
                curr_index_val_load <= '1';
                 prev_index_val_load <= '1';
                prev_val_reg_load<='1';
                mux_index_control <= '1'; -- prev

            when S_LD2 =>
               
               -- mux_index_control <= '1';
                curr_val_reg_load <='1';

            when S_COMP =>
               -- there is no Moore logic in this state

            when S_SWP1 =>
                mux_val_control <= '1';
                ram_wr <= '1';

            when S_SWP2 =>
                mux_val_control <= '0';
                mux_index_control <= '1';
                ram_wr <= '1';

            when S_INC =>
                PC <= unsigned(PC + 1); -- feil
                PC_1 <= unsigned(PC_1 + 1);
                prev_index_val_load<='1';

            when S_DEC_1 =>
                mux_index_control <='1';

                
                prev_index_val_dec <= '1';
                 --prev_val_reg_load<='1';
                 curr_val_reg_load <='1';
            when S_DEC_2 =>
                curr_index_val_dec <= '1';
                mux_index_control <='1';

                 prev_val_reg_load<='1';
                -- curr_val_reg_load <='1';


             --PC <= unsigned(PC -1 ); -- feil
               -- PC_1 <= unsigned(PC_1 - 1);
                

        end case;
    end process;

end Behavioral;
