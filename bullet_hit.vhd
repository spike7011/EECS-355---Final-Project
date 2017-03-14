-- Bullet hit

library IEEE;
use IEEE.std_logic_1164.all;
use work.tank_package.all;

entity bullet_hit is
	port (
		bullet_position : in coordinate;
		enemy_position: in coordinate;
		hit: out std_logic
	);
end entity bullet_hit;

architecture behavior of bullet_hit is
	signal bullet_bounding_box : bounding_box;
	signal enemy_bounding_box : bounding_box;
begin
	bounding_boxes: process (bullet_position, enemy_position)
	begin
		bullet_bounding_box(0) <= bullet_position(0) - 5;		bullet_bounding_box(1) <= bullet_position(0) + 5;
		bullet_bounding_box(2) <= bullet_position(1) - 5;
		bullet_bounding_box(3) <= bullet_position(1) + 5;
		enemy_bounding_box(0) <= enemy_position(0);		enemy_bounding_box(1) <= enemy_position(0) + 120;
		enemy_bounding_box(2) <= enemy_position(1);
		enemy_bounding_box(3) <= enemy_position(1) + 80;
	end process bounding_boxes;
	
	collision_test: collision_detector
		port map (bullet_bounding_box, enemy_bounding_box, hit);
		
end architecture behavior;
	