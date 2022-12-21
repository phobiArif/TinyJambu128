library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use ieee.std_logic_unsigned.all;
use ieee.std_logic_arith.all;

--PROGRAM FrameBits Embedding

entity fb_em is
	port(
		fb : in std_logic_vector(2 downto 0);
		fb_en : in std_logic;
		statein : in std_logic_vector(2 downto 0);
		stateout : out std_logic_vector(2 downto 0);
		done : out std_logic
	);
end fb_em;

architecture main of fb_em is
begin
	process(all)
	begin
		if fb_en = '1' then
			for i in 0 to 2 loop
				stateout(i) <= statein(i) xor fb(i);
			end loop;
			done <= '1';
		else
			stateout <= (others => 'Z');
			done <= '0';
		end if;
	end process;
end main;