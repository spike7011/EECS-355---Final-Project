-- Collision Detector

library IEEE;
use IEEE.std_logic_1164.all;
use work.tank_package.all;

entity collision_detector_tb is

end entity collision_detector_tb;

architecture behavior of collision_detector_tb is
	signal bounding_box_a, bounding_box_b : bounding_box;
	signal collision : std_logic;
begin
	DUT: entity work.collision_detector
		port map (bounding_box_a, bounding_box_b, collision);
		
	test: process
	begin
		bounding_box_a <= (0,1,0,1);
		bounding_box_b <= (2,3,2,3);
		wait for 5 ns;
		bounding_box_a <= (0,2,0,2);
		bounding_box_b <= (1,3,1,3);
		wait for 5 ns;
		bounding_box_a <= (0,1,0,1);
		bounding_box_b <= (0,1,1,2);
		wait for 5 ns;
		bounding_box_a <= (2,4,2,4);
		bounding_box_b <= (1,3,1,3);
		wait for 5 ns;
		bounding_box_a <= (0,1,0,1);
		bounding_box_b <= (1,2,0,1);
		wait;
	end process test;
end architecture behavior;
	