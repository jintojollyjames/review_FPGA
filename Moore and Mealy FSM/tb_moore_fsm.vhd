library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity tb_moore_fsm is
end tb_moore_fsm;

architecture behavior of tb_moore_fsm is

    -- Component Declaration for the Unit Under Test (UUT)
    component moore_fsm
        Port (
            clk   : in  STD_LOGIC;
            reset : in  STD_LOGIC;
            x     : in  STD_LOGIC;
            y     : out STD_LOGIC
        );
    end component;

    -- Testbench Signals
    signal clk_tb   : STD_LOGIC := '0';
    signal reset_tb : STD_LOGIC := '0';
    signal x_tb     : STD_LOGIC := '0';
    signal y_tb     : STD_LOGIC;

    -- Clock period
    constant clk_period : time := 10 ns;

begin

    --------------------------------------------------------------------
    -- Instantiate the Unit Under Test (UUT)
    --------------------------------------------------------------------
    uut: moore_fsm
        port map (
            clk   => clk_tb,
            reset => reset_tb,
            x     => x_tb,
            y     => y_tb
        );

    --------------------------------------------------------------------
    -- Clock Generation Process
    --------------------------------------------------------------------
    clk_process : process
    begin
        clk_tb <= '0';
        wait for clk_period / 2;
        clk_tb <= '1';
        wait for clk_period / 2;
    end process;

    --------------------------------------------------------------------
    -- Stimulus Process
    --------------------------------------------------------------------
    stim_proc: process
    begin

        -- Apply reset
        reset_tb <= '1';
        wait for 20 ns;
        reset_tb <= '0';
        wait for 20 ns;

        -- Test Input Sequence
        -- This applies: 1 0 1 1 0 1 0 1
        -- The FSM should detect "101" at specific points.

        x_tb <= '1'; wait for clk_period;
        x_tb <= '0'; wait for clk_period;
        x_tb <= '1'; wait for clk_period;  -- <-- FSM should output 1 here (state S3)

        x_tb <= '1'; wait for clk_period;
        x_tb <= '0'; wait for clk_period;
        x_tb <= '1'; wait for clk_period;  -- <-- FSM should output 1 again

        x_tb <= '0'; wait for clk_period;
        x_tb <= '1'; wait for clk_period;  -- <-- FSM should output 1 again

        -- Finish test
        wait for 50 ns;
        assert false report "Simulation End" severity failure;

    end process;

end behavior;
