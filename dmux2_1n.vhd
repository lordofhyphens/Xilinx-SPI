----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    20:18:29 04/22/2009 
-- Design Name: 
-- Module Name:    dmux2_1n - Behavioral 
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

entity dmux2_1n is
	 generic (width : natural := 8);
    Port ( O0 : out  STD_LOGIC_VECTOR((width-1) downto 0);
           O1 : out  STD_LOGIC_VECTOR((width-1) downto 0);
           I : in  STD_LOGIC_VECTOR((width-1) downto 0);
           S : in  STD_LOGIC);
end dmux2_1n;

architecture Behavioral of dmux2_1n is
component buf_3state_n is
	 generic(width : natural := 8);
    Port ( i : in  STD_LOGIC_VECTOR((width-1) downto 0);
           o : out STD_LOGIC_VECTOR((width-1) downto 0);
           en : in  STD_LOGIC);
end component;

begin
	to_O0: buf_3state_n generic map (width=>width) port map(I, O0, S);
	to_O1: buf_3state_n generic map (width=>width) port map(I, O1, not(S));
end Behavioral;