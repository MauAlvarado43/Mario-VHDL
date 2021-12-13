library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.std_logic_unsigned.all;
library work;
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

	component COUNTER is 						   
		generic( 
			HEIGH: INTEGER:= 4	
		);
		port(
			CLK: in STD_LOGIC;	
			CLR: in STD_LOGIC;
			COUNTER_OUT: out STD_LOGIC_VECTOR(HEIGH - 1 downto 0)
		);
	end component; 
	
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
			STAGE: in STD_LOGIC_VECTOR(4 downto 0);
			PLAYER: out STD_LOGIC_VECTOR(4 downto 0)
		);
	end component;	
	
	constant ZERO: STD_LOGIC:= '0';	 
	
	signal CURRENT_STAGE_BLOCK: STAGE_BLOCK;
	
	signal CURRENT_CLR: STD_LOGIC:= '0';
	
	signal CURRENT_MARIO: STD_LOGIC_VECTOR(4 downto 0);
	signal MARIO_BLOCK_POSITION: STD_LOGIC_VECTOR(4 downto 0):= "00001";
	signal MARIO_POSITION: INTEGER range 0 to 15:= 0;
	signal MARIO_VERTICAL_POSITION: INTEGER range 0 to 4;
	signal MARIO_WAIT: STD_LOGIC:= '0';	  
	
	signal DOWN_VIEW: INTEGER range 0 to 9:= 0;
	
	signal CURRENT_OUT: STAGE_BLOCK;	 
		
begin 	 
	
	MARIO_BLOCK_POSITION <= CURRENT_STAGE_BLOCK(MARIO_POSITION - DOWN_VIEW); 
	
	stage_gen: STAGE port map(
		INDEX => DOWN_VIEW,
		BUS_DATA => CURRENT_STAGE_BLOCK
	);
	
	mario_gen: MARIO port map(	
		CLK => CLK,
		CLR => CURRENT_CLR,
		JUMP => UP,	
		STAGE => MARIO_BLOCK_POSITION,
		PLAYER => CURRENT_MARIO
	);
	
	process (CLK) begin
		
		if rising_edge(CLK) then
	
			if RIGHT = '1' and LEFT = '0' and MARIO_POSITION < 15 then
				MARIO_POSITION <= MARIO_POSITION + 1;	
			elsif RIGHT = '0' and LEFT = '1' and MARIO_POSITION > 0 then
				MARIO_POSITION <= MARIO_POSITION - 1;
			end if;	 
			
			if MARIO_POSITION - DOWN_VIEW > 3 and MARIO_POSITION < 13 then
				DOWN_VIEW <= DOWN_VIEW + 1;	 
			elsif MARIO_POSITION - DOWN_VIEW < 3 and MARIO_POSITION > 2 then
				DOWN_VIEW <= DOWN_VIEW - 1;
			end if;
			
		end if;
			
	end process;
	
	process (CURRENT_MARIO) begin
		
		CURRENT_OUT <= CURRENT_STAGE_BLOCK;
		CURRENT_OUT(MARIO_POSITION - DOWN_VIEW) <= CURRENT_MARIO or CURRENT_STAGE_BLOCK(MARIO_POSITION - DOWN_VIEW);
				
	end process;
	
	--counter_gen: COUNTER port map(
	--	CLK => CLK,	
	--	CLR => CURRENT_CLR,
	--	COUNTER_OUT => INDEX
	--);
	
	-- process (CLK) begin
		
		-- if CLK'event and CLK = '1' and not GAME_OVER 
			
			-- for i in CONV_INTEGER(INDEX) - 6 to CONV_INTEGER(INDEX) loop
				
				-- if CURRENT_MARIO(i) and CURRENT_STAGE_BLOCK(0)(i) then	
					
					-- CURRENT_LIVES <= CURRENT_LIVES - 1;
					-- CURRENT_CLR <= '1';
					
				-- end if;
				
			-- end loop; 
			
			-- if INDEX = "1111" OR CURRENT_LIVES = "00" then
				
				-- GAME_OVER <= '1';
				
			-- end if;
			
		-- end if;
		
	-- end process;

end GAME;