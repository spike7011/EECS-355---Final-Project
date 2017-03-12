library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;
use work.tank_package.all;

entity tank_game is
	port (
		clk				: in std_logic;
		reset			: in std_logic;
		--hist1_signal: in std_logic_vector(7 downto 0);
		--scan_code_signal : in std_logic_vector( 7 downto 0 );
		--scan_readyo_signal : in std_logic
		keyboard_clk, keyboard_data:in std_logic;
		test1, test2, test3: out std_logic;
		leds: out std_logic_vector (6 downto 0);
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

	component leddcd is
		port(
			 data_in : in std_logic_vector(3 downto 0);
			 segments_out : out std_logic_vector(6 downto 0)
			);
	end component;
	

	signal tank_x, new_tank_x : integer;
	signal speed : integer;
	signal tank_clk : std_logic;
	signal hist3_signal, hist2_signal, hist1_signal, hist0_signal: std_logic_vector(7 downto 0);
	signal scan_code_signal : std_logic_vector( 7 downto 0 );
	signal scan_readyo_signal : std_logic;
	signal not_reset: std_logic;
	signal speed_out : std_logic_vector(3 downto 0);
begin
	vga: VGA_top_level
		port map (clk, reset, new_tank_x, VGA_RED, VGA_GREEN, VGA_BLUE, HORIZ_SYNC, VERT_SYNC, VGA_BLANK, VGA_CLK);

	tank: top_tank
		port map (tank_clk, reset, tank_x, new_tank_x);

	tank_clock_a: tank_clock
		port map (clk, reset, speed, tank_clk); 

	tank_x_register: integer_register
		port map (tank_clk, new_tank_x, tank_x);

	not_reset <= not reset;

	keyboard_map : ps2 port map(keyboard_clk, keyboard_data, clk, not_reset,scan_code_signal,scan_readyo_signal,hist3_signal,hist2_signal,hist1_signal,hist0_signal);

	p1: process(scan_readyo_signal, reset)
		variable speed_temp : integer;
	begin	
		speed_temp := speed_temp;
		if (rising_edge(scan_readyo_signal)) then
			if(hist0_signal = x"1D" and hist1_signal =x"F0" and hist2_signal = x"1D") then -- w
				if (speed_temp < 3) then
					speed_temp := speed_temp + 1;
				else
					speed_temp := speed_temp;
				end if;
			elsif(hist0_signal = x"15" and hist1_signal =x"F0" and hist2_signal = x"15")then -- q
				if (speed_temp > 1) then
					speed_temp := speed_temp - 1;
				else
					speed_temp := speed_temp;
				end if;
			else
				speed_temp := speed_temp;
			end if;
		end if;

		if (reset = '1') then
			speed_temp := 1;
		end if;
		
		speed <= speed_temp;
		speed_out <= std_logic_vector(to_unsigned(speed_temp, 4));
	end process p1;
	p2: process(speed)
	begin
	if(speed = 1) then
	test1 <= '1';else test1 <= '0';
	end if;
	if(speed =2) then
	test2 <= '1'; else test2 <= '0';
	end if;
	if(speed =3) then
	test3 <= '1'; else test3 <= '0';
	end if;
	end process p2;

	decoder: leddcd
		port map(speed_out, leds);
end architecture behavior;