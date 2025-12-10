
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity fsm is
    generic (
        bit_colours : natural :=4
    );
    port(
        CLK         : in STD_LOGIC;
        RST         : in STD_LOGIC;
        
        up_bttn     : in STD_LOGIC;
        down_bttn   : in STD_LOGIC;
        slct_bttn   : in std_logic;
        
        duty_vector : out std_logic_vector (2 downto 0)
        
    );
end fsm;

architecture Behavioral of fsm is

    type states is (S0, SR, SG, SB);
    signal current_state : states := S0;
    signal next_state    : states;
    signal d_R, d_G, d_B : std_logic_vector (2 downto 0);

    component duty
        generic (
            bit_colours : natural := 4   --Número máx de colores = 2^bit_colours
        );
        
        port ( 
            up_bttn   : in STD_LOGIC;
            down_bttn : in STD_LOGIC;
            CLK       : in STD_LOGIC;
            RST       : in STD_LOGIC;
            duty      : out STD_LOGIC_VECTOR ( bit_colours-1 downto 0)
            );
    end component;
    
        
begin

    inst_duty_R: duty
        generic map (
            bit_colours => bit_colours
        )    
        port map (
            up_bttn => up_bttn,
            down_bttn => down_bttn,
            CLK => CLK,
            RST => RST,
            duty => d_R        
        );

    inst_duty_G: duty
        generic map (
            bit_colours => bit_colours
        )    
        port map (
            up_bttn => up_bttn,
            down_bttn => down_bttn,
            CLK => CLK,
            RST => RST,
            duty => d_G   
        );
    
    inst_duty_B: duty
        generic map (
            bit_colours => bit_colours
        )    
        port map (
            up_bttn => up_bttn,
            down_bttn => down_bttn,
            CLK => CLK,
            RST => RST,
            duty => d_B        
        );

end Behavioral;
