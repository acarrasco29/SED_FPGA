library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity tb_fsm is
end tb_fsm;

architecture tb of tb_fsm is

    component fsm
        generic (
            bit_colours : natural :=4
        );
        port (CLK       : in std_logic;
              RST_n       : in std_logic;
              
              up_bttn   : in std_logic;
              down_bttn : in std_logic;
              slct_bttn : in std_logic;
              
              light     : out std_logic_vector (3 downto 0);
              
              duty_R    : out std_logic_vector (bit_colours-1 downto 0);
              duty_G    : out std_logic_vector (bit_colours-1 downto 0);
              duty_B    : out std_logic_vector (bit_colours-1 downto 0));
    end component;

    signal CLK       : std_logic := '0';
    signal RST_n       : std_logic := '0';
    
    signal up_bttn   : std_logic := '0';
    signal down_bttn : std_logic := '0';
    signal slct_bttn : std_logic := '0';
    
    signal light     : std_logic_vector (3 downto 0) := "0000";
    
    constant bit_colours : natural :=4;
    
    signal duty_R    : std_logic_vector (bit_colours-1 downto 0) := (others => '0');
    signal duty_G    : std_logic_vector (bit_colours-1 downto 0) := (others => '0');
    signal duty_B    : std_logic_vector (bit_colours-1 downto 0) := (others => '0');
    
    constant TbPeriod : time := 10 ns;
    
    type light_array is array(0 to 3) of std_logic_vector(3 downto 0);
    constant lights : light_array := ("0001", "0010", "0100", "1000");

begin

    uut : fsm
    generic map (bit_colours => bit_colours)
    port map (CLK       => CLK,
              RST_n       => RST_n,
              up_bttn   => up_bttn,
              down_bttn => down_bttn,
              slct_bttn => slct_bttn,
              light     => light,
              duty_R    => duty_R,
              duty_G    => duty_G,
              duty_B    => duty_B
              );
    
    CLK <= not CLK after TbPeriod/2;

    stimuli : process
    
        variable i_ligth : integer := 0;
    
    begin
        RST_n <= '0';             
        wait until rising_edge (CLK);
        wait until rising_edge (CLK);
        RST_n <= '1';
                
        wait until rising_edge (CLK);
        
        assert light = lights(0) 
            report "[FAILED] EL led del estado 0 no esta encendido, no ha ido el RESET"
            severity failure; 
        
        wait until rising_edge (CLK);
        
        for i in 1 to 8 loop
            slct_bttn <= '1';
            wait until rising_edge (CLK);
            slct_bttn <= '0';
            wait until rising_edge (CLK);
            
            if i_ligth = 0 then
                i_ligth := 1;
            elsif i_ligth = 3 then
                i_ligth := 1;
            else
                i_ligth := i_ligth + 1;
            end if;
              
            assert light = lights(i_ligth)
                report  "[Failed]: error al pasar del estado " & integer'image((i) mod lights'length) &
                    " al " & integer'image((i+1) mod lights'length)
                severity failure;
        end loop;

        RST_n <= '0';             
        wait until rising_edge (CLK);
        wait until rising_edge (CLK);        
        RST_n <= '1';
                     
        wait until rising_edge (CLK);
        
        assert light = lights(0) 
            report "[FAILED] EL led del estado 0 no esta encendido, no ha ido el RESET"
            severity failure;
            
        wait for 3*TbPeriod;
        
        assert false
            report "[PASSED] Todo bien capo"
            severity failure;

    end process;

end tb;