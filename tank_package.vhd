-- Tank Game Package

library IEEE;
use IEEE.std_logic_1164.all;

package tank_package is
	constant BULLET_SPEED : integer := 2;
	constant BOUNDING_BOX_CORNERS : natural := 4;
	type bounding_box is array(0 to BOUNDING_BOX_CORNERS - 1) of integer; -- (x_left, x_right, y_top, y_bottom)
	type coordinate is array(0 to 1) of integer; -- (x, y)
	type size is array(0 to 1) of integer; -- (width, height)
	constant TANK_SIZE : size := (120, 100);
	constant BULLET_SIZE : size := (10, 10);

	component top_tank is
		port(
		clk : in std_logic;
		rst : in std_logic;
		score : in integer;
		x_out : out integer);
	end component;
	component ps2 is
		port( 	keyboard_clk, keyboard_data, clock_50MHz ,
			reset : in std_logic;
			scan_code : out std_logic_vector( 7 downto 0 );
			scan_readyo : out std_logic;
			hist3 : out std_logic_vector(7 downto 0);
			hist2 : out std_logic_vector(7 downto 0);
			hist1 : out std_logic_vector(7 downto 0);
			hist0 : out std_logic_vector(7 downto 0)
		);
	end component;

	component tank_clock is
		port (
			clk			: in std_logic;
			reset			: in std_logic;
			speed			: in integer;
			tank_clk		: out std_logic
		);
	end component;

	component bullet_clock is
		port (
			clk			: in std_logic;
			reset			: in std_logic;
			bullet_clk		: out std_logic
		);
	end component;
	
	component bullet_position is
		port (
			clk: in std_logic;
			reset: in std_logic;
			direction: in std_logic;
			bullet_fired: in std_logic;
			bullet_hit: in std_logic;
			current_bullet_exists: in std_logic;
			current_bullet_position : in coordinate;
			current_tank_position: in coordinate;
			new_bullet_position: out coordinate;
			new_bullet_exists: out std_logic
		);
	end component;

	component collision_detector is
		port (
			bounding_box_a : in bounding_box;
			bounding_box_b : in bounding_box;
			collision : out std_logic
		);
	end component;
	
	component bullet_hit is
		port (
			bullet_position : in coordinate;
			enemy_position: in coordinate;
			hit: out std_logic
		);
	end component;

	component integer_register is
		port(
			clk : in std_logic;
			int_in : in integer;
			int_out : inout integer);
	end component;

	component coordinate_register is
		port(
			clk : in std_logic;
			int_in : in coordinate;
			int_out : inout coordinate);
	end component;

	component std_logic_register is
		port(
			clk : in std_logic;
			int_in : in std_logic;
			int_out : inout std_logic);
	end component;





end package tank_package;
package body tank_package is

end package body tank_package;
