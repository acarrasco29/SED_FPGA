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
              RST       : in std_logic;
              
              up_bttn   : in std_logic;
              down_bttn : in std_logic;
              slct_bttn : in std_logic;
              
              light     : out std_logic_vector (3 downto 0);
              
              duty_R    : out std_logic_vector (bit_colours-1 downto 0);
              duty_G    : out std_logic_vector (bit_colours-1 downto 0);
              duty_B    : out std_logic_vector (bit_colours-1 downto 0));
    end component;

    signal CLK       : std_logic := '0';
    signal RST       : std_logic := '0';
    
    signal up_bttn   : std_logic := '0';
    signal down_bttn : std_logic := '0';
    signal slct_bttn : std_logic := '0';
    
    signal light     : std_logic_vector (3 downto 0) := "0000";
    
    constant bit_colours : natural :=4;
    
    signal duty_R    : std_logic_vector (bit_colours-1 downto 0) := (others => '0');
    signal duty_G    : std_logic_vector (bit_colours-1 downto 0) := (others => '0');
    signal duty_B    : std_logic_vector (bit_colours-1 downto 0) := (others => '0');
    
    constant TbPeriod : time := 100 ns;
    signal TbClock : std_logic := '0';
    
    type light_array is array(0 to 2) of std_logic_vector(3 downto 0);
    constant lights : light_array := ("0010", "0100", "1000");

begin

    uut : fsm
    port map (CLK       => CLK,
              RST       => RST,
              up_bttn   => up_bttn,
              down_bttn => down_bttn,
              slct_bttn => slct_bttn,
              light     => light,
              duty_R    => duty_R,
              duty_G    => duty_G,
              duty_B    => duty_B
              );

    TbClock <= not TbClock after TbPeriod/2;
    CLK <= TbClock;

    stimuli : process
    begin
        RST <= '1';             
        wait for 100 ns;
        assert light = "0001" report "[FAILED] EL led del estado 0 no esta encendido, no ha ido el RESET"
        severity failure;
                
        RST <= '0';
        wait for 100 ns;

        for i in 0 to light'length*3+2 loop
            slct_bttn <= '1';
            wait until TbClock = '0';
            slct_bttn <= '0';
            wait for 1000 ns;
              
            assert light = lights(i mod lights'length)
            report  "[Failed]: error al pasar del estado " & integer'image((i) mod lights'length) &
            " al " & integer'image((i+1) mod lights'length)
            severity failure;
        end loop;

        RST <= '1';             
        wait for 100 ns;
        RST <= '0';             
        wait for 100 ns;
        assert light = "0001" report "[FAILED] EL led del estado 0 no esta encendido, no ha ido el RESET"
        severity failure;
                
        assert false
        report "[PASSED] Todo bien capo"
        severity failure;

    end process;

end tb;