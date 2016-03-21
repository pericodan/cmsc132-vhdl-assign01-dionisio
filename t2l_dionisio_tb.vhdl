-- Libray Statements
library IEEE; use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;

-- Entity Definition
entity alarm_tb is -- constants are defined here
	constant DELAY: time := 10 ns; -- delay value in testing
end entity alarm_tb;

architecture tb of alarm_tb is
	signal alarm_s: std_logic; 
	signal in_b: std_logic_vector(2 downto 0);
	signal out_b: std_logic_vector(2 downto 0);
	
	--Component declaration
	component alarm is
		port(alarm_s: out std_logic;
		in_b: in std_logic_vector(2 downto 0); 
		out_b: in std_logic_vector(2 downto 0)); 
	end component alarm;

begin -- begin main body of the tb architecture
	-- instantiate the unit under test
	UUT: component alarm port map(alarm_s, in_b, out_b);
	
	--main process: generate test vectors and check results
	main: process is
		variable temp: unsigned(5 downto 0); 
		variable expected_alarm_s: std_logic;
		variable error_count: integer := 0; 

	begin
		report "Start simulation.";
		
		
		for count in 0 to 63 loop
			temp := TO_UNSIGNED(count,6);
			in_b(0) <= std_logic(temp(0));
			in_b(1) <= std_logic(temp(1));
			in_b(2) <= std_logic(temp(2));
			out_b(0) <= std_logic(temp(3));
			out_b(1) <= std_logic(temp(4));
			out_b(2) <= std_logic(temp(5));
			
			-- compute expected values
			if((count>7) and ((count mod 8) /= 0)) then
				expected_alarm_s := '1';
			else
				expected_alarm_s := '0';
			end if;	
			
			wait for DELAY; -- wait, and then compare with UUT outputs

			-- check if output of circuit is the same as the expected value
			assert ((expected_alarm_s = alarm_s))
				report "ERROR: Expected alarm_s " &
					std_logic'image(expected_alarm_s) &
					" at time " & time'image(now);

			-- increment number of errors
			if(expected_alarm_s/=alarm_s) then
				error_count := error_count + 1;
			end if;
		end loop;

		wait for DELAY;

		-- report errors
		assert (error_count=0)
			report "ERROR: There were " &
				integer'image(error_count) & " errors!";

		-- there are no erros
		if(error_count = 0) then
			report "Simulation completed with NO errors.";
		end if;

		wait; -- terminate the simulation
	end process;
end architecture tb;
