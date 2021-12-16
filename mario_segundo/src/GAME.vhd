library IEEE;					
library work;
use IEEE.std_logic_1164.all;
use IEEE.std_logic_unsigned.all;
use work.pkg.all;

entity GAME is
	port(
		CLK: in STD_LOGIC;
		UP: in STD_LOGIC;
		DOWN: in STD_LOGIC;
		LEFT: in STD_LOGIC;
		RIGHT: in STD_LOGIC;
		COINS: out INTEGER range 0 to 2;
		GAME_OVER: out STD_LOGIC:= '0';
		WIN: out STD_LOGIC:= '0';
		LEDS_OUT: out STAGE_BLOCK
	);
end GAME;

architecture GAME of GAME is  

	component STAGE is
		port(  
			INDEX: in INTEGER range 0 to 9;
			BUS_DATA: out STAGE_BLOCK
		);
	end component;
	
	component MARIO is 
		port(					   
			CLK: in STD_LOGIC;
			CLR: in STD_LOGIC;
			JUMP: in STD_LOGIC;	
			ALIVE: in STD_LOGIC;
			STAGE: in STD_LOGIC_VECTOR(4 downto 0);			 
			TUBE: in STD_LOGIC_VECTOR(1 downto 0);
			VERTICAL_POSITION: out INTEGER range 0 to 4:= 4;
			PLAYER: out STD_LOGIC_VECTOR(4 downto 0)
		);
	end component;
	
	component TURTLE is  
		port(					   
			CLK: in STD_LOGIC;
			CLR: in STD_LOGIC;						 
			ALIVE: in STD_LOGIC;
			ENEMY: out STD_LOGIC_VECTOR(4 downto 0);
			TURTLE_POSITION: out INTEGER range 6 to 11
		);	
	end component;
	
	constant ZERO: STD_LOGIC:= '0';	 
	
	signal CURRENT_STAGE_BLOCK: STAGE_BLOCK;
	
	signal CURRENT_CLR: STD_LOGIC:= '0'; 
	
	-- Variables de Mario
	
	signal CURRENT_MARIO: STD_LOGIC_VECTOR(4 downto 0);
	signal MARIO_BLOCK_POSITION: STD_LOGIC_VECTOR(4 downto 0):= "00001";
	signal MARIO_POSITION: INTEGER range 0 to 14:= 0;
	signal MARIO_V_POSITION: INTEGER range -1 to 4:= 4;
	signal MARIO_LEFT_COLLISION: STD_LOGIC:= '0';
	signal MARIO_RIGHT_COLLISION: STD_LOGIC:= '0'; 
	signal MARIO_ALIVE: STD_LOGIC:= '1';
	
	-- Variables del escenario
	
	signal DOWN_VIEW: INTEGER range 0 to 9:= 0;
	signal CURRENT_OUT: STAGE_BLOCK;	 
	
	-- Variables de las monedas
	
	signal COIN_COUNT: INTEGER range 0 to 3:= 0;  
	
	signal COIN1_PICKED: STD_LOGIC:= '0';
	signal COIN1: STD_LOGIC_VECTOR(4 downto 0):= "01000";
	signal COIN1_POSITION: INTEGER range 0 to 14:= 1;
	signal COIN1_V_POSITION: INTEGER range 0 to 4:= 3;
	
	signal COIN2_PICKED: STD_LOGIC:= '0';
	signal COIN2: STD_LOGIC_VECTOR(4 downto 0):= "10000";
	signal COIN2_POSITION: INTEGER range 0 to 14:= 12;
	signal COIN2_V_POSITION: INTEGER range 0 to 4:= 4;
	
	-- Variables de la tortuga 
	
	signal TURTLE_POSITION: INTEGER range 6 to 11;
	signal CURRENT_TURTLE: STD_LOGIC_VECTOR(4 downto 0);
	signal TURTLE_ALIVE: STD_LOGIC:= '1';
	
	-- Variable de colision vertical entre tortuga y mario
	
	signal TURTLE_MARIO_V_COLLISION: STD_LOGIC:= '0';	
	
	-- Variable que identifica la direccion del tubo
	
	signal CURRENT_TUBE: STD_LOGIC_VECTOR(1 downto 0):= "00";
	
