library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity TOP is
    port(
        CLK         : in  std_logic; 
        RST         : in  std_logic; 
        
        up_bttn     : in STD_LOGIC;
        down_bttn   : in STD_LOGIC;
        slct_bttn   : in std_logic;
        
        RGB         : out std_logic_vector (2 downto 0);  
        RGB_n       : out std_logic_vector (2 downto 0) 
    );
end TOP;

architecture Behavioral of TOP is
    constant bit_colours            : natural := 4;
    signal duty_R, duty_G, duty_B   : std_logic_vector(bit_colours-1 downto 0);
    
     component SYNCHRNZR
        port (
            CLK      : in std_logic;
            ASYNC_IN : in std_logic;
            SYNC_OUT : out std_logic
        );
     end component;
   
    component EDGEDTCTR
        port (
            CLK : in std_logic;
            SYNC_IN : in std_logic;
            EDGE : out std_logic
        );
     end component;
     
     component STEPDTCTR
        port (
            CLK : in std_logic;
            SYNC_IN : in std_logic;
            STP : out std_logic
        );
     end component;
     
     component FSM
        port (
            up_bttn   : in STD_LOGIC;
            down_bttn : in STD_LOGIC;
            CLK       : in STD_LOGIC;
            RST       : in STD_LOGIC;
            duty      : out STD_LOGIC_VECTOR ( bit_colours-1 downto 0)
        );
     end component;
     
     component PWM
        port (
            CLK         : in  std_logic; 
            RST         : in  std_logic; 
            duty_R      : in  std_logic_vector(bit_colours-1 downto 0); 
            duty_G      : in  std_logic_vector(bit_colours-1 downto 0); 
            duty_B      : in  std_logic_vector(bit_colours-1 downto 0);    
            RGB         : out std_logic_vector(2 downto 0); 
            RGB_n       : out std_logic_vector(2 downto 0)        
        );
     end component;
    
begin
    --inst_SYNCHRNZR : SYNCHRNZR PORT MAP (
    --        CLK => CLK;
    --        ASYNC_IN 
    --        SYNC_OUT 
    --);
    --inst_EDGEDTCTR : EDGEDTCTR PORT MAP (
    
    --);
    --inst_STEPDTCTR : STEPDTCTR PORT MAP (
    
    --);
    --inst_FSM : FSM PORT MAP (
    
    --);
    --inst_PWM : PWM PORT MAP (
    
    --);
    


end Behavioral;
