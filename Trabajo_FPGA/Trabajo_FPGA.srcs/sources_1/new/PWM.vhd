
library ieee; 
use ieee.std_logic_1164.all; 
use ieee.numeric_std.all;
 
 
entity PWM is
 
    generic( 
        bit_colours : natural := 4   -- número de bits del PWM 
    );
 
    port( 
        CLK         : in  std_logic; 
        RST_n         : in  std_logic; 
        duty_R      : in  std_logic_vector(bit_colours-1 downto 0); 
        duty_G      : in  std_logic_vector(bit_colours-1 downto 0); 
        duty_B      : in  std_logic_vector(bit_colours-1 downto 0);    
        RGB         : out std_logic_vector(2 downto 0); 
        RGB_n       : out std_logic_vector(2 downto 0) 
    );
 
end PWM;
 
 
 
architecture behavioral of PWM is
 
    signal counter       : unsigned(bit_colours-1 downto 0) := (others => '0');
    signal RGB_signal    : std_logic_vector(2 downto 0); 
 
    constant MAX_VAL     : unsigned(bit_colours-1 downto 0) := to_unsigned(2**bit_colours - 1, bit_colours);
 
begin
  
    process(CLK, RST_n) 
    begin
 
        if RST_n = '0' then 
            counter <= (others => '0'); 
        elsif rising_edge(CLK) then 
            if counter = MAX_VAL then 
                counter <= (others => '0'); 
            else 
                counter <= counter + 1; 
            end if; 
        end if; 
    end process;
 
 
 
    -- PWM 
    RGB_signal(2) <= '1' when counter < unsigned(duty_R) else '0'; 
    RGB_signal(1) <= '1' when counter < unsigned(duty_G) else '0'; 
    RGB_signal(0) <= '1' when counter < unsigned(duty_B) else '0'; 
 
 
    -- Señales complementarias 
    RGB <= RGB_signal; 
    RGB_n <= not RGB_signal;
 
end behavioral;