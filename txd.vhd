library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use ieee.std_logic_unsigned.all;

--PROGRAM TXD

entity txd is
	port(
		creg : in std_logic_vector(119 downto 0);
		mlen : in std_logic_vector(6 downto 0);
		clock : in std_logic;
		tx : out std_logic;
		en : in std_logic;
		done : out std_logic
	);
end txd;

architecture main of txd is
	signal lim : integer range 0 to 119;
begin
	lim <= to_integer(unsigned(mlen));
	process(all)
		variable waktu : integer range 0 to 5208 := 0;
		variable sel : integer range 0 to 120 := 0;
		variable subc : integer range 0 to 9 := 0;
	begin
		if clock'event and clock = '1' then		
			if en = '1' then
				if sel < lim then
					done <= '0';
					if waktu < 5208 then
						waktu := waktu + 1;
					else
						subc := subc + 1;
						waktu := 0;
						if subc > 0 and subc < 9 then
							sel := sel + 1;
						elsif subc = 9 then
							subc := 0;
						end if;
					end if;
					if waktu = 2604 then
						if subc = 0 then
							tx <= '0';
						elsif subc = 9 then
							tx <= '1';
						else
							tx <= creg(sel);
						end if;
					end if;
				else
					done <= '1';
					tx <= '1';
				end if;
			else
				tx <= '1';
			end if;
		end if;
	end process;
end main;