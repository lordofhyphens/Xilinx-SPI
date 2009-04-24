----------------------------------------------------------------------------------
-- Company: SIUC ECE428 
-- Engineer: Joseph Lenox
-- Create Date:    00:02:23 04/13/2009 
-- Design Name: 
-- Module Name:    shift_reg - Behavioral 
-- Project Name: 
-- Description: Bi-Directional n-bit shift register with parallel load, serial input,
--              serial output, parallel output, synchronous clear, and enable.
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
    Port ( serial_in : in  STD_LOGIC;
	        serial_out: out STD_LOGIC;
			  -- 0 for right shift, 1 for left shift.
			  dir : in STD_LOGIC;
           load : in  STD_LOGIC;
           D : in  STD_LOGIC_VECTOR ((width-1) downto 0);
			  Q : out STD_LOGIC_VECTOR ((width-1) downto 0);
           EN : in STD_LOGIC;
			  RES : in STD_LOGIC;
           CLK : in  STD_LOGIC);
end shift_reg;

architecture shift_register of shift_reg is
	shared variable int_buffer: std_logic_vector ((width-1) downto 0);
	signal int_q : std_logic_vector((width-1) downto 0);
begin
	main_op : process (CLK, EN, D, RES, load)
	begin
		if (rising_edge(CLK) and EN='1') then
			if (load = '1') then
				int_buffer := D;
			end if;
			if (load = '0') then
				if (dir = '1') then
					serial_out <= int_buffer(width-1);
					int_buffer(width-1 downto 1) := int_buffer(width-2 downto 0);
					int_buffer(0) := serial_in;
				else 
					serial_out <= int_buffer(0); -- bit that is shifted out.
					int_buffer(width-2 downto 0) := int_buffer(width-1 downto 1);
					int_buffer(width-1) := serial_in;
			end if;
		end if;
		else
			if (falling_edge(CLK)) then
				if (RES = '1') then
					for z in 0 to (width-1) loop
						int_buffer(z) := '0';
					end loop;
				end if;
			end if;
		end if;
		int_q <= int_buffer;
	end process;
	Q <= int_q;
end shift_register;