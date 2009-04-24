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

entity reg_8 is 
	 generic (width: natural := 7);
    Port ( D : in  STD_LOGIC_VECTOR (width downto 0);
           Clk : in  STD_LOGIC;
           Q : out  STD_LOGIC_VECTOR (width downto 0);
           CE : in  STD_LOGIC;
           CLR : in  STD_LOGIC);
end reg_8;

architecture Behavioral of reg_8 is
-- FDCE: Single Data Rate D Flip-Flop with Asynchronous Clear and
-- Clock Enable (posedge clk). All families.
-- Xilinx HDL Libraries Guide, version 10.1.2

begin
DFFS:	for i in 0 to width generate
FDCE_1 : FDCE
	port map (
	          Q => Q(i), -- Data output
	          C => Clk, -- Clock input
             CE => CE, -- Clock enable input
             CLR => CLR, -- Asynchronous clear input
             D => D(i) -- Data input
	);
	end generate DFFS;
end Behavioral;

