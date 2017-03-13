library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;
use work.tank_package.all;

entity tank_game is
	port (
		clk										: in std_logic;
		reset										: in std_logic;
		keyboard_clk, keyboard_data		:in std_logic;
		test1, test2, test3, test4, test5, test6		: out std_logic;
		VGA_RED, VGA_GREEN, VGA_BLUE 						: out std_logic_vector(9 downto 0); 
		HORIZ_SYNC, VERT_SYNC, VGA_BLANK, VGA_CLK		: out std_logic
		
	);

end entity tank_game;

architecture behavior of tank_game is
	component VGA_top_level is
		port(
			CLOCK_50 										: in std_logic;
			RESET_N											: in std_logic;
			tank_x, tank_y									: in integer;
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

begin

	vga: VGA_top_level
		port map (clk, reset, new_tank_x,new_tank_y, VGA_RED, VGA_GREEN, VGA_BLUE, HORIZ_SYNC, VERT_SYNC, VGA_BLANK, VGA_CLK);
	
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
		end if;

		if (reset = '1') then
			speed_temp_x := 1;
			speed_temp_y := 1;
		end if;
		
		speed_x <= speed_temp_x;
		speed_y <= speed_temp_y;
		speed_out_x <= std_logic_vector(to_unsigned(speed_temp_x, 4));
		speed_out_y <= std_logic_vector(to_unsigned(speed_temp_y, 4));
	end process p1;
	p2: process(speed_x, speed_y)
	begin
	if(speed_x = 1) then
	test1 <= '1';else test1 <= '0';
	end if;
	if(speed_x =2) then
	test2 <= '1'; else test2 <= '0';
	end if;
	if(speed_x =3) then
	test3 <= '1'; else test3 <= '0';
	end if;
	if(speed_y = 1) then
	test4 <= '1';else test4 <= '0';
	end if;
	if(speed_y =2) then
	test5 <= '1'; else test5 <= '0';
	end if;
	if(speed_y =3) then
	test6 <= '1'; else test6 <= '0';
	end if;
	end process p2;

end architecture behavior;