library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use ieee.std_logic_unsigned.all;
use ieee.std_logic_arith.all;

--PROGRAM Tag Generator

entity tgen is
	port(
		state : in std_logic_vector(31  downto 0);
		tagout : out std_logic_vector(63 downto 0);
		en1, en2 : in std_logic
	);
end tgen;

architecture main of tgen is
	signal tag1 : std_logic_vector(31 downto 0);
	signal tag2 : std_logic_vector(31 downto 0);
begin
	process(all)
	begin
		if en1 = '1' and en2 = '0' then
			tag1(31 downto 0) <= state;
		elsif en1 = '0' and en2 = '1' then
			tag2(31 downto 0) <= state;
		end if;
		tagout <= tag1 & tag2;
	end process;
end main;