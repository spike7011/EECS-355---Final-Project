library IEEE;

use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;

entity pixelGenerator is
	port(
			clk, ROM_clk, rst_n, video_on, eof 				: in std_logic;
			pixel_row, pixel_column						    : in std_logic_vector(9 downto 0);
			red_out, green_out, blue_out					: out std_logic_vector(9 downto 0);
			tank_x                                    : in integer
			 
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

component top_tank is
	port(
	rst : in std_logic;
	x_in : in integer;
	SPEED : in integer;
	x_out : out integer);
end component;

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
signal offset        : integer;

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

--------------------------------------------------------------------------------------------	
tank_offset: top_tank port map(rst_n, tank_x, 1, offset);
	pixelDraw : process(clk, rst_n) is
	
	begin
			
		if (rising_edge(clk)) then
		--	if (pixel_row_int < 240 and pixel_column_int < 320) then
		--		colorAddress <= color_green;
		--	elsif (pixel_row_int >= 240 and pixel_column_int < 320) then
		--		colorAddress <= color_yellow;
			if (pixel_row_int < 80 and pixel_column_int > (offset) and pixel_column_int < (120 + offset)) then
				colorAddress <= color_red;
			elsif (pixel_row_int >400 and pixel_column_int >(offset) and pixel_column_int < (120+offset)) then
				colorAddress <= color_blue;
			elsif (pixel_row_int <110 and pixel_row_int >80 and pixel_column_int > (offset + 50) and pixel_column_int <(70 + offset)) then
				colorAddress <= color_red;
			elsif (pixel_row_int <400 and pixel_row_int >370 and pixel_column_int > (offset + 50) and pixel_column_int <(70 + offset)) then
				colorAddress <= color_blue;
			elsif (pixel_row_int <115 and pixel_row_int >110 and pixel_column_int > (offset + 50) and pixel_column_int < (offset + 70)) then
				colorAddress <= color_black;
			elsif (pixel_row_int <370 and pixel_row_int >365 and pixel_column_int > (offset + 50) and pixel_column_int <(offset + 70)) then
				colorAddress <= color_black;
			else
				colorAddress <= color_white;
			end if;
		end if;
		
	end process pixelDraw;	

--------------------------------------------------------------------------------------------
	
end architecture behavioral;		