----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    20:14:50 04/22/2009 
-- Design Name: 
-- Module Name:    mux2_1n - Behavioral 
-- Project Name: 
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
--library UNISIM;
--use UNISIM.VComponents.all;

entity mux2_1n is
	 generic (width : natural := 8);
    Port ( I0 : in  STD_LOGIC_VECTOR((width-1) downto 0);
           I1 : in  STD_LOGIC_VECTOR((width-1) downto 0);
           o : out  STD_LOGIC_VECTOR((width-1) downto 0);
           S : in  STD_LOGIC);
end mux2_1n;

architecture Behavioral of mux2_1n is

begin
	sel: process (S, I0, I1) 
	begin
		if (S = '0') then
			o <= I0;
		else
			o <= I1;
		end if;
	end process;
end Behavioral;

