library IEEE;					
library work;
use IEEE.std_logic_1164.all;
use IEEE.std_logic_unsigned.all;
use work.pkg.all;

entity TURTLE is  
	port(					   
		CLK: in STD_LOGIC;
		CLR: in STD_LOGIC;						 
		ALIVE: in STD_LOGIC;
		ENEMY: out STD_LOGIC_VECTOR(4 downto 0);
		TURTLE_POSITION: out INTEGER range 6 to 11
	);	
end TURTLE;

architecture TURTLE of TURTLE is
	
	-- Variables que permiten cambiar la direccion del movimiento
	signal WALK_COUNT: INTEGER range 6 to 11:= 11;
	signal WALK_LEFT: STD_LOGIC:= '1';
	 
	signal CLK_DIV: STD_LOGIC:= '0';
	
	signal t: STD_LOGIC:= '0';
	
begin
	
	TURTLE_POSITION <= WALK_COUNT;

	process (CLK) begin
		
		-- Divisor de frecuencia
		if rising_edge(CLK) then
			CLK_DIV <= not CLK_DIV;
		end if;
		
	end process; 
	
	process (CLK_DIV) begin 
		
		if rising_edge(CLK_DIV) then  
			
			if ALIVE = '1' then
				
				-- Si camina hacia la derecha, entonces aumentamos el contador
				if WALK_LEFT = '0' and WALK_COUNT < 11 then 
					WALK_COUNT <= WALK_COUNT + 1;								   
				
				-- Si camina hacia la izquierda, entonces decrementamos el contador
				elsif WALK_LEFT = '1' and WALK_COUNT > 6 then 
					WALK_COUNT <= WALK_COUNT - 1;
				end if;															   
				
				-- Cuando nos encontramos en el borde izquierdo, entonces cambiamos de direccion a la derecha
				if WALK_COUNT = 10 then
					WALK_LEFT <= '1';																   
					
				-- Cuando nos encontramos en el borde derecho, entonces cambiamos de direccion a la izquierda
				elsif WALK_COUNT = 7 then
					WALK_LEFT <= '0';
				end if;
				
			end if;
			
		end if;
		
	end process;
	
	process (WALK_LEFT, ALIVE) begin
		
		-- Si la tortuga esta viva, entonces aun la dibujamos
		if ALIVE = '1' then
			ENEMY <= "00010";	
		else	
			ENEMY <= "00000";			
		end if;
		
	end process;

end TURTLE;
