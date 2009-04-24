--------------------------------------------------------------------------------
-- Company: 
-- Engineer:
--
-- Create Date:   12:35:34 04/24/2009
-- Design Name:   
-- Module Name:   C:/Users/Lenox/ECE428/spi_engine/test_timer_n.vhd
-- Project Name:  spi_engine
-- Target Device:  
-- Tool versions:  
-- Description:   
-- 
-- VHDL Test Bench Created by ISE for module: timer_n
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
 
ENTITY test_timer_n IS
END test_timer_n;
 
ARCHITECTURE behavior OF test_timer_n IS 
 
    -- Component Declaration for the Unit Under Test (UUT)
 
    COMPONENT timer_n
    PORT(
	      en: in std_logic;
         CLK : IN  std_logic;
         RES : IN  std_logic;
         Q : OUT  std_logic
        );
    END COMPONENT;
    

   --Inputs
   signal C : std_logic := '0';
   signal RES : std_logic := '0';
	signal en: std_logic:='0';

 	--Outputs
   signal Q : std_logic;
	
	shared variable C_period :time := 10 ns;
 
BEGIN
 
	-- Instantiate the Unit Under Test (UUT)
   uut: timer_n PORT MAP (
          CLK => C,
          RES => RES,
          Q => Q,
			 EN => en
        );
 
   -- No clocks detected in port list. Replace <clock> below with 
   -- appropriate port name 
 
   C_process :process
   begin
		C <= '0';
		wait for C_period/2;
		C <= '1';
		wait for C_period/2;
   end process;
 

   -- Stimulus process
   stim_proc: process
   begin		
      -- hold reset state for 100ms.
      wait for 100ns;	

      wait for C_period*10;
		en <= '1';
		wait for C_period*10;
		RES <= '1';
		wait for C_period;
		RES <= '0';
		wait for C_period;
      -- insert stimulus here 

      wait;
   end process;

END;
