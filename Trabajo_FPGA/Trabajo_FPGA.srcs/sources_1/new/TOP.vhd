library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity TOP is
    port(
        CLK         : in  std_logic; 
        RST_n         : in  std_logic; 
        
        up_bttn     : in STD_LOGIC;
        down_bttn   : in STD_LOGIC;
        slct_bttn   : in std_logic;
        
        light  : out std_logic_vector (3 downto 0);
        
        RGB         : out std_logic_vector (2 downto 0);  
        RGB_n       : out std_logic_vector (2 downto 0) 
    );
end TOP;

architecture Behavioral of TOP is
    constant bit_colours                 : natural := 4;
    signal duty_R, duty_G, duty_B        : std_logic_vector(bit_colours-1 downto 0);
    signal up_sync, down_sync, slct_sync : std_logic;
    signal up_stp, down_stp, slct_edge   : std_logic;
    
     component SYNCHRNZR
        port (
            CLK      : in std_logic;
            ASYNC_IN : in std_logic;
            SYNC_OUT : out std_logic
        );
     end component;
   
    component EDGEDTCTR
        port (
            CLK     : in std_logic;
            SYNC_IN : in std_logic;
            EDGE    : out std_logic
        );
     end component;
     
     component STEPDTCTR
        port (
            CLK     : in std_logic;
            SYNC_IN : in std_logic;
            STP     : out std_logic
        );
     end component;
     
     component FSM
        port (
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
     end component;
     
     component PWM
        port (
            CLK     : in  std_logic; 
            RST_n     : in  std_logic; 
            duty_R  : in  std_logic_vector(bit_colours-1 downto 0); 
            duty_G  : in  std_logic_vector(bit_colours-1 downto 0); 
            duty_B  : in  std_logic_vector(bit_colours-1 downto 0);    
            RGB     : out std_logic_vector(2 downto 0); 
            RGB_n   : out std_logic_vector(2 downto 0)        
        );
     end component;
    
begin
    up_SYNCHRNZR : SYNCHRNZR PORT MAP (
            CLK       => CLK,
            ASYNC_IN  => up_bttn,
            SYNC_OUT  => up_sync
    );
    
    down_SYNCHRNZR : SYNCHRNZR PORT MAP (
            CLK       => CLK,
            ASYNC_IN  => down_bttn,
            SYNC_OUT  => down_sync
    );
    
    slct_SYNCHRNZR : SYNCHRNZR PORT MAP (
            CLK       => CLK,
            ASYNC_IN  => slct_bttn,
            SYNC_OUT  => slct_sync
    );
    
    slc_EDGEDTCTR : EDGEDTCTR PORT MAP (
            CLK      => CLK,
            SYNC_IN  => slct_sync,
            EDGE     => slct_edge
    );
    up_STEPDTCTR : STEPDTCTR PORT MAP (
            CLK      => CLK,
            SYNC_IN  => up_sync,
            STP      => up_stp
    );
    
    down_STEPDTCTR : STEPDTCTR PORT MAP (
            CLK      => CLK,
            SYNC_IN  => down_sync,
            STP      => down_stp
    );
    
    inst_FSM : FSM PORT MAP (
            CLK        => CLK,
            RST_n        => RST_n,
            
            up_bttn    => up_stp,
            down_bttn  => down_stp,
            slct_bttn  => slct_edge,
            
            light      => light,
           
            duty_R     => duty_R,
            duty_G     => duty_G,
            duty_B     => duty_B
    );
    
    inst_PWM : PWM PORT MAP (
            CLK     => CLK,
            RST_n     => RST_n,
            duty_R  => duty_R,
            duty_G  => duty_G,
            duty_B  => duty_B,
            RGB     => RGB,
            RGB_n   => RGB_n
    );

end Behavioral;
