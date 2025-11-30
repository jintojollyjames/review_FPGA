library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity moore_fsm is
    Port (
        clk   : in  STD_LOGIC;
        reset : in  STD_LOGIC;
        x     : in  STD_LOGIC;     -- input bit stream
        y     : out STD_LOGIC      -- Moore output
    );
end moore_fsm;

architecture Behavioral of moore_fsm is

    -- State Encoding
    type state_type is (S0, S1, S2, S3);
    signal current_state, next_state : state_type;

begin

    --------------------------------------------------------------------
    -- 1. State Register (clocked)
    --------------------------------------------------------------------
    process(clk, reset)
    begin
        if reset = '1' then
            current_state <= S0;
        elsif rising_edge(clk) then
            current_state <= next_state;
        end if;
    end process;

    --------------------------------------------------------------------
    -- 2. Next State Logic (combinational)
    --------------------------------------------------------------------
    process(current_state, x)
    begin
        case current_state is

            when S0 =>
                if x = '1' then
                    next_state <= S1;
                else
                    next_state <= S0;
                end if;

            when S1 =>
                if x = '0' then
                    next_state <= S2;
                else
                    next_state <= S1;
                end if;

            when S2 =>
                if x = '1' then
                    next_state <= S3;
                else
                    next_state <= S0;
                end if;

            when S3 =>  -- final state
                if x = '1' then
                    next_state <= S1;
                else
                    next_state <= S2;
                end if;

        end case;
    end process;

    --------------------------------------------------------------------
    -- 3. Output Logic (Moore: depends only on current_state)
    --------------------------------------------------------------------
    y <= '1' when current_state = S3 else '0';

end Behavioral;
