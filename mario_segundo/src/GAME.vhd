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
		GAME_OVER: out STD_LOGIC:= '0';
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
			VERTICAL_POSITION: out INTEGER range 0 to 4:= 4;
			PLAYER: out STD_LOGIC_VECTOR(4 downto 0)
		);
	end component;
	
	constant ZERO: STD_LOGIC:= '0';	 
	
	signal CURRENT_STAGE_BLOCK: STAGE_BLOCK;
	
	signal CURRENT_CLR: STD_LOGIC:= '0'; 
	
	-- Variables de Mario
	
	signal CURRENT_MARIO: STD_LOGIC_VECTOR(4 downto 0);
	signal MARIO_BLOCK_POSITION: STD_LOGIC_VECTOR(4 downto 0):= "00001";
	signal MARIO_POSITION: INTEGER range 0 to 15:= 0;
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
	signal COIN1_POSITION: INTEGER range 0 to 15:= 1;
	signal COIN1_V_POSITION: INTEGER range 0 to 4:= 3;
	
	signal COIN2_PICKED: STD_LOGIC:= '0';
	signal COIN2: STD_LOGIC_VECTOR(4 downto 0):= "10000";  
	signal COIN2_POSITION: INTEGER range 0 to 15:= 8;
	signal COIN2_V_POSITION: INTEGER range 0 to 4:= 4;
	
	signal COIN3_PICKED: STD_LOGIC:= '0';
	signal COIN3: STD_LOGIC_VECTOR(4 downto 0):= "01000";
	signal COIN3_POSITION: INTEGER range 0 to 15:= 12;
	signal COIN3_V_POSITION: INTEGER range 0 to 4:= 3;
	
	-- Variables de la tortuga
	signal TURTLE_POSITION: INTEGER range 0 to 5;
	
	-- Variables de testing
	
	signal x: INTEGER;
	signal y: INTEGER;
	
	signal t: STD_LOGIC:= '0';
	signal tt: STD_LOGIC_VECTOR(4 downto 0):= "00000";
	
begin 	 
	
	MARIO_BLOCK_POSITION <= CURRENT_STAGE_BLOCK(MARIO_POSITION - DOWN_VIEW); 
	LEDS_OUT <= CURRENT_OUT;  
	
	stage_gen: STAGE port map(
		INDEX => DOWN_VIEW,
		BUS_DATA => CURRENT_STAGE_BLOCK
	);
	
	mario_gen: MARIO port map(	
		CLK => CLK,
		CLR => ZERO,
		JUMP => UP,	   
		ALIVE => MARIO_ALIVE,
		STAGE => MARIO_BLOCK_POSITION,
		VERTICAL_POSITION => MARIO_V_POSITION,
		PLAYER => CURRENT_MARIO
	);
	
	process (CLK) begin
		
		if rising_edge(CLK) then 
			
			if MARIO_ALIVE = '1' then	  
				
				-- Movimiento horizontal de Mario
	
				if RIGHT = '1' and LEFT = '0' and MARIO_POSITION < 15 and MARIO_RIGHT_COLLISION = '0' then
					MARIO_POSITION <= MARIO_POSITION + 1;	
				elsif RIGHT = '0' and LEFT = '1' and MARIO_POSITION > 0 and MARIO_LEFT_COLLISION = '0' then
					MARIO_POSITION <= MARIO_POSITION - 1;
				end if;	 
				
				if MARIO_POSITION - DOWN_VIEW > 3 and MARIO_POSITION < 13 then
					DOWN_VIEW <= DOWN_VIEW + 1;	 
				elsif MARIO_POSITION - DOWN_VIEW < 3 and MARIO_POSITION > 2 then
					DOWN_VIEW <= DOWN_VIEW - 1;
				end if;
				
				-- Colisiones horizontales de Mario	
				
				if MARIO_POSITION > 0 then		
					MARIO_LEFT_COLLISION <= CURRENT_STAGE_BLOCK(MARIO_POSITION - 1)(MARIO_V_POSITION);
				else
					MARIO_LEFT_COLLISION <= '0';
				end if;
				
				if MARIO_POSITION < 15 then	 
					MARIO_RIGHT_COLLISION <= CURRENT_STAGE_BLOCK(MARIO_POSITION + 1)(MARIO_V_POSITION);
				else
					MARIO_RIGHT_COLLISION <= '0';
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
				
				if MARIO_POSITION = COIN3_POSITION and MARIO_V_POSITION = COIN3_V_POSITION then
					COIN3 <= "00000";
					COIN3_PICKED <= '1';
					COIN_COUNT <= COIN_COUNT + 1;
				end if;
				
			end if;
			
		end if;
			
	end process;
	
	process (MARIO_POSITION, MARIO_V_POSITION, DOWN_VIEW) begin	
		
		if MARIO_V_POSITION = 0 then
			MARIO_ALIVE <= '0';
		end if;
		
		CURRENT_OUT <= CURRENT_STAGE_BLOCK;
		CURRENT_OUT(MARIO_POSITION - DOWN_VIEW) <= CURRENT_MARIO or CURRENT_STAGE_BLOCK(MARIO_POSITION - DOWN_VIEW);
		
		if MARIO_POSITION = COIN1_POSITION then
			CURRENT_OUT(MARIO_POSITION - DOWN_VIEW) <= CURRENT_MARIO or CURRENT_STAGE_BLOCK(MARIO_POSITION - DOWN_VIEW) or COIN1;
			tt <= CURRENT_MARIO or CURRENT_STAGE_BLOCK(MARIO_POSITION - DOWN_VIEW) or COIN1;
		elsif DOWN_VIEW < COIN1_POSITION and COIN1_POSITION < DOWN_VIEW + 6 then
			CURRENT_OUT(COIN1_POSITION - DOWN_VIEW) <= COIN1 or CURRENT_STAGE_BLOCK(COIN1_POSITION - DOWN_VIEW);  	
		end if;	
		
		if MARIO_POSITION = COIN2_POSITION then
			CURRENT_OUT(MARIO_POSITION - DOWN_VIEW) <= CURRENT_MARIO or CURRENT_STAGE_BLOCK(MARIO_POSITION - DOWN_VIEW) or COIN2;
		elsif DOWN_VIEW < COIN2_POSITION and COIN2_POSITION < DOWN_VIEW + 6 then
			CURRENT_OUT(COIN2_POSITION - DOWN_VIEW) <= COIN2 or CURRENT_STAGE_BLOCK(COIN2_POSITION - DOWN_VIEW);  	
		end if;
		
		if MARIO_POSITION = COIN3_POSITION then
			CURRENT_OUT(MARIO_POSITION - DOWN_VIEW) <= CURRENT_MARIO or CURRENT_STAGE_BLOCK(MARIO_POSITION - DOWN_VIEW) or COIN3;
		elsif DOWN_VIEW < COIN3_POSITION and COIN3_POSITION < DOWN_VIEW + 6 then
			CURRENT_OUT(COIN3_POSITION - DOWN_VIEW) <= COIN3 or CURRENT_STAGE_BLOCK(COIN3_POSITION - DOWN_VIEW);  	
		end if;
				
	end process; 

end GAME;