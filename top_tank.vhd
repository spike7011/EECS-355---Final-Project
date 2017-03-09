LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;
USE IEEE.STD_LOGIC_ARITH.ALL;
USE IEEE.STD_LOGIC_UNSIGNED.ALL;

entity top_tank is
	port(
	rst : in std_logic;
	x_in : in integer;
	SPEED : in integer;
	x_out : out integer);
end entity;

architecture behav of top_tank is


	begin

		tank_process : process(x_in) is
			variable DIRECTION : integer;
			variable x_last : integer := 60;
			begin
				if (x_last >= 580) then
						DIRECTION := -1;
					elsif(x_last <= 60 ) then DIRECTION := 1;
					else DIRECTION := 0;
				end if;

				case DIRECTION is
					when 1 => x_last := x_last + 1*SPEED;
					when -1 => x_last := x_last - 1*SPEED;
					when others => x_out <= x_last;
				end case;
			x_last := x_last;
			if (rst = '1') then
				
				x_last := x_last;
			end if;
			x_out <= x_last;
			
		end process;
	end architecture;