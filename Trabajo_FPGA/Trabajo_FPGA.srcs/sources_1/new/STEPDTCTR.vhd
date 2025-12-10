

library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

--Detecta una señal estable durante tres cilos de reloj.

entity STEPDTCTR is
    port (
        CLK : in std_logic;
        SYNC_IN : in std_logic;
        STP : out std_logic
    );
end STEPDTCTR;


architecture BEHAVIORAL of STEPDTCTR is

    signal sreg : std_logic_vector(2 downto 0);
    
begin
    process (CLK)
    begin
        if rising_edge(CLK) then
            sreg <= sreg(1 downto 0) & SYNC_IN;
        end if;
    end process;
    with sreg select
        STP <= '1' when "111",
        '0' when others;
end BEHAVIORAL;