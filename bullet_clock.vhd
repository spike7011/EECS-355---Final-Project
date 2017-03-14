library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;
use work.tank_package.all;

entity bullet_clock is
	port (
		clk			: in std_logic;
		reset			: in std_logic;
		bullet_clk		: out std_logic
	);
end entity bullet_clock;

architecture behavior of bullet_clock is

begin
	bullet_clock: process(clk, reset) is
		variable counter : integer := 0;
	begin
		counter := counter;
		if (rising_edge(clk)) then
			counter := counter + 1;
			if (counter >= 100000 and counter < 200000) then
				bullet_clk <= '1';
			elsif (counter >= 20) then
				counter := 0;
				bullet_clk <= '0';
			end if;
		end if;

		if (reset = '1') then
			counter := 0;
			bullet_clk <= '0';
		end if;
	end process bullet_clock;
end architecture behavior;