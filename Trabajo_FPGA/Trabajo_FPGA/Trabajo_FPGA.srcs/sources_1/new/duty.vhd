library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity duty is
    generic (
        bit_colours : natural := 4   --Número máx de colores = 2^bit_colours
        );
        
    port ( 
        up_bttn     : in STD_LOGIC;
        down_bttn   : in STD_LOGIC;
        CLK         : in STD_LOGIC;
        RST         : in STD_LOGIC;
        duty        : out STD_LOGIC_VECTOR ( bit_colours-1 downto 0)
        );
end duty;

architecture Behavioral of duty is
    signal d : integer := 0;
begin
    
    process (CLK, RST)
    begin
        if RST = '1' then
            d <= 0;                
        elsif rising_edge (CLK) then
            if up_bttn = '1' then
                d <= d + 1;
            elsif down_bttn = '1' then
                d <= d - 1;
            end if;        
        end if;             
    end process;
    
duty <= std_logic_vector( to_unsigned( d , bit_colours ));
end Behavioral;
