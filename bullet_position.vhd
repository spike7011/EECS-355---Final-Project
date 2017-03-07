-- Bullet

library IEEE;
use IEEE.std_logic_1164.all;
use work.tank_package.all;

entity bullet_position is
	port (
		clk: std_logic;
		reset: std_logic;
		current_bullet_position : coordinate;
		new_bullet_position: coordinate
	);
end entity bullet_position;

architecture behavior of bullet_position is

begin
	update_position: process (clk, reset)
	begin
	
	end process update_position;
end architecture behavior;
		