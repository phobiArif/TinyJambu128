LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
USE ieee.std_logic_arith.ALL;
USE ieee.std_logic_unsigned.ALL;
USE ieee.numeric_std.all;

ENTITY register_plaintext IS
	PORT(
		m_clock : IN STD_LOGIC;
		reset : IN STD_LOGIC;
		en_M : IN STD_LOGIC;
		m_in: IN STD_LOGIC_VECTOR (119 downto 0);
		M : OUT STD_LOGIC_VECTOR (119 downto 0)
	);
END register_plaintext;

ARCHITECTURE behavioral OF register_plaintext IS
	constant M_AWAL : STD_LOGIC_VECTOR (119 downto 0) := (others => '0');
BEGIN
-- if reset = 0
	process (all)
	begin
		if (m_clock'event and m_clock = '1')then 
			if reset = '0' and en_M = '1' then
				M <= m_in;
			elsif reset = '1' then
				M <= M_AWAL;
			end if;
		end if;
	end process;
end behavioral;
