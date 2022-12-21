library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use ieee.std_logic_unsigned.all;
use ieee.std_logic_arith.all;

-- PROGRAM Cyphertext Generator

entity cgen is 
	port(
		state : in std_logic_vector(31 downto 0);
		m : in std_logic_vector(119 downto 0);
		cout : out std_logic_vector(119 downto 0);
		mlen : in std_logic_vector(6 downto 0);
		en : in std_logic;
		clock : in std_logic;
		cycle : out std_logic_vector(2 downto 0);
		done : out std_logic;
		reset : in std_logic
	);
end cgen;

architecture main of cgen is
begin
	process(all)
		variable sel : integer range 0 to 32 := 0;
		variable round : integer range 0 to 7 := 0;
	begin
		if clock'event and clock = '1' then
			if en = '1' then
				if sel < 32 and (32*round + sel) < mlen then
					cout(32*round + sel) <= state(sel) xor m(32*round + sel);
					done <= '0';
					sel := sel + 1;
				else
					done <= '1';
					round := round + 1;
					sel := 0;
					cycle <= conv_std_logic_vector(round, 3);
				end if;
			else
				cycle <= (others => 'Z');
			end if;
			if reset = '1' then 
				sel := 0;
				round := 0;
			end if;
		end if;
	end process;
end main;