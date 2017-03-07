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
		bullet_bounding_box <= ((bullet_position(0) - (BULLET_SIZE(0) / 2)), (bullet_position(0) + (BULLET_SIZE(0) / 2)), (bullet_position(1) - (BULLET_SIZE(1) / 2)), (bullet_position(1) + (BULLET_SIZE(1) / 2)));
		enemy_bounding_box <= ((enemy_position(0) - (TANK_SIZE(0) / 2)), (enemy_position(0) + (TANK_SIZE(0) / 2)), (enemy_position(1) - (TANK_SIZE(1) / 2)), (enemy_position(1) + (TANK_SIZE(1) / 2)));
	end process bounding_boxes;
	
	collision_test: collision_detector
		port map (bullet_bounding_box, enemy_bounding_box, hit);
		
end architecture behavior;
	