library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity fsm is
    generic (
        bit_colours : natural :=4
    );
    port(
        CLK         : in STD_LOGIC;
        RST_n         : in STD_LOGIC;
        
        up_bttn     : in STD_LOGIC;
        down_bttn   : in STD_LOGIC;
        slct_bttn   : in std_logic;
        
        light  : out std_logic_vector (3 downto 0);
        
        duty_R : out std_logic_vector (bit_colours-1 downto 0);
        duty_G : out std_logic_vector (bit_colours-1 downto 0);
        duty_B : out std_logic_vector (bit_colours-1 downto 0)
        
    );
end fsm;

architecture Behavioral of fsm is

    type states is (S0, SR, SG, SB);
    signal current_state : states := S0;
    signal next_state    : states := sR;
    signal up_bttn_R, up_bttn_G, up_bttn_B, down_bttn_R, down_bttn_G, down_bttn_B : STD_LOGIC := '0';

    component duty
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
    end component;
    
        
begin

    inst_duty_R: duty
        generic map (
            bit_colours => bit_colours
        )    
        port map (
            up_bttn => up_bttn_R,
            down_bttn => down_bttn_R,
            CLK => CLK,
            RST_n => RST_n,
            duty => duty_R        
        );

    inst_duty_G: duty
        generic map (
            bit_colours => bit_colours
        )    
        port map (
            up_bttn => up_bttn_G,
            down_bttn => down_bttn_G,
            CLK => CLK,
            RST_n => RST_n,
            duty => duty_G   
        );
    
    inst_duty_B: duty
        generic map (
            bit_colours => bit_colours
        )    
        port map (
            up_bttn => up_bttn_B,
            down_bttn => down_bttn_B,
            CLK => CLK,
            RST_n => RST_n,
            duty => duty_B        
        );
    
    state_register: process (RST_n, CLK)
    begin
        if RST_n = '0' then
           current_state <= s0;
        elsif rising_edge(CLK)then
            current_state <= next_state;
        end if;
    end process;
    
     nextstate_decod: process (SLCT_BTTN, current_state)
     begin
        next_state <= current_state;
        case current_state is
            when S0 =>
                if SLCT_BTTN = '1' then
                    next_state <= SR;
                end if;
            when SR =>
                if SLCT_BTTN = '1' then
                    next_state <= SG;
                end if;
            when SG =>
                if SLCT_BTTN = '1' then
                    next_state <= SB;
                end if;
            when SB =>
                if SLCT_BTTN = '1' then
                    next_state <= SR;
                end if;
            when others =>
                next_state <= S0;
        end case;
     end process;
     
     output_decod: process (current_state)
     begin
        case current_state is
            when SR =>
                up_bttn_R <= up_bttn;
                down_bttn_R <= down_bttn;
                up_bttn_G <= '0';
                down_bttn_G <= '0';
                up_bttn_B <= '0';
                down_bttn_B <= '0';
                light  <= (1 => '1', others => '0');
            when SG =>
                up_bttn_R <= '0';
                down_bttn_R <= '0';
                up_bttn_G <= up_bttn;
                down_bttn_G <= down_bttn;
                up_bttn_B <= '0';
                down_bttn_B <= '0';
                light  <= (2 => '1', others => '0');
            when SB =>
                up_bttn_R <= '0';
                down_bttn_R <= '0';
                up_bttn_G <= '0';
                down_bttn_G <= '0';
                up_bttn_B <= up_bttn;
                down_bttn_B <= down_bttn;
                light  <= (3 => '1', others => '0');
           when S0 =>
                light  <= (0 => '1', others => '0');
            when others =>
                up_bttn_R <= '0';
                down_bttn_R <= '0';
                up_bttn_G <= '0';
                down_bttn_G <= '0';
                up_bttn_B <= '0';
                down_bttn_B <= '0';
                light  <= (others => '0');
        end case;
     end process;
     
 end Behavioral;
