----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    12:48:00 04/22/2009 
-- Design Name: 
-- Module Name:    buf_3state - Behavioral 
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

entity buf_3state is
    Port ( i : in  STD_LOGIC;
           o : out  STD_LOGIC;
           en : in  STD_LOGIC);
end buf_3state;

architecture Behavioral of buf_3state is
begin
	o <= i when (en = '1') else 'Z';
end Behavioral;