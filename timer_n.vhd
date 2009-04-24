----------------------------------------------------------------------------------
-- Company: SIUC ECE428
-- Engineer: Joseph Lenox
-- 
-- Create Date:    01:18:45 04/24/2009 
-- Design Name: SPI Engine
-- Module Name: timer_n
-- Target Devices: Xilinx Spartan-II
-- Tool versions: 
-- Description: FSM to count up to a certain number of cycles and then stop.
--
----------------------------------------------------------------------------------
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_ARITH.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;

library UNISIM;
use UNISIM.VComponents.all;

-- timing circuit that issues a signal every n clock cycles.
entity timer_n is
	generic (len : natural := 8); -- Total number of cycles for the counter to count before stopping.
	port (CLK, RES, EN : in STD_LOGIC;
			Q : out STD_LOGIC);
end timer_n;

architecture archi of timer_n is 
	shared variable count : natural := 0;
	signal set: std_logic := '0';
begin
	counter: process (CLK, RES, EN)
	begin
		if (rising_edge(CLK)) then
			if (EN = '1' and count < (len-1) ) then
				count := count + 1;
			end if;
			if (RES = '1') then
				count := 0;
			end if;
			if (count = (len - 1)) then 
				set <= '1';
			else
				set <= '0';
			end if;
		else if (falling_edge(CLK)) then
			if (RES = '1') then
				count := 0;
			end if;
		end if;
		end if;
	end process;
	Q <= set;
	output_guard: PULLDOWN port map(O=>Q);
end archi;