LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;
USE IEEE.STD_LOGIC_ARITH.ALL;
USE IEEE.STD_LOGIC_UNSIGNED.ALL;

entity top_tank is
	port(
	clk : in std_logic;
	rst : in std_logic;
	x_in : in integer;
	keyboard_clk, keyboard_data:in std_logic;
	x_out : out integer);
end entity;

architecture behav of top_tank is
signal hist3_signal, hist2_signal, hist1_signal, hist0_signal: std_logic_vector(7 downto 0);
signal scan_code_signal : std_logic_vector( 7 downto 0 );
signal scan_readyo_signal : std_logic;

component ps2 is
	port( 	keyboard_clk, keyboard_data, clock_50MHz ,
			reset : in std_logic;--, read : in std_logic;
			scan_code : out std_logic_vector( 7 downto 0 );
			scan_readyo : out std_logic;
			hist3 : out std_logic_vector(7 downto 0);
			hist2 : out std_logic_vector(7 downto 0);
			hist1 : out std_logic_vector(7 downto 0);
			hist0 : out std_logic_vector(7 downto 0)
		);
end component;
begin
keyboard_map : ps2 port map(keyboard_clk, keyboard_data, clk
,rst,scan_code_signal,scan_readyo_signal,hist3_signal,hist2_signal,hist1_signal,hist0_signal);
	tank_process : process(clk, rst) is
		variable DIRECTION : integer;
		variable x_last : integer := 60;
	begin
		x_last := x_last;
	if (rising_edge(clk)) then
		if (scan_readyo_signal='1' and hist1_signal="11110000") then
			if(scan_code_signal=x"1D") then -- w
				DIRECTION := 1;
			end if;
			if(scan_code_signal=x"15") then -- q
				DIRECTION := -1;
			end if;
		end if;
		if(x_last>=500) then
			DIRECTION := -1;
		elsif(x_last<=60) then
			DIRECTION := 1;
		end if;
			x_last := x_last + DIRECTION;
	end if;

		if (rst = '1') then
			x_last := 60;
			DIRECTION := 1;
		end if;

	x_out <= x_last;
	
	end process tank_process;
end architecture;