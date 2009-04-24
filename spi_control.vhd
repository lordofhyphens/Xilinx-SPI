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
	 generic (width: natural := 8);
    Port ( st : in STD_LOGIC;
           st_out : out  STD_LOGIC;
           clk : in  STD_LOGIC);
end spi_control;

architecture Behavioral of spi_control is

component buf_3state is
    Port ( i : in  STD_LOGIC;
           o : out  STD_LOGIC;
           en : in  STD_LOGIC);
end component;

component timer_n is
	generic (len : natural := 8);
	port (C, CLR : in STD_LOGIC;
			Q : out STD_LOGIC);
end component;

signal counter: STD_LOGIC := '0';
signal st_temp: STD_LOGIC := '0';
signal st_buf: STD_LOGIC := '0';
begin
	count_timer:timer_n generic map(8) port map(clk, counter, counter);
	cutoff: buf_3state port map(st, st_temp, st_buf);
	st_buf <= counter and st;
	st_pulldown: PULLDOWN port map(O=>st_temp);
	st_out <= st_temp;
end Behavioral;