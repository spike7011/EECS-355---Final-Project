library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;
use work.tank_package.all;

entity tank_clock is
	port (
		clk			: in std_logic;
		reset			: in std_logic;
		speed			: in integer;
		tank_clk		: out std_logic
	);
end entity tank_clock;

architecture behavior of tank_clock is

begin
	tank_clock: process(clk, reset) is
		variable counter : integer := 0;
	begin
		counter := counter;
		if (rising_edge(clk)) then
			counter := counter + 1;
			if ((counter >= (500000 / speed)) and (counter < (1000000 / speed))) then
				tank_clk <= '1';
			elsif (counter >= (1000000 / speed)) then
				counter := 0;
				tank_clk <= '0';
			end if;
		end if;

		if (reset = '1') then
			counter := 0;
			tank_clk <= '0';
		end if;
	end process tank_clock;
end architecture behavior;