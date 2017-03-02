-- Collision Detector

library IEEE;
use IEEE.std_logic_1164.all;
use work.tank_package.all;

entity collision_detector is
	port (
		bounding_box_a : in bounding_box;
		bounding_box_b : in bounding_box;
		collision : out std_logic
	);
end entity collision_detector;

architecture behavioral of collision_detector is
	signal overlap_left, overlap_right, overlap_top, overlap_bottom : std_logic;
begin
	check_collision: process (bounding_box_a, bounding_box_b)
	begin
	
		-- initialize to prevent latches
		overlap_left <= '0';
		overlap_right <= '0';
		overlap_top <= '0';
		overlap_top <= '0';
		collision <= '0';
		
		-- check if a_left_x is between b_left_x and b_right_x
		if (bounding_box_a(0) >= bounding_box_b(0)) and (bounding_box_a(0) <= bounding_box_b(1)) then
			overlap_left <= '1';
		end if;
			
		-- check if a_right_x is between b_left_x and b_right_x
		if (bounding_box_a(1) >= bounding_box_b(0)) and (bounding_box_a(1) <= bounding_box_b(1)) then
			overlap_right <= '1';
		end if;
			
		-- check if a_top_y is between b_top_y and b_bottom_y
		if (bounding_box_a(2) >= bounding_box_b(2)) and (bounding_box_a(2) <= bounding_box_b(3)) then
			overlap_top <= '1';
		end if;
	
		-- check if a_bottom_y is between b_top_y and b_bottom_y
		if (bounding_box_a(3) >= bounding_box_b(2)) and (bounding_box_a(3) <= bounding_box_b(3)) then
			overlap_bottom <= '1';
		end if;
		
		-- check for collision
		if (overlap_left or overlap_right) and (overlap_top or overlap_bottom) then
			collision <= '1';
		end if;
	end process check_collision;
end architecture behavioral;