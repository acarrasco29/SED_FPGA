
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity EDGEDTCTR is
    port (
        CLK : in std_logic;
        SYNC_IN : in std_logic;
        EDGE : out std_logic
    );
end EDGEDTCTR;


architecture BEHAVIORAL of EDGEDTCTR is

    signal sreg : std_logic_vector(6 downto 0);
    
begin
    process (CLK)
    begin
        if rising_edge(CLK) then
            sreg <= sreg(5 downto 0) & SYNC_IN;
        end if;
    end process;
    with sreg select
        EDGE <= '1' when "1000000",
        '0' when others;
end BEHAVIORAL;