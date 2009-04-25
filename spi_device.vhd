----------------------------------------------------------------------------------
-- Company: SIUC ECE428
-- Engineer: Joseph Lenox
-- Create Date:    14:47:55 04/17/2009 
-- Design Name: spi_engine
-- Module Name:    spi_master - Behavioral 
-- Project Name: 
-- Target Devices: 
-- Tool versions: 
-- Description: Flexible implementation of SPI Bus for Xilinx FPGAs.
--
-- Dependencies: buf_3state, mux2_1, in_out, shift_reg, reg_8, spi_control
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
	 generic(-- Width of the TX/RX registers.
	         width: natural := 8;
	         -- This specifies the clock rate (based on the host clock) that this device
				-- will use as its serial clock when it is acting as master.
	         clock_divisor : natural := 4);
    Port ( -- Master In, Slave Out. 
	        MISO : inout  STD_LOGIC;
			  -- Master Out, Slave In.
           MOSI : inout  STD_LOGIC;
			  -- Slave Select. This will be pulled low for communication.
           SS : inout  STD_LOGIC;
			  -- Serial Clock. This is an input when the circuit is a slave.
           SCLK : inout  STD_LOGIC;
			  -- Data from this device to be transferred. 
           DATA : in  STD_LOGIC_VECTOR ((width-1) downto 0);
			  -- Data received from a remote device.
			  DATA_OUT: out STD_LOGIC_VECTOR ((width-1) downto 0);
			  -- External clock from host.
           CLK : in  STD_LOGIC;
			  -- Assume master and start data transfer.
			  st: in STD_LOGIC);
end spi_device;

architecture Behavioral of spi_device is

component shift_reg is
	 generic (initial : integer := 0;
	          width: integer := 8);
    Port ( serial_in : in  STD_LOGIC;
	        serial_out: out STD_LOGIC;
			  -- 0 for right shift, 1 for left shift.
			  dir : in STD_LOGIC;
           load : in  STD_LOGIC;
           D : in  STD_LOGIC_VECTOR ((width-1) downto 0);
			  Q : out STD_LOGIC_VECTOR ((width-1) downto 0);
           EN : in STD_LOGIC;
			  RES : in STD_LOGIC;
           CLK : in  STD_LOGIC);
end component;

component clk_gen is
    Port ( clk : in  STD_LOGIC;
	        en : in STD_LOGIC;
           clk_out : out  STD_LOGIC;
           div : in  STD_LOGIC_VECTOR (3 downto 0));
end component;

component reg_n is 
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
	 generic (len: natural := 8);
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
signal int_st_inv: STD_LOGIC;

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

	int_st_inv <= not(int_st);
-- Control for the ST (start) behavior.
	ST_switch : spi_control port map(st, int_st, sclk);
-- In/out behavior for SS
	SS_external: buf_3state port map(SS, ss_to_mux, int_st_inv);
	SS_to_ext: buf_3state port map(int_ss, SS, int_st);
	SS_mux : mux2_1 port map (ss_to_mux, '0', int_st, int_ss);
	SS_pullup: PULLUP port map (O=>SS);	
	
-- In/out behavior for SCLK
	
	SCLK_in_3s:  buf_3state port map(SCLK, sclk_3s_to_mux, int_st);
	SCLK_out_3s: buf_3state port map(int_sclk,  SCLK, int_st);
	SCLK_mux: mux2_1 port map (sclk_3s_to_mux, sclk_from_clkgen, int_st, int_sclk);
	SCLK_pull: PULLDOWN port map(O=>SCLK);
	SCLK_gen: clk_gen port map(clk, int_st, sclk_from_clkgen, X"4"); -- sclk is clk / 4
	
--MOSI, Master Out, Slave In
	MOSI_in_3s: buf_3state port map(i=> MOSI, o=> mosi_3s_to_mux, en=> int_st_inv);
	MOSI_mux: mux2_1 port map(mosi_3s_to_mux, '0', int_st, mosi_mux_to_buf);
	MOSI_out_3s: buf_3state port map(mosi_buf_to_safe, MOSI, int_st);
	MOSI_buf: shift_reg generic map(width=>8)
 	                    port map(serial_in=> mosi_mux_to_buf, dir=>'0', load=>int_st, 
	                             D=> tx_buf_to_mux, Q=> mosi_buf_to_receive_buf, 
								        serial_out=>mosi_buf_to_safe, CLK=> int_sclk, EN=>'1', RES=>'0');
	MOSI_pull: PULLDOWN port map(O=>MOSI);

--MISO, Master In, Slave Out
	MISO_in: buf_3state port map(i=> MISO, o=> miso_3s_to_mux, en=> int_st);
	MISO_mux: mux2_1 port map('0', miso_3s_to_mux, int_st, miso_mux_to_buf);
	MISO_out: buf_3state port map(miso_buf_to_safe, MISO, int_st_inv);
	MISO_buf: shift_reg generic map(width=>8) 
	                    port map(serial_in=> miso_mux_to_buf, serial_out=> miso_buf_to_safe, dir=> '0',
	                             load=> int_st_inv, D=> tx_buf_to_mux, Q=> miso_buf_to_receive_buf, CLK=> int_sclk,
								        EN=> '1', RES=>'0');
	MISO_pull: PULLDOWN port map(O=>MISO);

-- Receive buffer
	MISO_MOSI_RX_mux: mux2_1n generic map(width=>width) port map (miso_buf_to_receive_buf, mosi_buf_to_receive_buf, mux_to_receive_buf, int_st);
	RX_buf: reg_n generic map(width=>(width-1)) port map(mux_to_receive_buf, clk, DATA_OUT, '1', '0');

-- Transmit buffer
	TX_buf: reg_n generic map(width=>(width-1)) port map(DATA, clk, tx_buf_to_mux, '1', '0');

end Behavioral;