--------------------------------------------------------------------------------
-- Company: 
-- Engineer:
--
-- Create Date:   12:51:08 04/22/2009
-- Design Name:   
-- Module Name:   C:/Users/Lenox/ECE428/spi_project/test_buf_3state.vhd
-- Project Name:  spi_project
-- Target Device:  
-- Tool versions:  
-- Description:   
-- 
-- VHDL Test Bench Created by ISE for module: buf_3state
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
 
ENTITY test_buf_3state IS
END test_buf_3state;
 
ARCHITECTURE behavior OF test_buf_3state IS 
 
    -- Component Declaration for the Unit Under Test (UUT)
 
    COMPONENT buf_3state
    PORT(
         i : IN  std_logic;
         o : OUT  std_logic;
         en : IN  std_logic
        );
    END COMPONENT;
    

   --Inputs
   signal i : std_logic := '0';
   signal en : std_logic := '0';

 	--Outputs
   signal o : std_logic;
	
	--Clock
	signal clk : std_logic := '0';
	shared variable clk_period : time := 10ns;
 
BEGIN
 
	-- Instantiate the Unit Under Test (UUT)
   uut: buf_3state PORT MAP (
          i => i,
          o => o,
          en => en
        );
 
   -- No clocks detected in port list. Replace <clock> below with 
   -- appropriate port name 

 
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
      wait for clk_period*10;

      i <= '1';
		wait for clk_period;
		en <= '1';

      wait;
   end process;

END;
