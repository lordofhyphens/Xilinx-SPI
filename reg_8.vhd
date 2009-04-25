----------------------------------------------------------------------------------
-- Company: SIUC ECE428
-- Engineer: Joseph Lenox
-- 
-- Create Date:    14:41:22 04/11/2009 
-- Module Name:    reg_8 - Behavioral 
----------------------------------------------------------------------------------
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_ARITH.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;

---- Uncomment the following library declaration if instantiating
---- any Xilinx primitives in this code.
library UNISIM;
use UNISIM.VComponents.all;

entity reg_n is 
	 generic (width: natural := 7);
    Port ( D : in  STD_LOGIC_VECTOR (width downto 0);
           Clk : in  STD_LOGIC;
           Q : out  STD_LOGIC_VECTOR (width downto 0);
           CE : in  STD_LOGIC;
           CLR : in  STD_LOGIC);
end reg_n;

architecture storage_register of reg_n is
	shared variable int_buffer : std_logic_vector(width downto 0);
begin
	process(D,CLK,CE,CLR) 
	begin
		if (rising_edge(CLK) and (CE='1' or CE='H')) then
			int_buffer := D;
		elsif (falling_edge(CLK)) then
		end if;
		if (CLR = '0' or CLR ='L') then
			for z in 0 to width loop
				int_buffer(z) := '0';
			end loop;
		end if;
	end process;
	Q <= int_buffer;
end storage_register;