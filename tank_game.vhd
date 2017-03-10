library IEEE;

use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;
use work.tank_package.all;

entity tank_game is
	port (
		clk				: in std_logic;
		reset			: in std_logic;

		VGA_RED, VGA_GREEN, VGA_BLUE 					: out std_logic_vector(9 downto 0); 
		HORIZ_SYNC, VERT_SYNC, VGA_BLANK, VGA_CLK		: out std_logic
	);

end entity tank_game;

architecture behavior of tank_game is
	component VGA_top_level is
		port(
			CLOCK_50 										: in std_logic;
			RESET_N											: in std_logic;
			tank_x											: in integer;
	
			--VGA 
			VGA_RED, VGA_GREEN, VGA_BLUE 					: out std_logic_vector(9 downto 0); 
			HORIZ_SYNC, VERT_SYNC, VGA_BLANK, VGA_CLK		: out std_logic

		);
	end component;

	signal tank_x, new_tank_x : integer;
	signal tank_clk : std_logic;
begin
	vga: VGA_top_level
			port map (clk, reset, new_tank_x, VGA_RED, VGA_GREEN, VGA_BLUE, HORIZ_SYNC, VERT_SYNC, VGA_BLANK, VGA_CLK);

	tank: top_tank
		port map (tank_clk, reset, tank_x, new_tank_x);

	tank_x_register: integer_register
		port map (tank_clk, new_tank_x, tank_x);

	tank_clock: process(clk, reset) is
		variable counter : integer := 0;
	begin
		counter := counter;
		if (rising_edge(clk)) then
			counter := counter + 1;
			if (counter = 100000) then
				tank_clk <= '1';
			elsif (counter = 200000) then
				counter := 0;
				tank_clk <= '0';
			end if;
		end if;
		
		if (reset = '1') then
			counter := 0;
			tank_clk <= '0';
		end if;
	end process tank_clock;

end architecture behavior;