library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity mealy_fsm is
    Port (
        clk   : in  STD_LOGIC;
        reset : in  STD_LOGIC;
        x     : in  STD_LOGIC;
        y     : out STD_LOGIC        -- Mealy output
    );
end mealy_fsm;

architecture Behavioral of mealy_fsm is

    -- State Encoding
    type state_type is (S0, S1, S2);
    signal current_state, next_state : state_type;

begin

    --------------------------------------------------------------------
    -- 1. State Register
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
    -- 2. Next State Logic + Mealy Output
    --------------------------------------------------------------------
    process(current_state, x)
    begin
        -- Default values
        y <= '0';
        case current_state is

            -- No match yet
            when S0 =>
                if x = '1' then
                    next_state <= S1;
                else
                    next_state <= S0;
                end if;

            -- Saw '1'
            when S1 =>
                if x = '0' then
                    next_state <= S2;
                else
                    next_state <= S1;
                end if;

            -- Saw "10"
            when S2 =>
                if x = '1' then
                    next_state <= S1;
                    y <= '1';     -- Mealy output: sequence "101" found!
                else
                    next_state <= S0;
                end if;

        end case;
    end process;

end Behavioral;
