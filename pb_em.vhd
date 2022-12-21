library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use ieee.std_logic_unsigned.all;
use ieee.std_logic_arith.all;

--PROGRAM partial block embedding

entity pb_em is
	port(
		mlen : in std_logic_vector(6 downto 0);
		statein : in std_logic_vector(1 downto 0);
		stateout : out std_logic_vector(1 downto 0);
		pbade, pbpe : in std_logic;
		done : out std_logic
	);
end pb_em;

architecture main of pb_em is
	signal pb_p : std_logic_vector(4 downto 0);
	constant pb_ad : std_logic_vector(1 downto 0) := "01";
begin
	process(all)
	begin
		pb_p <= mlen(4 downto 0);
		if pbade = '1' and pbpe = '0' then
			for i in 0 to 1 loop
				stateout(i) <= statein(i) xor pb_ad(i);
			end loop;
			done <= '1';
		elsif pbade = '0' and pbpe = '1' then
			for i in 0 to 1 loop
				stateout(i) <= statein(i) xor pb_p(i + 3);
			end loop;
			done <= '1';
		else
			stateout <= (others => 'Z');
			done <= '0';
		end if;
	end process;
end main;