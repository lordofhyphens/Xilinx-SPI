----------------------------------------------------------------------------------
-- Company: SIUC ECE428
-- Engineer: Joseph Lenox
-- 
-- Create Date:    14:47:55 04/17/2009 
-- Design Name: spi_engine
-- Module Name:    spi_master - Behavioral 
-- Project Name: 
-- Target Devices: 
-- Tool versions: 
-- Description: Hardware implementation of SPI Bus.
--
-- Dependencies: buf_3state, mux2_1, in_out, shift_reg, reg_8
----------------------------------------------------------------------------------
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_ARITH.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;

---- Uncomment the following library declaration if instantiating
---- any Xilinx primitives in this code.
library UNISIM;
use UNISIM.VComponents.all;

entity spi_device is
	 generic(width: integer := 8);
    Port ( MISO : inout  STD_LOGIC;
           MOSI : inout  STD_LOGIC;
           SS : inout  STD_LOGIC;
           SCLK : inout  STD_LOGIC;
           DATA : in  STD_LOGIC_VECTOR ((width-1) downto 0);
			  DATA_OUT: out STD_LOGIC_VECTOR ((width-1) downto 0);
           CLK : in  STD_LOGIC;
			  st: in STD_LOGIC); -- signifies that this side is initiating the transfer.
end spi_device;

architecture Behavioral of spi_device is
component shift_reg is
	 generic (initial : integer := 0;
	          width: integer := 8);
    Port ( s_in : in  STD_LOGIC;
			  dir : in STD_LOGIC;
           load : in  STD_LOGIC;
           p_load : in  STD_LOGIC_VECTOR ((width-1) downto 0);
			  p_out: out STD_LOGIC_VECTOR ((width-1) downto 0);
           s_out : out  STD_LOGIC;
           clk : in  STD_LOGIC);
end component;

component clk_gen is
    Port ( clk : in  STD_LOGIC;
	        en : in STD_LOGIC;
           clk_out : out  STD_LOGIC;
           div : in  STD_LOGIC_VECTOR (3 downto 0));
end component;

component reg_8 is 
	 generic (width: natural := 7);
    Port ( D : in  STD_LOGIC_VECTOR (width downto 0);
           Clk : in  STD_LOGIC;
           Q : out  STD_LOGIC_VECTOR (width downto 0);
           CE : in  STD_LOGIC;
           CLR : in  STD_LOGIC);
end component;

component buf_3state is
    Port ( i : in  STD_LOGIC;
           o : out  STD_LOGIC;
           en : in  STD_LOGIC);
end component;

component in_out is
    Port ( a, b : inout  STD_LOGIC;
           dir : in  STD_LOGIC);
end component;
component mux2_1 is
	port(I0, I1, S: in STD_LOGIC;
	     o : out STD_LOGIC);
end component;

component spi_control is
	 generic (width: natural := 8);
    Port ( st : in  STD_LOGIC;
           st_out : out  STD_LOGIC;
           clk : in  STD_LOGIC);
end component;

component mux2_1n is
	 generic (width : natural := 8);
    Port ( I0 : in  STD_LOGIC_VECTOR((width-1) downto 0);
           I1 : in  STD_LOGIC_VECTOR((width-1) downto 0);
           o : out  STD_LOGIC_VECTOR((width-1) downto 0);
           S : in  STD_LOGIC);
end component;

-- internal SCLK (serial clock) and SS (slave select) signals. 
signal int_st: STD_LOGIC;

signal int_sclk : STD_LOGIC;
signal ss_to_mux : STD_LOGIC;

signal int_ss : STD_LOGIC;
signal sclk_3s_to_mux: STD_LOGIC;
signal sclk_from_clkgen : STD_LOGIC;

-- Master Out/Slave In Signals
signal mosi_3s_to_mux : STD_LOGIC;
signal mosi_mux_to_buf : STD_LOGIC;
signal mosi_buf_to_safe : STD_LOGIC;

-- Master In/Slave Out Signals
signal miso_3s_to_mux : STD_LOGIC;
signal miso_mux_to_buf : STD_LOGIC;
signal miso_buf_to_safe : STD_LOGIC;

signal miso_buf_to_receive_buf: STD_LOGIC_VECTOR((width-1) downto 0);
signal mosi_buf_to_receive_buf: STD_LOGIC_VECTOR((width-1) downto 0);

signal tx_buf_to_mux: STD_LOGIC_VECTOR((width-1) downto 0);
signal mux_to_receive_buf: STD_LOGIC_VECTOR((width-1) downto 0);

begin
-- Control for the ST (start) behavior.
	ST_switch : spi_control port map(st, int_st, sclk);
-- In/out behavior for SS
	SS_external: in_out port map(SS, ss_to_mux, int_st);
	SS_mux : mux2_1 port map (not(int_st), ss_to_mux, int_st, int_ss);
	SS_pullup: PULLUP port map (O=>SS);	
	
-- In/out behavior for SCLK
	
	SCLK_in_3s:  buf_3state port map(SCLK, sclk_3s_to_mux, int_st);
	SCLK_out_3s: buf_3state port map(int_sclk,  SCLK, int_st);
	SCLK_mux: mux2_1 port map (sclk_3s_to_mux, sclk_from_clkgen, int_st, int_sclk);
	SCLK_pull: PULLDOWN port map(O=>SCLK);
	SCLK_gen: clk_gen port map(clk, int_st, sclk_from_clkgen, X"4"); -- sclk is clk / 4
	
--MOSI, Master Out, Slave In
	MOSI_in_3s: buf_3state port map(MOSI, mosi_3s_to_mux, int_st);
	MOSI_mux: mux2_1 port map(mosi_3s_to_mux, '0', int_st, mosi_mux_to_buf);
	MOSI_out_3s: buf_3state port map(mosi_buf_to_safe, MOSI, int_st);
	MOSI_buf: shift_reg generic map(width=>8) port map(mosi_mux_to_buf,'0',not(int_ss),tx_buf_to_mux,mosi_buf_to_receive_buf,mosi_buf_to_safe,int_sclk);
	
	MOSI_pull: PULLDOWN port map(O=>MOSI);

--MOSI, Master In, Slave Out
	MISO_in: buf_3state port map(MISO, miso_3s_to_mux, not(int_st));
	MISO_mux: mux2_1 port map(miso_3s_to_mux, '0', not(int_st), miso_mux_to_buf);
	MISO_out: buf_3state port map(miso_buf_to_safe, MISO, not(int_st));
	MISO_buf: shift_reg generic map(width=>8) port map(miso_mux_to_buf,'0',int_ss,tx_buf_to_mux,miso_buf_to_receive_buf,miso_buf_to_safe,int_sclk);

	MISO_pull: PULLDOWN port map(O=>MISO);

-- Receive buffer
	MISO_MOSI_RX_mux: mux2_1n generic map(width=>width) port map (miso_buf_to_receive_buf, mosi_buf_to_receive_buf, mux_to_receive_buf, int_st);
	RX_buf: reg_8 generic map(width=>(width-1)) port map(mux_to_receive_buf, clk, DATA_OUT, '1', '0');

-- Transmit buffer
--	MISO_MOSI_TX_dmux: dmux2_1n generic map(width=>width) port map (mux_to_miso_buf, mux_to_mosi_buf, tx_buf_to_mux, not(int_st));
	TX_buf: reg_8 generic map(width=>(width-1)) port map(DATA, clk, tx_buf_to_mux, '1', '0');
end Behavioral;