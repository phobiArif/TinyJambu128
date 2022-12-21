library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use ieee.std_logic_unsigned.all;
use ieee.std_logic_arith.all;

--PROGRAM RXD

entity rxd is
	port(
		rx : in std_logic;
		clock : in std_logic;
		en : in std_logic;
		m : buffer std_logic_vector(119 downto 0);
		done : buffer std_logic;
		mlen : out std_logic_vector(6 downto 0)
	);
end rxd;

architecture main of rxd is
	signal len : integer range 0 to 15 := 0;
begin
	process(all)
		variable waktu : integer range 0 to 5208 := 0;
		variable recv : integer range 0 to 149 := 0;
		variable point : integer range 0 to 120 := 0;
	begin
		if en = '1' then
			if clock'event and clock = '1' then
				if waktu < 5208 then
					waktu := waktu + 1;
				else
					waktu := 0;
					recv := recv + 1;
				end if;
				if waktu = 2604 then
					if recv mod 10 = 0 then
						if rx = '0' then
							len <= len + 1;
							done <= '0';
						else
							done <= '1';
						end if;
					elsif recv mod 10 > 0 and recv mod 10 < 9 then
						m(point) <= rx;
						point := point + 1;
					end if;
				end if;
			end if;
		end if;
	end process;
	mlen <= conv_std_logic_vector(len, 7);
end main;