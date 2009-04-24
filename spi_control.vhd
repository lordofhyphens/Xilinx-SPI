----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    17:50:21 04/22/2009 
-- Design Name: 
-- Module Name:    spi_control - Behavioral 
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
library UNISIM;
use UNISIM.VComponents.all;

entity spi_control is
	 generic (len: natural := 8);
    Port ( st : in STD_LOGIC;
           st_out : out  STD_LOGIC;
			  done : out std_logic;
           clk : in  STD_LOGIC);
end spi_control;

architecture Behavioral of spi_control is

component buf_3state is
    Port ( i : in  STD_LOGIC;
           o : out  STD_LOGIC;
           en : in  STD_LOGIC);
end component;

component timer_n is
	generic (len : natural := 8); -- Total number of cycles for the counter to count before stopping.
	port (CLK, RES, EN : in STD_LOGIC;
			Q : out STD_LOGIC);
end component;

signal reset : std_logic := '0';
signal int_done : std_logic := '0';

signal st_3s : std_logic := '0';
signal st_3s_out : std_logic := '0';

begin
	reset <= (not(st));
	st_3s <= (not(int_done) and st);
	
	count_timer:timer_n generic map(len) port map(CLK=>clk, RES=>reset,EN=>st, Q=>int_done);
	cutoff: buf_3state port map(i=>st,o=>st_3s_out,en=>st_3s);
	
	st_pulldown: PULLDOWN port map(O=>st_3s_out);
	st_out <= st_3s_out;
	done <= int_done;
end Behavioral;