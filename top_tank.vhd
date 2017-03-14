LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;
USE IEEE.STD_LOGIC_ARITH.ALL;
USE IEEE.STD_LOGIC_UNSIGNED.ALL;

entity top_tank is
	port(
	clk : in std_logic;
	rst : in std_logic;
	x_in: in integer;
	x_out : out integer);
end entity;

architecture behav of top_tank is

begin
	tank_process : process(clk, rst) is
		variable DIRECTION_x : integer;
		variable x_last : integer;
	begin
		x_last := x_last;
	if (rising_edge(clk)) then
		if(x_last>=520) then
			DIRECTION_x := -1;
		elsif(x_last<=0) then
			DIRECTION_x := 1;
		end if;
		
	   x_last := x_last + DIRECTION_x;
	end if;

		if (rst = '1') then
			x_last := 0;
			DIRECTION_x := 1;
		end if;

	x_out <= x_last;
	
	end process tank_process;
end architecture;