-- Bullet

library IEEE;
use IEEE.std_logic_1164.all;
use work.tank_package.all;

entity bullet_position is
	port (
		clk: in std_logic;
		reset: in std_logic;
		direction: in std_logic;
		bullet_fired: in std_logic;
		current_bullet_exists: in std_logic;
		current_bullet_position : in coordinate;
		current_tank_position: in coordinate;
		new_bullet_position: out coordinate;
		new_bullet_exists: out std_logic
	);
end entity bullet_position;

architecture behavior of bullet_position is
begin
	update_position: process (clk, reset, current_tank_position, current_bullet_position, current_bullet_exists, bullet_fired)
	begin
		-- update bullet on clock
		if rising_edge(clk) then
			new_bullet_exists <= '0';
			new_bullet_position(0) <= current_tank_position(0) + 60;
			new_bullet_position(1) <= current_bullet_position(1);
			
			-- bullet firing event
			if ((bullet_fired = '1') and (current_bullet_exists = '0')) then
				new_bullet_exists <= '1';
				new_bullet_position(0) <= current_tank_position(0) + 60;
				new_bullet_position(1) <= current_bullet_position(1);
				
			-- bullet movement while in the air	
			elsif (current_bullet_exists = '1') then
				new_bullet_exists <= '1';
				new_bullet_position(0) <= current_bullet_position(0);
				
				-- bullet travels down if direction == 0, up if direction == 1
				if (direction = '0') then
					new_bullet_position(1) <= current_bullet_position(1) + 1;
				elsif (direction = '1') then
					new_bullet_position(1) <= current_bullet_position(1) - 1;
				else
					new_bullet_position(1) <= current_bullet_position(1);
				end if;

				if ((current_bullet_position(1) > 475) or (current_bullet_position(1) < 5)) then
					new_bullet_exists <= '0';
					if (direction = '0') then
						new_bullet_position(0) <= current_tank_position(0) + 60;
						new_bullet_position(1) <= current_tank_position(1) + 120;
					elsif (direction = '1') then
						new_bullet_position(0) <= current_tank_position(0) + 60;
						new_bullet_position(1) <= current_tank_position(1) + 360;
					else
						new_bullet_position(0) <= 0;
						new_bullet_position(1) <= 0;
					end if;
				end if;
			end if;
		end if;
		
		-- reset bullet position
		if (reset = '1') then
			new_bullet_exists <= '0';
			if (direction = '0') then
				new_bullet_position(0) <= current_tank_position(0) + 60;
				new_bullet_position(1) <= current_tank_position(1) + 120;
			elsif (direction = '1') then
				new_bullet_position(0) <= current_tank_position(0) + 60;
				new_bullet_position(1) <= current_tank_position(1) + 360;
			else
				new_bullet_position(0) <= 0;
				new_bullet_position(1) <= 0;
			end if;
		end if;

	end process update_position;
end architecture behavior;
		