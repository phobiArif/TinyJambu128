LIBRARY  IEEE; 
USE  IEEE.STD_LOGIC_1164.ALL; 
USE  IEEE.STD_LOGIC_ARITH.ALL;
USE IEEE.STD_LOGIC_UNSIGNED.ALL;

ENTITY tag IS
	PORT(
		clk : IN STD_LOGIC; 
		st  : IN STD_LOGIC_VECTOR(63 DOWNTO 0);
		tag1: OUT STD_LOGIC_VECTOR(63 DOWNTO 0);
		enable : IN STD_LOGIC
	); 
END tag;

architecture tag_arc of tag is
begin
    process(clk, st, enable)
    begin
		if(enable='1') then
			if(clk'event) and (clk = '1') then
				tag1 <= st;
			end if;
		end if;
	end process; 
end tag_arc;