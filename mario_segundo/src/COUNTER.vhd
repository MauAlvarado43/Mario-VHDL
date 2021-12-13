library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.std_logic_unsigned.all;

entity COUNTER is 						   
	generic( 
		HEIGH: INTEGER:= 4	
	);
	port(
		CLK: in STD_LOGIC;	
		CLR: in STD_LOGIC;
		COUNTER_OUT: out STD_LOGIC_VECTOR(HEIGH - 1 downto 0):= "0110"
	);
end COUNTER;

architecture COUNTER of COUNTER is	

	signal Q: STD_LOGIC_VECTOR(3 downto 0):= "0110";

begin 
	
	COUNTER_OUT <= Q;

	process(CLK, CLR) begin
		
		if CLR = '1' then
			Q <= "0110";
		else  
			
			if CLK'event and CLK = '1' then
			
				Q(0) <= NOT Q(0); 
			
				if Q(0) = '1' then	
					
					Q(1) <= NOT Q(1);
					
					if Q(1) = '1' then 
						
						Q(2) <= NOT Q(2);
						
						if Q(2) = '1' then
						
							Q(3) <= NOT Q(3); 
							
						end if;
						
					end if;
					
				end if;	
				
				if Q = "1111" then
					Q <= "0110";
				end if;
				
			end if;
			
		end if;
		
	end process; 

end COUNTER;
