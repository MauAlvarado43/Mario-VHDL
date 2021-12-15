library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.std_logic_unsigned.all;

entity MARIO is 
	port(					   
		CLK: in STD_LOGIC;
		CLR: in STD_LOGIC;
		JUMP: in STD_LOGIC;
		ALIVE: in STD_LOGIC;
		STAGE: in STD_LOGIC_VECTOR(4 downto 0);
		VERTICAL_POSITION: out INTEGER range 0 to 4:= 4;
		PLAYER: out STD_LOGIC_VECTOR(4 downto 0):= "00010"
	);	
end MARIO;

architecture MARIO of MARIO is

	-- Estados
	type states is (s0, s1, s2, s3, s4);
	
	-- Estado actual y siguiente para controlar la maquina
	signal STATE: states:= s4;
	signal NEXT_STATE: states:= s4;
	
	-- Variables que ayudan a determinar si Mario cae o no
	signal FALL: STD_LOGIC:= '1';
	signal FALL_COUNT: INTEGER range 0 to 4:= 3;
	
	-- Colisiones con bloques verticales
	signal TOP_COLLISION: STD_LOGIC:= '0';
	signal BOTTOM_COLLISION: STD_LOGIC:= '0';
	
	-- Posicion vertical de Mario
	signal PLAYER_POSITION: INTEGER range 0 to 4:= 4;
	
	signal t: STD_LOGIC:= '0';
	
