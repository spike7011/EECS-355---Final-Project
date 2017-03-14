library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;
use work.tank_package.all;

entity tank_game is
	port (
		clk										: in std_logic;
		reset										: in std_logic;
		keyboard_clk, keyboard_data		:in std_logic;
		VGA_RED, VGA_GREEN, VGA_BLUE 						: out std_logic_vector(9 downto 0); 
		HORIZ_SYNC, VERT_SYNC, VGA_BLANK, VGA_CLK		: out std_logic
		
	);

end entity tank_game;

architecture behavior of tank_game is
	component VGA_top_level is
		port(
			CLOCK_50 										: in std_logic;
			RESET_N											: in std_logic;
			tank_a_x, tank_b_x									: in integer;
			bullet_position_a, bullet_position_b							: in coordinate;
			VGA_RED, VGA_GREEN, VGA_BLUE 					: out std_logic_vector(9 downto 0); 
			HORIZ_SYNC, VERT_SYNC, VGA_BLANK, VGA_CLK		: out std_logic

		);
	end component;

	
	signal tank_x, new_tank_x			   : integer;
	signal tank_y, new_tank_y 				: integer;
	signal speed_x, speed_y 				: integer;
	signal tank_clk_x, tank_clk_y 		: std_logic;
	signal hist3_signal, hist2_signal, hist1_signal, hist0_signal: std_logic_vector(7 downto 0);
	signal scan_code_signal 				: std_logic_vector( 7 downto 0 );
	signal scan_readyo_signal 				: std_logic;
	signal not_reset							: std_logic;
	signal speed_out_x, speed_out_y 		: std_logic_vector(3 downto 0);
	signal bullet_clk, bullet_fired_a, current_bullet_exists_a, new_bullet_exists_a : std_logic;
	signal bullet_fired_b, current_bullet_exists_b, new_bullet_exists_b : std_logic;
	signal current_bullet_position_a, current_tank_position_a, new_bullet_position_a : coordinate;
	signal current_bullet_position_b, current_tank_position_b, new_bullet_position_b : coordinate;

begin

	vga: VGA_top_level
		port map (clk, reset, new_tank_x,new_tank_y, current_bullet_position_a, current_bullet_position_b, VGA_RED, VGA_GREEN, VGA_BLUE, HORIZ_SYNC, VERT_SYNC, VGA_BLANK, VGA_CLK);
	
	xtank: top_tank
		port map (tank_clk_x, reset, tank_x, new_tank_x);
	ytank: top_tank
		port map (tank_clk_y, reset, tank_y, new_tank_y);

	tank_clock_x: tank_clock
		port map (clk, reset, speed_x, tank_clk_x); 
	tank_clock_y: tank_clock
		port map (clk, reset, speed_y, tank_clk_y);

	tank_x_register: integer_register
		port map (tank_clk_x, new_tank_x, tank_x);
	tank_y_register: integer_register
		port map (tank_clk_y, new_tank_y, tank_y);

	current_tank_position_a(0) <= new_tank_x;
	current_tank_position_a(1) <= 0;

	current_tank_position_b(0) <= new_tank_y;
	current_tank_position_b(1) <= 0;

	b_clock: bullet_clock
		port map (clk, reset, bullet_clk);

	bullet_a_pos_register: coordinate_register
		port map (bullet_clk, new_bullet_position_a, current_bullet_position_a);

	bullet_b_pos_register: coordinate_register
		port map (bullet_clk, new_bullet_position_b, current_bullet_position_b);

	bullet_a_exists_register: std_logic_register
		port map (bullet_clk, new_bullet_exists_a, current_bullet_exists_a);

	bullet_b_exists_register: std_logic_register
		port map (bullet_clk, new_bullet_exists_b, current_bullet_exists_b);

	bullet_a_pos: bullet_position
		port map (bullet_clk, reset, '0', bullet_fired_a, current_bullet_exists_a, current_bullet_position_a, current_tank_position_a, new_bullet_position_a, new_bullet_exists_a);

	bullet_b_pos: bullet_position
		port map (bullet_clk, reset, '1', bullet_fired_b, current_bullet_exists_b, current_bullet_position_b, current_tank_position_b, new_bullet_position_b, new_bullet_exists_b);

	not_reset <= not reset;

	keyboard_map : ps2 
		port map(keyboard_clk, keyboard_data, clk, not_reset,scan_code_signal,scan_readyo_signal,hist3_signal,hist2_signal,hist1_signal,hist0_signal);

	p1: process(scan_readyo_signal, reset)
		variable speed_temp_x, speed_temp_y : integer;
		
	begin	
		speed_temp_x := speed_temp_x;
		speed_temp_y := speed_temp_y;
		if (falling_edge(scan_readyo_signal)) then
			if(hist0_signal = x"1D" and hist1_signal =x"F0" and hist2_signal = x"1D") then -- w
				if (speed_temp_x < 3) then
					speed_temp_x := speed_temp_x + 1;
				else
					speed_temp_x := speed_temp_x;
				end if;
			elsif(hist0_signal = x"15" and hist1_signal =x"F0" and hist2_signal = x"15")then -- q
				if (speed_temp_x > 1) then
					speed_temp_x := speed_temp_x - 1;
				else
					speed_temp_x := speed_temp_x;
				end if;
			else
				speed_temp_x := speed_temp_x;
			end if;
			if(hist0_signal = x"7D" and hist1_signal =x"F0" and hist2_signal = x"7D") then -- 9
				if (speed_temp_y < 3) then
					speed_temp_y := speed_temp_y + 1;
				else
					speed_temp_y := speed_temp_y;
				end if;
			elsif(hist0_signal = x"75" and hist1_signal =x"F0" and hist2_signal = x"75")then -- 8
				if (speed_temp_y > 1) then
					speed_temp_y := speed_temp_y - 1;
				else
					speed_temp_y := speed_temp_y;
				end if;
			else
				speed_temp_y := speed_temp_y;
			end if;
			if (hist0_signal = x"24" and hist1_signal =x"F0" and hist2_signal = x"24")then --E
				bullet_fired_a <= '1';
				else bullet_fired_a <= '0';
			end if;
			if (hist0_signal = x"6C" and hist1_signal =x"F0" and hist2_signal = x"6C")then --7
				bullet_fired_b <= '1';
				else bullet_fired_b <= '0';
			end if;
		end if;

		if (reset = '1') then
			speed_temp_x := 1;
			speed_temp_y := 1;
			bullet_fired_a <= '0';
		   bullet_fired_b <= '0';
		end if;
		
		speed_x <= speed_temp_x;
		speed_y <= speed_temp_y;
		speed_out_x <= std_logic_vector(to_unsigned(speed_temp_x, 4));
		speed_out_y <= std_logic_vector(to_unsigned(speed_temp_y, 4));
	end process p1;
end architecture behavior;