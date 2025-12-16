
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;


entity duty is

    generic (
        bit_colours : natural := 4   --Número máx de colores = 2^bit_colours
        );
        
    port ( 
        up_bttn   : in STD_LOGIC;
        down_bttn : in STD_LOGIC;
        CLK       : in STD_LOGIC;
        RST_n       : in STD_LOGIC;
        duty      : out STD_LOGIC_VECTOR ( bit_colours-1 downto 0)
        );
        
end duty;

architecture Behavioral of duty is

    constant max_val : integer := (2**bit_colours) - 1;
    constant prescaler : integer := 10000000;
    
    signal aux: integer range 0 to prescaler; 
    signal d : integer := 0;
    signal CLK_d: std_logic;
    
begin
    process (CLK)
    begin
        if rising_edge(CLK) then
            CLK_d <= '0'; 
        
            if aux = prescaler then
                aux   <= 0;
                CLK_d <= '1';  
            else
                aux <= aux + 1;
            end if;
        end if;
    end process;
    
    process (CLK_d, RST_n)
    begin
        if RST_n = '0' then
            d <= 0;     
                       
        elsif rising_edge (CLK_d) then
            if up_bttn = '1' then
                if d < max_val then
                    d <= d + 1;
                else
                    d <= max_val;
                end if;

            elsif down_bttn = '1' then
                if d > 0 then
                    d <= d - 1;
                else
                    d <= 0;
                end if;
            end if;        
        end if;             
    end process;
    
duty <= std_logic_vector( to_unsigned( d , bit_colours ));

end Behavioral;
