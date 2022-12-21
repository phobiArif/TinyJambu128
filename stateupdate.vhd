library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use ieee.std_logic_unsigned.all;
use ieee.std_logic_arith.all;

--PROGRAM state update

entity stateupdate is
	port(
		ne, ade, pe : in std_logic;
		nscd, adscd, pscd : out std_logic;
		m : in std_logic_vector(119 downto 0);
		mlen : in std_logic_vector(6 downto 0);
		statein : in std_logic_vector(31 downto 0);
		stateout : out std_logic_vector(31 downto 0);
		clock : in std_logic;
		cycle : out std_logic_vector(2 downto 0);
		reset : in std_logic
	);
end stateupdate;

architecture main of stateupdate is
	constant nonce : std_logic_vector(95 downto 0) := x"4b656c6f6d706f6b31333231";--Kelompok1321
	constant ad : std_logic_vector(71 downto 0) := x"7261696e796f6e6171";--rainyonar
begin
	process(all)
		variable sel : integer range 0 to 32 := 0;
		variable round : integer range 0 to 7 := 0;
	begin
		if clock'event and clock = '1' then
			if ne = '1' and ade = '0' and pe = '0' then
				if sel < 32 then
					stateout(sel) <= statein(sel) xor nonce(32*round + sel);
					nscd <='0';
					sel := sel + 1;
				else
					nscd <= '1';
					round := round + 1;
					sel := 0;
					cycle <= conv_std_logic_vector(round, 3);
				end if;
			elsif ne = '0' and ade = '1' and pe = '0' then
				if sel < 32 and (32*round + sel) < 72 then
					stateout(sel) <= statein(sel) xor ad(32*round + sel);
					adscd <= '0';
					sel := sel + 1;
				else
					adscd <= '1';
					round := round + 1;
					sel := 0;
					cycle <= conv_std_logic_vector(round, 3);
				end if;
			elsif ne = '0' and ade = '0' and pe = '1' then
				if sel < 32 and (32*round + sel) < mlen then
					stateout(sel) <= statein(sel) xor m(32*round + sel);
					pscd <= '0';
					sel := sel + 1;
				else
					pscd <= '1';
					sel := 0;
				end if;
			else
				stateout <= (others => 'Z');
				cycle <= (others => 'Z');
			end if;
			if reset = '1' then
				sel := 0;
				round := 0;
			end if;
		end if;
	end process;
end main;