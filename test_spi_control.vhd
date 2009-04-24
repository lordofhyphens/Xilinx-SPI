--------------------------------------------------------------------------------
-- Company: 
-- Engineer:
--
-- Create Date:   18:04:36 04/22/2009
-- Design Name:   
-- Module Name:   C:/Users/Lenox/ECE428/spi_project/test_spi_control.vhd
-- Project Name:  spi_project
-- Target Device:  
-- Tool versions:  
-- Description:   
-- 
-- VHDL Test Bench Created by ISE for module: spi_control
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
LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
USE ieee.std_logic_unsigned.all;
USE ieee.numeric_std.ALL;
 
ENTITY test_spi_control IS
END test_spi_control;
 
ARCHITECTURE behavior OF test_spi_control IS 
 
    -- Component Declaration for the Unit Under Test (UUT)
 
    COMPONENT spi_control
	 generic (width: natural := 8);
    PORT(
         st : IN  std_logic;
         st_out : OUT  std_logic;
         clk : IN  std_logic
        );
    END COMPONENT;
    

   --Inputs
   signal st : std_logic := '0';
   signal clk : std_logic := '0';

 	--Outputs
   signal st_out : std_logic;

   -- Clock period definitions
   constant clk_period : time := 1ns;
 
BEGIN
 
	-- Instantiate the Unit Under Test (UUT)
   uut: spi_control
			generic map(8)
			PORT MAP (
          st => st,
          st_out => st_out,
          clk => clk
        );

   -- Clock process definitions
   clk_process :process
   begin
		clk <= '0';
		wait for clk_period/2;
		clk <= '1';
		wait for clk_period/2;
   end process;
 

   -- Stimulus process
   stim_proc: process
   begin		
      -- hold reset state for 100ms.
      wait for 100ns;	

      wait for clk_period*10;
		st <= '1';
		wait for clk_period*8;
		st <= '0';
		wait for clk_period;
		st <= '1';
      -- insert stimulus here 

      wait;
   end process;

END;
