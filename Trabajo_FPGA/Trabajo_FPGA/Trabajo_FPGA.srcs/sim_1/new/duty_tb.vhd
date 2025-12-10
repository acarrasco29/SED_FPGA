----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 09.12.2025 11:15:36
-- Design Name: 
-- Module Name: duty_tb - Behavioral
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

entity tb_duty is
end tb_duty;

architecture tb of tb_duty is

    constant BIT_COLOURS : positive := 4;
    
    component duty
        port (up_bttn   : in std_logic;
              down_bttn : in std_logic;
              CLK       : in std_logic;
              RST       : in std_logic;
              duty      : out std_logic_vector (BIT_COLOURS-1 downto 0));
    end component;

    signal up_bttn   : std_logic;
    signal down_bttn : std_logic;
    signal CLK       : std_logic;
    signal RST       : std_logic;
    signal duty_out  : std_logic_vector (BIT_COLOURS-1 downto 0);

    constant TbPeriod : time := 1000 ns;
    signal TbClock : std_logic := '0';
    signal TbSimEnded : std_logic := '0';

begin

    dut : duty
        port map (up_bttn   => up_bttn,
                  down_bttn => down_bttn,
                  CLK       => CLK,
                  RST       => RST,
                  duty      => duty_out);

    TbClock <= not TbClock after TbPeriod/2 when TbSimEnded /= '1' else '0';

    CLK <= TbClock;

    stimuli : process
    begin
        up_bttn <= '0';
        down_bttn <= '0';

        RST <= '1';
        wait for 100 ns;
        RST <= '0';
        wait for 100 ns;

        up_bttn <= '1';
        wait for 5 * TbPeriod;
        up_bttn <= '0';
        
        down_bttn <= '1';
        wait for 5 * TbPeriod;
        down_bttn <= '0';
        
        wait for 100 * TbPeriod;

        TbSimEnded <= '1';
        wait;
    end process;

end tb;

