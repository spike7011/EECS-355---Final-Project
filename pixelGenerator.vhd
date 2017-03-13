library IEEE;

use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;

entity pixelGenerator is
	port(
			clk, ROM_clk, rst_n, video_on, eof 				: in std_logic;
			pixel_row, pixel_column						    : in std_logic_vector(9 downto 0);
			offset_x, offset_y, offset_bx, offset_by, bul_pos_x, bul_pos_y 	: in integer;
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
	--offset_bx <= 0;offset_by <=0;
	
--------------------------------------------------------------------------------------------	
	pixelDraw : process(clk, rst_n) is
	
	begin
		--bul_pos_x <= offset_x;
		--bul_pos_y <= offset_y;
		if (rising_edge(clk)) then
		--	if (pixel_row_int < 240 and pixel_column_int < 320) then
		--		colorAddress <= color_green;
		--	elsif (pixel_row_int >= 240 and pixel_column_int < 320) then
		--		colorAddress <= color_yellow;
			if (pixel_row_int < 80 and pixel_column_int > (offset_x) and pixel_column_int < (120 + offset_x)) then
				colorAddress <= color_red;
			elsif (pixel_row_int >400 and pixel_column_int >(offset_y) and pixel_column_int < (120+offset_y)) then
				colorAddress <= color_blue;
			elsif (pixel_row_int <110 and pixel_row_int >80 and pixel_column_int > (offset_x + 50) and pixel_column_int <(70 + offset_x)) then
				colorAddress <= color_red;
			elsif (pixel_row_int <400 and pixel_row_int >370 and pixel_column_int > (offset_y + 50) and pixel_column_int <(70 + offset_y)) then
				colorAddress <= color_blue;
			elsif (pixel_row_int <115 and pixel_row_int >110 and pixel_column_int > (offset_x + 50) and pixel_column_int < (offset_x + 70)) then
				colorAddress <= color_black;
			elsif (pixel_row_int <370 and pixel_row_int >365 and pixel_column_int > (offset_y + 50) and pixel_column_int <(offset_y + 70)) then
				colorAddress <= color_black;
			elsif (pixel_row_int < (offset_bx + 125) and pixel_row_int >(offset_bx + 115) and pixel_column_int > (bul_pos_x+55) and pixel_column_int < (bul_pos_x+65)) then
				colorAddress <= color_green;
			elsif (pixel_row_int < (offset_by + 380) and pixel_row_int >(offset_by + 370) and pixel_column_int > (bul_pos_y+55) and pixel_column_int < (bul_pos_y+65)) then
				colorAddress <= color_green;
			else
				colorAddress <= color_white;
			end if;
		end if;
		
	end process pixelDraw;	

--------------------------------------------------------------------------------------------
	
end architecture behavioral;		