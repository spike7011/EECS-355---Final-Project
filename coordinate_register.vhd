LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;
USE IEEE.STD_LOGIC_ARITH.ALL;
USE IEEE.STD_LOGIC_UNSIGNED.ALL;
USE WORK.TANK_PACKAGE.ALL;

entity coordinate_register is
	port(
	clk : in std_logic;
	int_in : in coordinate;
	int_out : inout coordinate);
end entity;

architecture behavior of coordinate_register is
begin
	p: process(clk) is
	begin
		int_out <= int_out;
		if (rising_edge(clk)) then
			int_out <= int_in;
		end if;
	end process p;
end architecture behavior;