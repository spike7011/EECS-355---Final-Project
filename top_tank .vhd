LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;
USE IEEE.STD_LOGIC_ARITH.ALL;
USE IEEE.STD_LOGIC_UNSIGNED.ALL;

entity top_tank is
	port(
	clk : in std_logic;
	rst : in boolean;
	x_in : in integer;
	SPEED : in integer;
	x_out : out integer);
end entity;

architecture behav of top_tank is


	begin

		tank_process : process(clk, rst) is
			variable DIRECTION : integer;
			variable x_last : integer := 0;
			begin
				if rising_edge(clk) then

					if (x_last <= x_in) then
						DIRECTION := 1;
					else DIRECTION := -1;
				end if;

				case DIRECTION is
					when 1 => x_out <= x_in + 1*SPEED;
					when -1 => x_out <= x_in - 1*SPEED;
					when others => x_out <= x_in;
				end case;

			elsif rst then
				x_out <= 0;
			end if;

		end process;
	end architecture;
