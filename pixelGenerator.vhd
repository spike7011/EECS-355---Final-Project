library IEEE;

use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;

entity pixelGenerator is
	port(
			clk, ROM_clk, rst_n, video_on, eof 				: in std_logic;
			pixel_row, pixel_column						    : in std_logic_vector(9 downto 0);
			tank_a_x, tank_b_x, bullet_a_y, bullet_b_y, bullet_a_x, bullet_b_x 	: in integer;
			red_out, green_out, blue_out					: out std_logic_vector(9 downto 0)
		);
end entity pixelGenerator;

architecture behavioral of pixelGenerator is

constant color_red 	 	 : std_logic_vector(2 downto 0) := "000";
constant color_green	 : std_logic_vector(2 downto 0) := "001";
constant color_blue 	 : std_logic_vector(2 downto 0) := "010";
constant color_yellow 	 : std_logic_vector(2 downto 0) := "011";
constant color_magenta 	 : std_logic_vector(2 downto 0) := "100";
constant color_cyan 	 : std_logic_vector(2 downto 0) := "101";
constant color_black 	 : std_logic_vector(2 downto 0) := "110";
constant color_white	 : std_logic_vector(2 downto 0) := "111";

component colorROM is
	port
	(
		address		: in std_logic_vector (2 downto 0);
		clock		: in std_logic  := '1';
		q			: out std_logic_vector (29 downto 0)
	);
end component colorROM;



signal colorAddress : std_logic_vector (2 downto 0);
signal color        : std_logic_vector (29 downto 0);

signal pixel_row_int, pixel_column_int : natural;

begin

--------------------------------------------------------------------------------------------
	
	red_out <= color(29 downto 20);
	green_out <= color(19 downto 10);
	blue_out <= color(9 downto 0);

	pixel_row_int <= to_integer(unsigned(pixel_row));
	pixel_column_int <= to_integer(unsigned(pixel_column));
	
--------------------------------------------------------------------------------------------	
	
	colors : colorROM
		port map(colorAddress, ROM_clk, color);
	--bullet_a_y <= 0;bullet_b_y <=0;
	
--------------------------------------------------------------------------------------------	
	pixelDraw : process(clk, rst_n) is
	
	begin
		--bullet_a_x <= tank_a_x;
		--bullet_b_x <= tank_b_x;
		if (rising_edge(clk)) then
		--	if (pixel_row_int < 240 and pixel_column_int < 320) then
		--		colorAddress <= color_green;
		--	elsif (pixel_row_int >= 240 and pixel_column_int < 320) then
		--		colorAddress <= color_yellow;
			if (pixel_row_int < 80 and pixel_column_int > (tank_a_x) and pixel_column_int < (120 + tank_a_x)) then
				colorAddress <= color_red;
			elsif (pixel_row_int >400 and pixel_column_int >(tank_b_x) and pixel_column_int < (120+tank_b_x)) then
				colorAddress <= color_blue;
			elsif (pixel_row_int <110 and pixel_row_int >80 and pixel_column_int > (tank_a_x + 50) and pixel_column_int <(70 + tank_a_x)) then
				colorAddress <= color_red;
			elsif (pixel_row_int <400 and pixel_row_int >370 and pixel_column_int > (tank_b_x + 50) and pixel_column_int <(70 + tank_b_x)) then
				colorAddress <= color_blue;
			elsif (pixel_row_int <115 and pixel_row_int >110 and pixel_column_int > (tank_a_x + 50) and pixel_column_int < (tank_a_x + 70)) then
				colorAddress <= color_black;
			elsif (pixel_row_int <370 and pixel_row_int >365 and pixel_column_int > (tank_b_x + 50) and pixel_column_int <(tank_b_x + 70)) then
				colorAddress <= color_black;
			elsif (pixel_row_int < (bullet_a_y + 5) and pixel_row_int >(bullet_a_y - 5) and pixel_column_int > (bullet_a_x - 5) and pixel_column_int < (bullet_a_x + 5)) then
				colorAddress <= color_green;
			elsif (pixel_row_int < (bullet_b_y + 5) and pixel_row_int >(bullet_b_y - 370) and pixel_column_int > (bullet_b_x - 5) and pixel_column_int < (bullet_b_x + 5)) then
				colorAddress <= color_green;
			else
				colorAddress <= color_white;
			end if;
		end if;
		
	end process pixelDraw;	

--------------------------------------------------------------------------------------------
	
end architecture behavioral;		