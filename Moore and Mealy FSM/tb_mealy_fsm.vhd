library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity tb_mealy_fsm is
end tb_mealy_fsm;

architecture behavior of tb_mealy_fsm is

    -- Component Declaration
    component mealy_fsm
        Port (
            clk   : in  STD_LOGIC;
            reset : in  STD_LOGIC;
            x     : in  STD_LOGIC;
            y     : out STD_LOGIC
        );
    end component;

    -- Testbench signals
    signal clk_tb   : STD_LOGIC := '0';
    signal reset_tb : STD_LOGIC := '0';
    signal x_tb     : STD_LOGIC := '0';
    signal y_tb     : STD_LOGIC;

    constant clk_period : time := 10 ns;

begin

    --------------------------------------------------------------------
    -- Instantiate DUT
    --------------------------------------------------------------------
    uut: mealy_fsm
        port map (
            clk   => clk_tb,
            reset => reset_tb,
            x     => x_tb,
            y     => y_tb
        );

    --------------------------------------------------------------------
    -- Clock generation
    --------------------------------------------------------------------
    clk_process : process
    begin
        clk_tb <= '0';
        wait for clk_period / 2;
        clk_tb <= '1';
        wait for clk_period / 2;
    end process;

    --------------------------------------------------------------------
    -- Input stimulus
    --------------------------------------------------------------------
    stim_proc: process
    begin
        -- Reset pulse
        reset_tb <= '1';
        wait for 20 ns;
        reset_tb <= '0';
        wait for 20 ns;

        -- Apply bit stream:
        -- 1 0 1 1 0 1 0 1
        -- Mealy output y_tb should pulse during the '1' in "101"

        x_tb <= '1'; wait for clk_period;
        x_tb <= '0'; wait for clk_period;
        x_tb <= '1'; wait for clk_period;  -- detect 101: y_tb = 1 (pulse)

        x_tb <= '1'; wait for clk_period;
        x_tb <= '0'; wait for clk_period;
        x_tb <= '1'; wait for clk_period;  -- detect again

        x_tb <= '0'; wait for clk_period;
        x_tb <= '1'; wait for clk_period;  -- detect again

        wait for 40 ns;

        assert false report "Simulation Complete" severity failure;
    end process;

end behavior;
