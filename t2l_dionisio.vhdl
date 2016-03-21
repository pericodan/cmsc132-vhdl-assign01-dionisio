-- Library Statements
library IEEE; use IEEE.std_logic_1164.all;

-- Entity Definition
entity alarm is
	port (
	 alarm_s: out std_logic;
	 in_b: in std_logic_vector(2 downto 0);
	 out_b: in std_logic_vector(2 downto 0)); 	  			
end entity alarm;

-- Architecture Definition
architecture archi of alarm is
begin
	process (in_b(2), in_b(1), in_b(0), out_b(2), out_b(1), out_b(0)) is -- activate when any input changes
	begin
		if( (in_b(2)='1' or in_b(1)='1' or in_b(0)='1') and (out_b(2)='1' or out_b(1)='1' or out_b(0)='1') )
			then alarm_s <= '1';
		else
			alarm_s <= '0';
		end if;
	end process;
end architecture archi;
