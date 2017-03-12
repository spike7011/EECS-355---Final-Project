LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;
USE IEEE.STD_LOGIC_ARITH.ALL;
USE IEEE.STD_LOGIC_UNSIGNED.ALL;

entity top_tank is
	port(
	clk : in std_logic;
	rst : in std_logic;
	x_in : in integer;
	x_out : out integer);
end entity;

architecture behav of top_tank is

begin
	tank_process : process(clk, rst) is
		variable DIRECTION : integer;
		variable x_last : integer := 60;
	begin
		x_last := x_last;
	if (rising_edge(clk)) then
		if(x_last>=500) then
			DIRECTION := -1;
		elsif(x_last<=60) then
			DIRECTION := 1;
		end if;
			x_last := x_last + DIRECTION;
	end if;

		if (rst = '1') then
			x_last := 60;
			DIRECTION := 1;
		end if;

	x_out <= x_last;
	
	end process tank_process;
end architecture;