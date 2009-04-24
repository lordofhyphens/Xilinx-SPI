--------------------------------------------------------------------------------
-- Company: 
-- Engineer:
--
-- Create Date:   01:03:04 04/23/2009
-- Design Name:   
-- Module Name:   C:/Users/Lenox/ECE428/spi_engine/test_spi_engine.vhd
-- Project Name:  spi_engine
-- Target Device:  
-- Tool versions:  
-- Description:   
-- 
-- VHDL Test Bench Created by ISE for module: spi_device
-- 
-- Dependencies:
-- 
-- Revision:
-- Revision 0.01 - File Created
-- Additional Comments:
--
-- Notes: 
-- This testbench has been automatically generated using types std_logic and
-- std_logic_vector for the ports of the unit under test.  Xilinx recommends
-- that these types always be used for the top-level I/O of a design in order
-- to guarantee that the testbench will bind correctly to the post-implementation 
-- simulation model.
--------------------------------------------------------------------------------
LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
USE ieee.std_logic_unsigned.all;
USE ieee.numeric_std.ALL;
 
ENTITY test_spi_engine IS
END test_spi_engine;
 
ARCHITECTURE behavior OF test_spi_engine IS 
 
    -- Component Declaration for the Unit Under Test (UUT)
 
    COMPONENT spi_device
    PORT(
         MISO : INOUT  std_logic;
         MOSI : INOUT  std_logic;
         SS : INOUT  std_logic;
         SCLK : INOUT  std_logic;
         DATA : IN  std_logic_vector(7 downto 0);
         DATA_OUT : OUT  std_logic_vector(7 downto 0);
         CLK : IN  std_logic;
         st : IN  std_logic
        );
    END COMPONENT;
    

   --Inputs
   signal DATA : std_logic_vector(7 downto 0) := (others => '0');
	signal DATA_1 : std_logic_vector(7 downto 0) := (others => '0');
   signal CLK : std_logic := '0';
   signal st : std_logic := '0';
	signal st_1 : std_logic := '0';

	--BiDirs
   signal MISO : std_logic;
   signal MOSI : std_logic;
   signal SS : std_logic;
   signal SCLK : std_logic;

 	--Outputs
   signal DATA_OUT : std_logic_vector(7 downto 0);
	signal DATA_OUT_1 : std_logic_vector(7 downto 0);
	
	shared variable clk_period : time := 1 ns;
 
BEGIN
 
	-- Instantiate the Unit Under Test (UUT)
   master: spi_device PORT MAP (
          MISO => MISO,
          MOSI => MOSI,
          SS => SS,
          SCLK => SCLK,
          DATA => DATA,
          DATA_OUT => DATA_OUT,
          CLK => CLK,
          st => st
        );
	slave: spi_device PORT MAP (
          MISO => MISO,
          MOSI => MOSI,
          SS => SS,
          SCLK => SCLK,
          DATA => DATA_1,
          DATA_OUT => DATA_OUT_1,
          CLK => CLK,
          st => st_1
        );
  
   -- No clocks detected in port list. Replace <clock> below with 
   -- appropriate port name 

   clk_process :process
	
   begin
		CLK <= '0';
		wait for clk_period/2;
		CLK <= '1';
		wait for clk_period/2;
   end process;
 

   -- Stimulus process
   stim_proc: process
   begin		
      -- hold reset state for 100ms.
      wait for 100ns;	

      wait for clk_period*10;

      -- Load data on both sides. 
		DATA <= X"AF";
		DATA_1 <= X"F3";
		wait for clk_period*2;
		st <= '1';
		wait for clk_period*10;
		st <= '0';
		wait for clk_period*10;

      wait;
   end process;

END;
