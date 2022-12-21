library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use ieee.std_logic_unsigned.all;
use ieee.std_logic_arith.all;

--PROGRAM State Register

entity sreg is
	port(
		en : in std_logic;
		statein : in std_logic_vector(127 downto 0);
		stateout : out std_logic_vector(127 downto 0);
		sh : in std_logic;
		clock : in std_logic;
		input : in std_logic
	);
end sreg;

architecture main of sreg is
	signal state : std_logic_vector(127 downto 0) := (others => '0');
begin
	stateout <= state;
	process(all)
	begin
		if clock'event and clock = '1' then
			if en = '1' then
				if sh = '1' then
					for i in 1 to 127 loop
						state(i-1) <= state(i);
					end loop;
					state(127) <= input;
				else
					state <= statein;
				end if;
			end if;
		end if;
	end process;
end main;