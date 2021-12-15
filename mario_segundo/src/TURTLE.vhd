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
		ENEMY: out STD_LOGIC_VECTOR(HEIGH - 1 downto 0):= "000001";
		TURTLE_POSITION: out INTEGER range 0 to 5
	);	
end TURTLE;

architecture TURTLE of TURTLE is

	-- Estados 
	type states is (s0, s1, s2, s3, s4, s5);
	
	-- Estado actual y siguiente para controlar la maquina
	signal STATE: states:= s5;
	signal NEXT_STATE: states:= s4;
	
	-- Variables que permiten cambiar la direccion del movimiento
	signal WALK_COUNT: INTEGER range 0 to 5:= 5;
	signal WALK_LEFT: STD_LOGIC:= '1';
	
begin
	
	TURTLE_POSITION <= WALK_COUNT;

	process (CLK) begin
		
		if rising_edge(CLK) then
			
			-- Maquina de estados en funcionamiento
			STATE <= NEXT_STATE;
			
			-- Si camina hacia la derecha, entonces aumentamos el contador
			if WALK_LEFT = '0' and WALK_COUNT < 5 then 
				WALK_COUNT <= WALK_COUNT + 1;								   
			
			-- Si camina hacia la izquierda, entonces decrementamos el contador
			elsif WALK_LEFT = '1' and WALK_COUNT > 0 then 
				WALK_COUNT <= WALK_COUNT - 1;
			end if;															   
			
			-- Cuando nos encontramos en el borde izquierdo, entonces cambiamos de direccion a la derecha
			if WALK_COUNT = 4 then
				WALK_LEFT <= '1';																   
				
			-- Cuando nos encontramos en el borde derecho, entonces cambiamos de direccion a la izquierda
			elsif WALK_COUNT = 1 then
				WALK_LEFT <= '0';
			end if;	
			
		end if;	 
		
	end process;
	
	process (STATE, WALK_LEFT) begin
	
		case STATE is
			
			when s0 =>
			
				-- Para el estado 0, si camina hacia la izquierda asignamos s0 y si va hacia la derecha s1
				if WALK_LEFT = '1' then
					NEXT_STATE <= s0;
				else
					NEXT_STATE <= s1;
				end if;
			
				ENEMY <= "100000";
				
			when s1 => 
			
				-- Para el estado 1, si camina hacia la izquierda asignamos s0 y si va hacia la derecha s2
				if WALK_LEFT = '1' then
					NEXT_STATE <= s0;
				else
					NEXT_STATE <= s2;
				end if;
			
				ENEMY <= "010000";
				
			when s2 =>
			
				-- Para el estado 2, si camina hacia la izquierda asignamos s1 y si va hacia la derecha s3
				if WALK_LEFT = '1' then
					NEXT_STATE <= s1;
				else
					NEXT_STATE <= s3;
				end if;
			
				ENEMY <= "001000";
				
			when s3 => 	 
			
				-- Para el estado 3, si camina hacia la izquierda asignamos s2 y si va hacia la derecha s4
				if WALK_LEFT = '1' then
					NEXT_STATE <= s2;
				else
					NEXT_STATE <= s4;
				end if;
			
				ENEMY <= "000100";
				
			when s4 => 
			
				-- Para el estado 4, si camina hacia la izquierda asignamos s3 y si va hacia la derecha s5
				if WALK_LEFT = '1' then
					NEXT_STATE <= s3;
				else
					NEXT_STATE <= s5;
				end if;
			
				ENEMY <= "000010";
				
			when s5 => 
			
				-- Para el estado 5, si camina hacia la izquierda asignamos s4 y si va hacia la derecha s5
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
