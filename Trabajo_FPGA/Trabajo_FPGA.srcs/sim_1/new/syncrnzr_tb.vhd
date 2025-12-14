
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity SYNCHRNZR_TB is
end SYNCHRNZR_TB;

architecture Behavioral of SYNCHRNZR_TB is

    component SYNCHRNZR
        port (
            CLK      : in std_logic;
            ASYNC_IN : in std_logic;
            SYNC_OUT : out std_logic
        );
    end component;

    constant CLK_PERIOD : time := 10 ns;

    signal CLK      : std_logic := '0';
    signal ASYNC_IN : std_logic := '0';
    signal SYNC_OUT : std_logic;

begin

    uut: SYNCHRNZR
        port map (
            CLK      => CLK,
            ASYNC_IN => ASYNC_IN,
            SYNC_OUT => SYNC_OUT
        );

    CLK <= not CLK after 0.5 * CLK_PERIOD;

    ASYNC_IN <= '0',
                '1' after 2 * CLK_PERIOD, 
                '0' after 5 * CLK_PERIOD, 
                '1' after 8 * CLK_PERIOD, 
                '0' after 11 * CLK_PERIOD;

    stim_proc: process
    begin
        wait for 15 * CLK_PERIOD;
        
        assert SYNC_OUT = '0' report "[FAILED] no ha funcionado correctamente" severity failure; 
        assert false report "[SUCCESS]: Sincronizacion completada correctamente" severity failure;
        
    end process;

end Behavioral;
