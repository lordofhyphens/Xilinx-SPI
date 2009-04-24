----------------------------------------------------------------------------------
-- Company: SIUC ECE428
-- Engineer: Joseph Lenox
-- 
-- Create Date:    01:18:45 04/24/2009 
-- Design Name: SPI Engine
-- Module Name: clk_n - Behavioral 
-- Target Devices: Xilinx Spartan-II
-- Tool versions: 
-- Description: 
--
-- Dependencies:  
--
-- Revision: 
-- Revision 0.01 - File Created
-- Additional Comments: 
--
----------------------------------------------------------------------------------
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_ARITH.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;

---- Uncomment the following library declaration if instantiating
---- any Xilinx primitives in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

-- timing circuit that issues a signal every n clock cycles.
entity timer_n is
	generic (len : natural := 8); -- bit width of the counter.
	port (C, CLR : in STD_LOGIC;
			Q : out STD_LOGIC);
end timer_n;

architecture archi of timer_n is 
	shared variable count : natural := 0;
	signal set: std_logic;
begin
	process (C, CLR)
		variable q: natural := 0;
	begin
		if (CLR='1' and rising_edge(C)) then -- Synchronous reset
			count := 0;
			set <= '0';
		elsif (C'event and C='1') then
			count := count + 1;
		end if;
		if (count = (len-1)) then
			set <= '1';
		end if;
	end process;
	Q <= set;
end archi;