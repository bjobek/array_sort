library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity control_path is
    port
    (
        clk: in std_logic;
        rst: in std_logic
    );
end control_path;

architecture Behavioral of control_path is
    type state is (S_RST, S_LD1, S_LD2, S_COMP, S_SWP1, S_SWP2, S_DEC, S_INC);
    signal pre_state, nxt_state: state;  -- present state, next state

    -- program counter
    signal PC: std_logic;

    -- curr_index_val counter
    signal curr_index_val_load: std_logic;
    signal curr_index_val_reset: std_logic;
    signal curr_index_val_dec: std_logic;
    signal curr_index_val_tick: std_logic;
    signal curr_index_val_data: std_logic;

    -- prev_index_val counter
    signal prev_index_val_load: std_logic;
    signal prev_index_val_reset: std_logic;
    signal prev_index_val_dec: std_logic;
    signal prev_index_val_data: std_logic;

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
        curr_i_tick => curr_index_val_tick,
        prev_idx_dout => prev_index_val_data,
        curr_idx_dout => curr_index_val_data,

        curr_i_din => PC, -- feil
        prev_i_din => (PC-1) -- feil
    );

    -- state register
    process (clk, rst)
    begin
        if (rst = '1') then
            pre_state <= S0; -- initial state
        elsif rising_edge(clk) then
            pre_state <= nxt_state;
        end if;
    end process;

    -- next-state logic
    process (pre_state, curr_index_val_tick, comp)
    begin
        nxt_state <= pre_state; -- stay in current state by default

        case pre_state is
            when S_RST =>
                nxt_state <= S_LD1;

            when S_LD1 =>
                if (curr_index_val_tick = '1') then
                    nxt_state <= S_RST;
                else
                    nxt_state <= S_LD2;
                end if;
            
            when S_LD2 =>
                nxt_state <= S_COMP;
            
            when S_COMP =>
                if comp = '1' then
                    nxt_state <= S_SWP1;
                elsif prev_index_val_data = '0' then
                    nxt_state <= S_INC;
                else
                    nxt_state <= S_DEC;
                end if;
            
            when S_SWP1 =>
                nxt_state <= S_SWP2;
            
            when S_SWP2 =>
                nxt_state <= S_COMP;
            
            when S_DEC =>
                nxt_state <= S_COMP;

            when S_INC =>
                nxt_state <= S_LD1;
        end case;
    end process;

    -- Moore outputs logic 
    process (pre_state, _din_, _din_, ...)
    begin
        -- Init values
        curr_index_val_load <= '0';
        curr_index_val_reset <= '0';
        curr_index_val_inc <= '0';
        curr_index_val_tick <= '0';

        case pre_state is 
            when S_RST =>
                PC <= '1';
                ram_reset <= '1';

            when S_LD1 =>
                curr_index_val_load <= '1';
                mux_index_control <= '0';

            when S_LD2 =>
                prev_index_val_load <= '1';
                mux_index_control <= '1';

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

            when S_DEC =>
                curr_index_val_dec <= '1';
                prev_index_val_dec <= '1';
        end case;
    end process;

end Behavioral;
