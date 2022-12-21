library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use ieee.std_logic_unsigned.all;
use ieee.std_logic_arith.all;

--PROGRAM Cyphertext Register

entity creg is
	port(
		en : in std_logic;
		clock : in std_logic;
		cin : in std_logic_vector(119 downto 0);
		cout : out std_logic_vector(119 downto 0)
	);
end creg;

architecture main of creg is
	signal c : std_logic_vector(119 downto 0);
begin
	cout <= c;
	process(all)
	begin
		if clock'event and clock = '1' then
			if en = '1' then
				c <= cin;
			end if;
		end if;
	end process;
end main;