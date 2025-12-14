
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity EDGEDTCTR_TB is
end EDGEDTCTR_TB;

architecture Behavioral of EDGEDTCTR_TB is

    component EDGEDTCTR
        port (
            CLK : in std_logic;
            SYNC_IN : in std_logic;
            EDGE : out std_logic
        );
    end component;

    constant CLK_PERIOD : time := 10 ns;

    signal CLK : std_logic := '0';
    signal SYNC_IN : std_logic := '0';
    signal EDGE : std_logic;

begin

    uut: EDGEDTCTR
        port map (
            CLK => CLK,
            SYNC_IN => SYNC_IN,
            EDGE => EDGE
        );

    CLK <= not CLK after 0.5 * CLK_PERIOD;

    SYNC_IN <= '0', 
               '1' after 2 * CLK_PERIOD, 
               '0' after 5 * CLK_PERIOD,
               '1' after 8 * CLK_PERIOD, 
               '0' after 11 * CLK_PERIOD;

    stim_proc: process
    begin
        wait for 15 * CLK_PERIOD;
        
        assert EDGE = '0'  report "[FAILED] no ha funcionado correctamente" severity failure;
        assert false report "[SUCCESS]: Detector de flancos de bajada completado correctamente" severity failure;
        
    end process;

end Behavioral;
