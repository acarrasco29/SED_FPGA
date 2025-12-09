----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 09.12.2025 11:30:01
-- Design Name: 
-- Module Name: tb_synchrnzr - Behavioral
-- Project Name: 
-- Target Devices: 
-- Tool Versions: 
-- Description: 
-- 
-- Dependencies: 
-- 
-- Revision:
-- Revision 0.01 - File Created
-- Additional Comments:
-- 
----------------------------------------------------------------------------------


library ieee;
use ieee.std_logic_1164.all;

entity tb_synchronizer is
end tb_synchronizer;

architecture tb of tb_synchronizer is

    component SYNCHRNZR
        port ( CLK : in std_logic;
               ASYNC_IN : in std_logic;
               SYNC_OUT : out std_logic );
    end component;

    signal CLK : std_logic := '0';
    signal ASYNC_IN : std_logic := '0';
    signal SYNC_OUT : std_logic;

    constant TbPeriod : time := 10 ns;  
    signal TbSimEnded : std_logic := '0';

begin

    dut: SYNCHRNZR
        port map (CLK => CLK,
                  ASYNC_IN => ASYNC_IN,
                  SYNC_OUT => SYNC_OUT);

    
    CLK <= not CLK after TbPeriod/2 when TbSimEnded /= '1' else CLK;

    stimuli : process
    begin
        ASYNC_IN <= '0';
        wait for 3 * TbPeriod;
        
        ASYNC_IN <= '1';
        wait for 3 * TbPeriod;
        
        for i in 0 to 20 loop
            ASYNC_IN <= not ASYNC_IN;
            wait for (TbPeriod * 0.7);  -- Cambio asíncrono
        end loop;
        
        wait for 10 * TbPeriod;
        TbSimEnded <= '1';
        wait;
    end process;

end tb;
