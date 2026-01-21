library ieee; 
use ieee.std_logic_1164.all; 
use ieee.numeric_std.all; 

entity tb_PWM is
end tb_PWM; 

architecture tb of tb_PWM is 
    component PWM 
        generic ( bit_colours : natural :=4 ); 
        port (
            CLK : in std_logic; 
            RST_n : in std_logic; 
            
            duty_R : in std_logic_vector (bit_colours-1 downto 0); 
            duty_G : in std_logic_vector (bit_colours-1 downto 0); 
            duty_B : in std_logic_vector (bit_colours-1 downto 0); 
            
            RGB : out std_logic_vector (2 downto 0); 
            RGB_n : out std_logic_vector (2 downto 0)
        ); 
    end component; 
    
    constant bit_colours : natural :=4;
    constant MAX_VAL : natural := 2**bit_colours - 1;
    constant TbPeriod : time := 10 ns;
    
    signal CLK : std_logic := '0'; 
    signal RST_n : std_logic := '1'; 
    
    signal duty_R : std_logic_vector (bit_colours-1 downto 0) := (others => '0'); 
    signal duty_G : std_logic_vector (bit_colours-1 downto 0) := (others => '0'); 
    signal duty_B : std_logic_vector (bit_colours-1 downto 0) := (others => '0'); 
    
    signal RGB : std_logic_vector (2 downto 0); 
    signal RGB_n : std_logic_vector (2 downto 0); 
    
    signal counter : unsigned(bit_colours-1 downto 0) := (others => '0'); 

    
begin       
    dut : PWM 
    port map (
        CLK => CLK, 
        RST_n => RST_n, 
        duty_R => duty_R, 
        duty_G => duty_G, 
        duty_B => duty_B,
        RGB => RGB, 
        RGB_n => RGB_n
        ); 
        
    --Generación señal reloj
    CLK <= not CLK after TbPeriod/2;
    
    stimuli : process begin 
        --reseteo 
        RST_n <= '0'; 
        wait for 2*TbPeriod; 
        assert RGB = "000" report "[FAILED] no se ha reseteado la salida" severity failure; 
        RST_n <= '1';
        
        
        --valores de entrada 
        duty_R <= std_logic_vector(to_unsigned(1, duty_R'length)); 
        duty_G <= std_logic_vector(to_unsigned(5, duty_G'length)); 
        duty_B <= std_logic_vector(to_unsigned(14, duty_B'length)); 
        
        
        for counter_loop in 0 to MAX_VAL loop
            wait until rising_edge(CLK);
            if counter < unsigned(duty_R) then 
                assert RGB (2) = '1' report "[FAILED] no se ha encendido el led Rojo" severity failure; 
            else 
                assert RGB (2) = '0' report "[FAILED] no se ha apagado el led Rojo" severity failure;
            end if; 
            if counter < unsigned(duty_G) then 
                assert RGB (1) = '1' report "[FAILED] no se ha encendido el led Verde" severity failure; 
            else 
                assert RGB (1) = '0' report "[FAILED] no se ha apagado el led Verde" severity failure; 
            end if; 
            if counter < unsigned(duty_B) then
                assert RGB (0) = '1' report "[FAILED] no se ha encendido el led Azul" severity failure; 
            else 
                assert RGB (0) = '0' report "[FAILED] no se ha apagado el led Azul" severity failure; 
             end if; 
            counter <= counter + 1; 
        end loop;
        
        counter <=(others=>'0');
        duty_R <= std_logic_vector(to_unsigned(7, duty_R'length));
        duty_G <= std_logic_vector(to_unsigned(9, duty_G'length));
        duty_B <= std_logic_vector(to_unsigned(3, duty_B'length));
        
        for counter_loop in 0 to MAX_VAL loop
            wait until rising_edge(CLK);
            if counter < unsigned(duty_R) then 
                assert RGB (2) = '1' report "[FAILED] no se ha encendido el led Rojo" severity failure; 
            else 
                assert RGB (2) = '0' report "[FAILED] no se ha apagado el led Rojo" severity failure;
            end if; 
            if counter < unsigned(duty_G) then 
                assert RGB (1) = '1' report "[FAILED] no se ha encendido el led Verde" severity failure; 
            else 
                assert RGB (1) = '0' report "[FAILED] no se ha apagado el led Verde" severity failure; 
            end if; 
            if counter < unsigned(duty_B) then
                assert RGB (0) = '1' report "[FAILED] no se ha encendido el led Azul" severity failure; 
            else 
                assert RGB (0) = '0' report "[FAILED] no se ha apagado el led Azul" severity failure; 
             end if; 
            counter <= counter + 1; 
        end loop;
        
        wait for TbPeriod; 

        assert false report "[PASSED] todo bien capo" severity failure; 
        
    end process;
 end architecture;
