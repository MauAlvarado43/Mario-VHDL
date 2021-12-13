library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.std_logic_unsigned.all;

entity MARIO is 
	port(					   
		CLK: in STD_LOGIC;
		CLR: in STD_LOGIC;
		JUMP: in STD_LOGIC;
		STAGE: in STD_LOGIC_VECTOR(4 downto 0);
		PLAYER: out STD_LOGIC_VECTOR(4 downto 0):= "00010"
	);	
end MARIO;

architecture MARIO of MARIO is

	type states is (s0, s1, s2, s3, s4);

	signal STATE: states:= s4;
	signal NEXT_STATE: states:= s3;
	
	signal FALL: STD_LOGIC:= '1';
	signal FALL_COUNT: INTEGER range 0 to 4:= 4;
	
	signal TOP_COLLISION: STD_LOGIC:= '0';
	signal BOTTOM_COLLISION: STD_LOGIC:= '0';
	signal PLAYER_POSITION: INTEGER range 0 to 4:= 0;
	
begin	  
	
	process (CLK) begin
		
		if rising_edge(CLK) then	
			
			STATE <= NEXT_STATE;
			
			if BOTTOM_COLLISION = '1' then
			
				FALL_COUNT <= 0;
				FALL <= '0';
				
			end if;
			
			if FALL = '0' and FALL_COUNT < 4 then 
				
				if JUMP = '1' then
					FALL_COUNT <= FALL_COUNT + 1;
				elsif FALL_COUNT > 0 and BOTTOM_COLLISION = '0' then
					FALL_COUNT <= FALL_COUNT - 1;
				end if;
				
			elsif FALL = '1' and FALL_COUNT > 0 and BOTTOM_COLLISION = '0' then 
				
				FALL_COUNT <= FALL_COUNT - 1;
				
			end if;
			
			if FALL_COUNT = 4 then
				FALL <= '1';
			elsif FALL_COUNT = 1 then
				FALL <= '0';
			end if;			
			
		end if;	 
		
	end process;
	
	process (STATE, JUMP, FALL, BOTTOM_COLLISION) begin
		
		if BOTTOM_COLLISION = '1' and (JUMP = '0' or FALL = '1') then 
			
			NEXT_STATE <= STATE;
			
		else
			
			case STATE is
				
				when s0 => 			  
				
					PLAYER <= "00001";
					PLAYER_POSITION <= 0; 
					BOTTOM_COLLISION <= '0';
					TOP_COLLISION <= STAGE(1);
				
					if JUMP = '1' and FALL = '0' and TOP_COLLISION = '0' then
						NEXT_STATE <= s1; 
					else
						NEXT_STATE <= s0;  
					end if;			  
					
				when s1 => 
				
					PLAYER <= "00010";
					PLAYER_POSITION <= 1;
					BOTTOM_COLLISION <= STAGE(0);
					TOP_COLLISION <= STAGE(2);
				
					if JUMP = '1' and FALL = '0' and TOP_COLLISION = '0' then
						NEXT_STATE <= s2;
					else
						NEXT_STATE <= s0;	
					end if;
					
				when s2 =>
				
					if JUMP = '1' and FALL = '0' then
						NEXT_STATE <= s3;
					else
						NEXT_STATE <= s1;
					end if;
					
					PLAYER <= "00100";
					PLAYER_POSITION <= 2;
					BOTTOM_COLLISION <= STAGE(1);
					TOP_COLLISION <= STAGE(3);
					
				when s3 => 	 
				
					if JUMP = '1' and FALL = '0' then
						NEXT_STATE <= s4;
					else
						NEXT_STATE <= s2;
					end if;
					
					PLAYER <= "01000";
					PLAYER_POSITION <= 3;
					BOTTOM_COLLISION <= STAGE(4);
					
				when s4 => 
				
					if JUMP = '1' and FALL = '0' then
						NEXT_STATE <= s4;
					else
						NEXT_STATE <= s3;			   
					end if;	  	
					
					PLAYER <= "10000";
					PLAYER_POSITION <= 4;
					BOTTOM_COLLISION <= STAGE(3);
					TOP_COLLISION <= '0';
					
				when others =>
				
					NEXT_STATE <= s0; 
					PLAYER_POSITION <= 0;
				
			end case; 
			
		end if;
		
	end process;

end MARIO;
