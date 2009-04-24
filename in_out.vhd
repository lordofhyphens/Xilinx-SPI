----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    12:57:34 04/22/2009 
-- Design Name: 
-- Module Name:    in_out - Behavioral 
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

entity in_out is
    Port ( a, b : inout  STD_LOGIC;
           dir : in  STD_LOGIC);
end in_out;

architecture Behavioral of in_out is
component buf_3state is
    Port ( i : in  STD_LOGIC;
           o : out  STD_LOGIC;
           en : in  STD_LOGIC);
end component;
signal inv_dir: std_logic;
begin
	inv_dir <= not(dir);
	A_B: buf_3state port map(a, b, dir);
	B_A: buf_3state port map(b, a, inv_dir);
end Behavioral;