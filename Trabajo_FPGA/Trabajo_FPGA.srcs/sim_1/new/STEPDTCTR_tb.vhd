
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity STEPDTCTR_TB is
end STEPDTCTR_TB;

architecture Behavioral of STEPDTCTR_TB is

    component STEPDTCTR
        port (
            CLK : in std_logic;
            SYNC_IN : in std_logic;
            STP : out std_logic
        );
    end component;

    constant CLK_PERIOD : time := 10 ns;

    signal CLK : std_logic := '0';
    signal SYNC_IN : std_logic := '0';
    signal STP : std_logic;

begin

    uut: STEPDTCTR
        port map (
            CLK => CLK,
            SYNC_IN => SYNC_IN,
            STP => STP
        );

    CLK <= not CLK after 0.5 * CLK_PERIOD;

    SYNC_IN <= '0', '1' after 2 * CLK_PERIOD, '0' after 8 * CLK_PERIOD,
               '1' after 10 * CLK_PERIOD, '0' after 16 * CLK_PERIOD;

    stim_proc: process
    begin
        wait for 20 * CLK_PERIOD;
        
        assert STP = '0' report "[FAILED] no ha funcionado correctamente" severity failure;
        assert false report "[SUCCESS]: Detector de senial estable completado correctamente" severity failure;
     
        
    end process;

end Behavioral;
