
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity duty_tb is

end duty_tb;

architecture Behavioral of duty_tb is

    component duty
        generic (
            bit_colours : natural := 4
        );
        port (
            up_bttn   : in STD_LOGIC;
            down_bttn : in STD_LOGIC;
            CLK       : in STD_LOGIC;
            RST       : in STD_LOGIC;
            duty      : out STD_LOGIC_VECTOR (bit_colours-1 downto 0)
        );
    end component;


    constant BIT_COLOURS_TB : natural := 4; 
    constant CLK_PERIOD     : time := 10 ns;
    constant MAX_VAL        : integer := (2**BIT_COLOURS_TB) - 1;

    signal up_bttn   : STD_LOGIC := '0';
    signal down_bttn : STD_LOGIC := '0';
    signal CLK       : STD_LOGIC := '0';
    signal RST       : STD_LOGIC := '0';
    signal duty_out  : STD_LOGIC_VECTOR (BIT_COLOURS_TB-1 downto 0);

begin

    
    uut: duty
        generic map (
            bit_colours => BIT_COLOURS_TB
        )
        port map (
            up_bttn   => up_bttn,
            down_bttn => down_bttn,
            CLK       => CLK,
            RST       => RST,
            duty      => duty_out
        );

    CLK <= not CLK after 0.5 * CLK_PERIOD;

    
    stim_proc: process
        variable current_val : integer;
    begin
        
        RST <= '1';
        up_bttn <= '0';
        down_bttn <= '0';
        wait for CLK_PERIOD * 2;
        
        assert unsigned(duty_out) = 0
            report "[FAILED]: El Reset no puso la salida a 0" severity error;

        RST <= '0';
        wait for CLK_PERIOD; -- Esperar un ciclo para estabilizar

        --Incremento
        up_bttn <= '1';
        down_bttn <= '0';

        
        for i in 1 to MAX_VAL loop
            wait for CLK_PERIOD;
            
            current_val := to_integer(unsigned(duty_out));
            
            assert current_val = i
                report "[FAILED]: Fallo en incremento: Se esperaba " & integer'image(i) & 
                       " pero se obtuvo " & integer'image(current_val)
                severity error;
        end loop;

        
        wait for CLK_PERIOD; -- Pulsamos UP una vez más estando ya al máximo
        
        assert unsigned(duty_out) = to_unsigned(MAX_VAL, BIT_COLOURS_TB)
            report "[FAILED]: El valor superó el máximo permitido" severity error;

       --Decremento
        up_bttn <= '0';
        down_bttn <= '1';

        for i in (MAX_VAL - 1) downto 0 loop
            wait for CLK_PERIOD;
            
            current_val := to_integer(unsigned(duty_out));
            
            assert current_val = i
                report "[FAILED]: Fallo en decremento: Se esperaba " & integer'image(i) & 
                       " pero se obtuvo " & integer'image(current_val)
                severity error;
        end loop;
        
        wait for CLK_PERIOD; -- Pulsamos DOWN una vez más estando ya en 0
        
        assert unsigned(duty_out) = 0
            report "[FAILED]: El valor bajó de 0 (underflow)" severity error;

        
        -- Fin de la simulación
        
        up_bttn <= '0';
        down_bttn <= '0';
        wait for CLK_PERIOD;
        
        assert FALSE
        report " [SUCCESS]: TEST COMPLETADO EXITOSAMENTE ";

    end process;

end Behavioral;