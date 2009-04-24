----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    20:43:05 04/22/2009 
-- Design Name: 
-- Module Name:    buf_3state_n - Behavioral 
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

entity buf_3state_n is
	 generic(width : natural := 8);
    Port ( i : in  STD_LOGIC_VECTOR((width-1) downto 0);
           o : out STD_LOGIC_VECTOR((width-1) downto 0);
           en : in  STD_LOGIC);
end buf_3state_n;

architecture Behavioral of buf_3state_n is
component buf_3state is
	port(i : in std_logic; o: out std_logic; en:in std_logic);
end component;


begin
	state_array: for j in 0 to width-1 generate
		inst_3s: buf_3state port map(i(j), o(j), en);
	end generate;

end Behavioral;

