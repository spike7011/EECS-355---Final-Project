LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;
USE IEEE.STD_LOGIC_ARITH.ALL;
USE IEEE.STD_LOGIC_UNSIGNED.ALL;

entity top_tank_tb is
end entity;


architecture behav of top_tank_tb is


	component top_tank is
		port(
		clk : in std_logic;
		rst : in boolean;
		x_in : in integer;
		SPEED : in integer;
		x_out : out integer);
	end component;

	signal clk_tb : std_logic;
	signal rst_tb : boolean;
	signal x_in_tb, x_out_tb, SPEED_tb : integer;




	begin

		dut : top_tank port map(clk_tb, rst_tb, x_in_tb, SPEED_tb, x_out_tb);
		testbench : process begin
			SPEED_tb <= 1;
			clk_tb <= '0';
			x_in_tb <= 0;
			wait for 1 ns;
			clk_tb <= '1';
			wait for 1 ns;
			clk_tb <= '0';
			x_in_tb <= x_out_tb;
			wait for 1 ns;


			for i in 0 to 20000 loop
				clk_tb <= '1';
				wait for 1 ns;
				clk_tb <= '0';
				x_in_tb <= x_out_tb;
				wait for 1 ns;
			end loop;


		end process;

	end architecture;
