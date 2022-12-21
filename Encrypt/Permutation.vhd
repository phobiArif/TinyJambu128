library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use ieee.std_logic_unsigned.all;

ENTITY Permutation IS
	PORT (
		lim					: IN STD_LOGIC_VECTOR(9 downto 0);
		stateRegister		: IN STD_LOGIC_VECTOR (127 DOWNTO 0);	
		permutationStart	: IN STD_LOGIC;
		permutationDone		: out STD_LOGIC;
		feedback : out std_logic;
		clock : in std_logic
	);
END Permutation;

ARCHITECTURE behavior OF Permutation IS
	signal cycle : std_logic_vector(10 downto 0) := (others => '0');
	signal round : unsigned(6 downto 0);
	signal sel : integer range 0 to 127;
	constant key : std_logic_vector(127 downto 0) := x"73697374656d6469676974616c303133";
BEGIN
	process(all)
	begin
		if clock'event and clock = '1' then
			if permutationStart = '1' then
				if cycle <= lim then
					cycle <= cycle + 1;
					permutationDone <= '0';
				else
					permutationDone <= '1';
				end if;
			else
				cycle <= (others => '0');
			end if;
		end if;
		round <= unsigned(cycle(6 downto 0));
		sel <= to_integer(round);
		if permutationStart = '1' then
			feedback <= key(sel) xor stateRegister(0) xor stateRegister(47) xor (stateRegister(70) nand stateRegister(85)) xor stateRegister(91);
		else
			feedback <= 'Z';
		end if;
	end process;
end behavior;