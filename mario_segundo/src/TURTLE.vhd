library IEEE;					  
use IEEE.std_logic_1164.all;
use IEEE.std_logic_unsigned.all;  

entity TURTLE is  
	generic( 
		HEIGH: INTEGER:= 6	
	);
	port(					   
		CLK: in STD_LOGIC;
		CLR: in STD_LOGIC;
		ENEMY: out STD_LOGIC_VECTOR(HEIGH - 1 downto 0):= "000001"
	);	
end TURTLE;

architecture TURTLE of TURTLE is

	type states is (s0, s1, s2, s3, s4, s5);

	signal STATE: states:= s5;
	signal NEXT_STATE: states:= s4;
	
	signal WALK_COUNT: INTEGER range 0 to 5:= 5;
	signal WALK_LEFT: STD_LOGIC:= '1';
	
begin		

	process (CLK) begin
		
		if rising_edge(CLK) then
		
			STATE <= NEXT_STATE;
			
			if WALK_LEFT = '0' and WALK_COUNT < 5 then 
					WALK_COUNT <= WALK_COUNT + 1;
			elsif WALK_LEFT = '1' and WALK_COUNT > 0 then 
				WALK_COUNT <= WALK_COUNT - 1;
				
			end if;
			
			if WALK_COUNT = 4 then
				WALK_LEFT <= '1';
			elsif WALK_COUNT = 1 then
				WALK_LEFT <= '0';
			end if;	
			
		end if;	 
		
	end process;
	
	process (STATE, WALK_LEFT) begin
	
		case STATE is
			when s0 =>
			
				if WALK_LEFT = '1' then
					NEXT_STATE <= s0;
				else
					NEXT_STATE <= s1;
				end if;
			
				ENEMY <= "100000";
				
			when s1 => 
			
				if WALK_LEFT = '1' then
					NEXT_STATE <= s0;
				else
					NEXT_STATE <= s2;
				end if;
			
				ENEMY <= "010000";
				
			when s2 =>
			
				if WALK_LEFT = '1' then
					NEXT_STATE <= s1;
				else
					NEXT_STATE <= s3;
				end if;
			
				ENEMY <= "001000";
				
			when s3 => 	 
			
				if WALK_LEFT = '1' then
					NEXT_STATE <= s2;
				else
					NEXT_STATE <= s4;
				end if;
			
				ENEMY <= "000100";
				
			when s4 => 
			
				if WALK_LEFT = '1' then
					NEXT_STATE <= s3;
				else
					NEXT_STATE <= s5;
				end if;
			
				ENEMY <= "000010";
				
			when s5 => 
			
				if WALK_LEFT = '1' then
					NEXT_STATE <= s4;
				else
					NEXT_STATE <= s5;
				end if;
			
				ENEMY <= "000001";
				
			when others =>
				NEXT_STATE <= s0; 	 
			
		end case;
		
	end process;

end TURTLE;
