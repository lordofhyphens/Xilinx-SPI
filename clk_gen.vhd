----------------------------------------------------------------------------------
-- Engineer: Joseph Lenox
-- 
-- Create Date:    16:13:39 04/20/2009 
-- Design Name: 
-- Module Name:    clk_gen - Behavioral 
-- Project Name:  SPI Engine
-- Target Devices: 
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
library UNISIM;
use UNISIM.VComponents.all;

entity clk_gen is
    Port ( clk : in  STD_LOGIC;
	        en : in STD_LOGIC;
           clk_out : out  STD_LOGIC;
           div : in  STD_LOGIC_VECTOR (3 downto 0));
end clk_gen;


architecture clock_generator of clk_gen is

function To_Integer(z : std_logic_vector (3 downto 0))
	return integer is 
begin 
	case z is 
		when X"0" => return 0;
		when X"1" => return 1;
		when X"2" => return 2;
		when X"3" => return 3;
		when X"4" => return 4;
		when X"5" => return 5;
		when X"6" => return 6;
		when X"7" => return 7;
		when X"8" => return 8;
		when X"9" => return 9;
		when X"A" => return 10;
		when X"B" => return 11;
		when X"C" => return 12;
		when X"D" => return 13;
		when X"E" => return 14;
		when X"F" => return 15;	
		when others => return 0;
	end case;
end To_Integer;

shared variable last_out : std_logic :='0';
begin
	generate_clock: process(clk, div)
		variable divisor : integer; 
		variable n : integer := 0; 
	begin
		divisor := To_Integer(div);
		if (en = '1' and rising_edge(clk)) then
			n := n + 1;
			if (n = (divisor/2)) then
				if (last_out = '1') then
					clk_out <= '0';
					last_out := '0';
				else 
					clk_out <= '1';
					last_out := '1';
				end if;
			end if;
			if (n = (divisor)) then
				n := 0;
			end if;
		end if;
	end process;
	SCLK_pull: PULLDOWN port map(O=>clk_out);

end clock_generator;

