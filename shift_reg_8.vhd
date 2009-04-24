----------------------------------------------------------------------------------
-- Company: SIUC ECE428 
-- Engineer: Joseph Lenox
-- 
-- Create Date:    00:02:23 04/13/2009 
-- Design Name: 
-- Module Name:    shift_reg - Behavioral 
-- Project Name: 
----------------------------------------------------------------------------------
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_ARITH.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;

---- Uncomment the following library declaration if instantiating
---- any Xilinx primitives in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity shift_reg is
	 generic (initial : integer := 0;
	          width: integer := 8);
    Port ( s_in : in  STD_LOGIC;
			  dir : in STD_LOGIC;
           load : in  STD_LOGIC;
           p_load : in  STD_LOGIC_VECTOR ((width-1) downto 0);
			  p_out : out STD_LOGIC_VECTOR ((width-1) downto 0);
           s_out : out  STD_LOGIC;
           clk : in  STD_LOGIC);
end shift_reg;

architecture shift_register of shift_reg is
shared variable int_buffer: std_logic_vector ((width-1) downto 0);
begin
	main_op : process (clk) 
	begin
		if (rising_edge(clk)) then
			if (dir = '0' AND load = '0') then
				-- left shift
				s_out <= int_buffer((width-1)); -- data to be shifted out
				int_buffer((width-1) downto 1) := int_buffer((width-2) downto 0);
				int_buffer(0) := s_in;
			elsif (load = '0') then
				-- right shift
				s_out <= int_buffer(0);
				int_buffer((width-2) downto 0) := int_buffer((width-1) downto 1);
				int_buffer((width-1)) := s_in;
			else 
				int_buffer := p_load;
			end if;
			p_out <= int_buffer;
		end if;
	end process;

end shift_register;