begin	
	
	VERTICAL_POSITION <= PLAYER_POSITION;
	
	process (CLK, CLR) begin
		
		--if CLR = '1' then  
			
			--FALL <= '1';
			--FALL_COUNT <= 3;
			--TOP_COLLISION <= '0'; 
			--BOTTOM_COLLISION <= '0';
			--STATE <= s4;
			
		--if ALIVE = '0' then
			
			--PLAYER <= "00000";
			
		--elsif
		if rising_edge(CLK) then	
			
			-- Maquina de estados en funcionamiento
			STATE <= NEXT_STATE;  
			
			-- Si hay colision debajo de Mario, entonces deja de caer
			if BOTTOM_COLLISION = '1' then
				FALL_COUNT <= 0;
			end if;	 
			
			-- Si no cae Mario, entonces puede saltar
			if FALL = '0' and FALL_COUNT < 4 then 	 
				
				-- Si salta, entonces aumentamos el contador auxiliar de gravedad	
				if JUMP = '1' and TOP_COLLISION = '0' then
					FALL_COUNT <= FALL_COUNT + 1;
					
				-- Si no salta, entonces cae
				elsif FALL_COUNT > 0 and BOTTOM_COLLISION = '0' then
					FALL_COUNT <= FALL_COUNT - 1;
				end if;
				
			-- Si esta cayendo, entonces el contador disminuye  
			elsif FALL = '1' and FALL_COUNT > 0 and BOTTOM_COLLISION = '0' then 
				FALL_COUNT <= FALL_COUNT - 1;
				
			end if;
					
		end if;	 
		
	end process;
	
	process (STATE, BOTTOM_COLLISION, TOP_COLLISION, STAGE) begin
	
		
			case STATE is
				
				when s0 => 			  
				
					BOTTOM_COLLISION <= '0';
					TOP_COLLISION <= STAGE(1);
					
				when s1 => 
				
					BOTTOM_COLLISION <= STAGE(0);
					TOP_COLLISION <= STAGE(2);

				when s2 =>	
				
					BOTTOM_COLLISION <= STAGE(1);
					TOP_COLLISION <= STAGE(3);
					
				when s3 =>
				
					BOTTOM_COLLISION <= STAGE(2);
					TOP_COLLISION <= STAGE(4);

				when s4 => 
				
					BOTTOM_COLLISION <= STAGE(3);
					TOP_COLLISION <= '0';
				
		
				when others =>
				
					TOP_COLLISION <= '0';
					BOTTOM_COLLISION <= '0';
				
			end case; 
		
	end process;
	
	process (CLR, STATE, JUMP, FALL, BOTTOM_COLLISION, TOP_COLLISION, STAGE, FALL_COUNT) begin
		
		--if CLR = '1' then
			
			--PLAYER_POSITION <= 4;
			--NEXT_STATE <= s4;	
		
		-- elsif
			
		-- Cuando el contador auxiliar vale 4, entonces Mario empieza a caer
		if FALL_COUNT = 4 then
			FALL <= '1';													
		
		-- Si el contador es igual a 1, entonces Mario deja de caer
		elsif FALL_COUNT = 0 then
			FALL <= '0';
		end if;	
		
		-- Si hay colision debajo y Mario no salta o cae, entonces se mantiene en su posicion actual
		if BOTTOM_COLLISION = '1' and (JUMP = '0' or FALL = '1') then 
			NEXT_STATE <= STATE; 
			FALL <= '0';
			
		-- Si hay colision encima y no hay colision debajo y Mario salta, entonces comienza a caer
		elsif TOP_COLLISION = '1' and JUMP = '1' and BOTTOM_COLLISION = '0' then
			FALL <= '1';
			NEXT_STATE <= STATE;
			
		-- Si hay colision encima y hay colision, entonces Mario se mantiene en su posicion y no cae
		elsif TOP_COLLISION = '1' and JUMP = '1' and BOTTOM_COLLISION = '1'	then
			FALL <= '0';
			NEXT_STATE <= STATE;
		else
			
			case STATE is
				
				when s0 => 			  
				
					-- Para el estado 0, no hay colision debajo y la colision de arriba depende del escenario
					PLAYER <= "00001";
					PLAYER_POSITION <= 0; 

					
					-- Si Mario salta y no esta cayendo y no hay ningun bloque arriba, entonces sube de posicion
					if JUMP = '1' and FALL = '0' and TOP_COLLISION = '0' then
						NEXT_STATE <= s1; 
					else
						NEXT_STATE <= s0;  
					end if;			  
					
				when s1 => 
				
					-- Para el estado 1, la colision de abajo y la colision de arriba depende del escenario
					PLAYER <= "00010";
					PLAYER_POSITION <= 1;

					
					-- Si Mario salta y no esta cayendo y no hay ningun bloque arriba, entonces sube de posicion
					if JUMP = '1' and FALL = '0' and TOP_COLLISION = '0' then
						NEXT_STATE <= s2;
					else
						NEXT_STATE <= s0;	
					end if;
					
				when s2 =>	
				
					-- Para el estado 2, la colision de abajo y la colision de arriba depende del escenario
					PLAYER <= "00100";
					PLAYER_POSITION <= 2;

					
					-- Si Mario salta y no esta cayendo y no hay ningun bloque arriba, entonces sube de posicion
					if JUMP = '1' and FALL = '0' and TOP_COLLISION = '0' then
						NEXT_STATE <= s3;
					else
						NEXT_STATE <= s1;
					end if;
					
				when s3 =>
				
					-- Para el estado 3, la colision de abajo y la colision de arriba depende del escenario
					PLAYER <= "01000";
					PLAYER_POSITION <= 3;

					
					-- Si Mario salta y no esta cayendo y no hay ningun bloque arriba, entonces sube de posicion
					if JUMP = '1' and FALL = '0' and TOP_COLLISION = '0' then
						NEXT_STATE <= s4;
					else
						NEXT_STATE <= s2;
					end if;

				when s4 => 
				
				
					-- Para el estado 4, la colision de abajo y la colision de arriba depende del escenario
					PLAYER <= "10000";
					PLAYER_POSITION <= 4;

				
					-- Si Mario salta y no esta cayendo y no hay ningun bloque arriba, entonces sube de posicion
					if JUMP = '1' and FALL = '0' and TOP_COLLISION = '0' then
						NEXT_STATE <= s4;
					else
						NEXT_STATE <= s3;			   
					end if;	  	
		
				when others =>
				
					NEXT_STATE <= s4; 
					PLAYER_POSITION <= 4;
				
			end case; 
			
		end if;
		
	end process;

end MARIO;