-- Tank Game Package

library IEEE;
use IEEE.std_logic_1164.all;

package tank_package is
	constant BOUNDING_BOX_CORNERS : natural := 4;
	type bounding_box is array(0 to BOUNDING_BOX_CORNERS - 1) of integer; -- (x_left, x_right, y_top, y_bottom)


	component top_tank is
		port(
		clk : in std_logic;
		rst : in boolean;
		x_in : in integer;
		SPEED : in integer;
		x_out : out integer);
	end component;
	
	component collision_detector is
		port (
			bounding_box_a : in bounding_box;
			bounding_box_b : in bounding_box;
			collision : out std_logic
		);
	end component;
	
end entity collision_detector;
end package tank_package;
package body tank_package is

end package body tank_package;