begin 	 
	
	-- Salidas
	MARIO_BLOCK_POSITION <= CURRENT_STAGE_BLOCK(MARIO_POSITION - DOWN_VIEW); 
	LEDS_OUT <= CURRENT_OUT; 
	COINS <= COIN_COUNT;
	
	-- Escenario
	stage_gen: STAGE port map(
		INDEX => DOWN_VIEW,
		BUS_DATA => CURRENT_STAGE_BLOCK
	);
	
	-- Mario
	mario_gen: MARIO port map(	
		CLK => CLK,
		CLR => ZERO,
		JUMP => UP,	   
		ALIVE => MARIO_ALIVE,
		STAGE => MARIO_BLOCK_POSITION, 
		TUBE => CURRENT_TUBE,
		VERTICAL_POSITION => MARIO_V_POSITION,
		PLAYER => CURRENT_MARIO
	);
	
	-- Tortuga
	turtle_gen: TURTLE port map(
		CLK => CLK,
		CLR => ZERO,
		ALIVE => TURTLE_ALIVE,
		ENEMY => CURRENT_TURTLE,
		TURTLE_POSITION => TURTLE_POSITION
	);
	
	process (CLK) begin
		
		if rising_edge(CLK) then 
			
			if MARIO_ALIVE = '1' then	  
				
				-- Movimiento horizontal de Mario
				if RIGHT = '1' and LEFT = '0' and MARIO_POSITION < 14 and MARIO_RIGHT_COLLISION = '0' then
					MARIO_POSITION <= MARIO_POSITION + 1;	
					
				elsif RIGHT = '0' and LEFT = '1' and MARIO_POSITION > 0 and MARIO_LEFT_COLLISION = '0' then
					MARIO_POSITION <= MARIO_POSITION - 1;
				end if;	 
				
				-- Movimiento de la camara
				if MARIO_POSITION - DOWN_VIEW > 3 and MARIO_POSITION < 13 then
					DOWN_VIEW <= DOWN_VIEW + 1;	
					
				elsif MARIO_POSITION - DOWN_VIEW < 3 and MARIO_POSITION > 2 then
					DOWN_VIEW <= DOWN_VIEW - 1;
				end if;
				
				-- Teletransporte del tubo grande al pequegno
				if MARIO_POSITION = 5 and DOWN = '1' and MARIO_V_POSITION = 3 then	
					MARIO_POSITION <= 12;
					CURRENT_TUBE <= "10";
					DOWN_VIEW <= 9;
					
				-- Teletransporte del tubo pequegno al grande
				elsif MARIO_POSITION = 12 and DOWN = '1' and MARIO_V_POSITION = 2 then 
					MARIO_POSITION <= 5;
					CURRENT_TUBE <= "01";
					DOWN_VIEW <= 2;	
				
				-- Cuando se realiza el teletransporte, reseteamos la direccion
				else	 
					CURRENT_TUBE <= "00";
					
				end if;
				
				-- Colisiones con las monedas
				
				if MARIO_POSITION = COIN1_POSITION and MARIO_V_POSITION = COIN1_V_POSITION then
					COIN1 <= "00000";
					COIN1_PICKED <= '1';
					COIN_COUNT <= COIN_COUNT + 1;
				end if;	
				
				if MARIO_POSITION = COIN2_POSITION and MARIO_V_POSITION = COIN2_V_POSITION then
					COIN2 <= "00000";
					COIN2_PICKED <= '1';
					COIN_COUNT <= COIN_COUNT + 1;
				end if;
				
			end if;
			
		end if;
			
	end process;  
	
	process (MARIO_POSITION, MARIO_V_POSITION, CURRENT_STAGE_BLOCK, CLK) begin
		
		-- Colisiones horizontales de Mario	
				
		if MARIO_POSITION > 0 then		
			MARIO_LEFT_COLLISION <= CURRENT_STAGE_BLOCK(MARIO_POSITION - DOWN_VIEW - 1)(MARIO_V_POSITION);
		else
			MARIO_LEFT_COLLISION <= '0';
		end if;
		
		if MARIO_POSITION < 14 then	 
			MARIO_RIGHT_COLLISION <= CURRENT_STAGE_BLOCK(MARIO_POSITION - DOWN_VIEW + 1)(MARIO_V_POSITION);
		else
			MARIO_RIGHT_COLLISION <= '0';
		end if;
		
	end process;
	
	process (MARIO_POSITION, MARIO_V_POSITION, TURTLE_POSITION) begin 
		
		-- Si Mario cae al vacio, muere
		if MARIO_V_POSITION = 0 then
			MARIO_ALIVE <= '0';
		end if;						   
		
		-- Si Mario esta encima de una tortuga, entonces se guarda que hubo colision para que a la hora de 
		-- caer, sepamos que la mato
		if MARIO_POSITION = TURTLE_POSITION and MARIO_V_POSITION = 2 then
			TURTLE_MARIO_V_COLLISION <= '1';
		else
			TURTLE_MARIO_V_COLLISION <= '0';
		end if;
		
		-- Si hay colision exacta con la tortuga
		if MARIO_POSITION = TURTLE_POSITION and MARIO_V_POSITION = 1 then
			
			-- SI hubo colision, la tortuga muere
			if TURTLE_MARIO_V_COLLISION = '1' then 
				TURTLE_ALIVE <= '0';	  
				
			-- Caso contrario, muere Mario
			else  
				MARIO_ALIVE <= '0';	
			end if;

		end if;	
	
	end process;
	
	process (MARIO_POSITION, MARIO_V_POSITION, TURTLE_POSITION, CURRENT_STAGE_BLOCK, DOWN_VIEW, COIN1, COIN2) begin	
		
		-- Render de Mario y el escenario
		CURRENT_OUT <= CURRENT_STAGE_BLOCK;
		CURRENT_OUT(MARIO_POSITION - DOWN_VIEW) <= CURRENT_MARIO or CURRENT_STAGE_BLOCK(MARIO_POSITION - DOWN_VIEW);
		
		-- Si la tortuga entra a la ventana
		if DOWN_VIEW <= TURTLE_POSITION and TURTLE_POSITION <= DOWN_VIEW + 5 then
			
			-- Si Mario esta en la misma posicion horizontal que la tortuga, renderizamos todo
			if MARIO_POSITION = TURTLE_POSITION then
				CURRENT_OUT(MARIO_POSITION - DOWN_VIEW) <= CURRENT_MARIO or CURRENT_TURTLE or CURRENT_STAGE_BLOCK(MARIO_POSITION - DOWN_VIEW);	
			
			-- Si no, renderizamos por separado
			else
				CURRENT_OUT(TURTLE_POSITION - DOWN_VIEW) <= CURRENT_TURTLE or CURRENT_STAGE_BLOCK(TURTLE_POSITION - DOWN_VIEW);
			end if;
		
		end if;
		
		-- Si Mario esta en la misma posicion horizontal que la primer moneda, renderizamos ambas entidades
		if MARIO_POSITION = COIN1_POSITION then
			CURRENT_OUT(MARIO_POSITION - DOWN_VIEW) <= CURRENT_MARIO or CURRENT_STAGE_BLOCK(MARIO_POSITION - DOWN_VIEW) or COIN1;
		
		-- Caso contrario, renderizamos por separado
		elsif DOWN_VIEW <= COIN1_POSITION and COIN1_POSITION <= DOWN_VIEW + 5 then
			CURRENT_OUT(COIN1_POSITION - DOWN_VIEW) <= COIN1 or CURRENT_STAGE_BLOCK(COIN1_POSITION - DOWN_VIEW);  	
		end if;	
		
		-- Lo mismo para la moneda 2
		if MARIO_POSITION = COIN2_POSITION then
			CURRENT_OUT(MARIO_POSITION - DOWN_VIEW) <= CURRENT_MARIO or CURRENT_STAGE_BLOCK(MARIO_POSITION - DOWN_VIEW) or COIN2;
		
		elsif DOWN_VIEW <= COIN2_POSITION and COIN2_POSITION <= DOWN_VIEW + 5 then
			CURRENT_OUT(COIN2_POSITION - DOWN_VIEW) <= COIN2 or CURRENT_STAGE_BLOCK(COIN2_POSITION - DOWN_VIEW);  	
		end if;
				
	end process;  
	
	process (MARIO_ALIVE, MARIO_POSITION) begin
		
		-- Si Mario muere, entonces se termina el juego
		if MARIO_ALIVE = '0' then
			GAME_OVER <= '1';
		end if;										   
		
		-- Si Mario llega al final, entonces gana
		if MARIO_POSITION = 14 then
			WIN <= '1';
			GAME_OVER <= '1';
			MARIO_ALIVE <= '0';
		end if;
		
	end process;

end GAME;