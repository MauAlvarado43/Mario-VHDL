library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.std_logic_unsigned.all;  


-- Tipo de dato "escenario" que permite controlar la ventana visible en los leds
package pkg is
  type STAGE_BLOCK is array (0 to 5) of std_logic_vector(4 downto 0);
end package;

package body pkg is
end package body;  

library IEEE;					 
library work;
use IEEE.std_logic_1164.all;
use IEEE.std_logic_unsigned.all; 
use work.pkg.all;

entity STAGE is
	port(  
		INDEX: in INTEGER range 0 to 9;
		BUS_DATA: out STAGE_BLOCK
	);
end STAGE;

architecture STAGE of STAGE is	

	-- ROM del escenario
	constant STAGE1: STD_LOGIC_VECTOR(4 downto 0):= "00001";
	constant STAGE2: STD_LOGIC_VECTOR(4 downto 0):= "00101";
	constant STAGE3: STD_LOGIC_VECTOR(4 downto 0):= "00001";
	constant STAGE4: STD_LOGIC_VECTOR(4 downto 0):= "00000";
	constant STAGE5: STD_LOGIC_VECTOR(4 downto 0):= "00001";
	constant STAGE6: STD_LOGIC_VECTOR(4 downto 0):= "00111";
	constant STAGE7: STD_LOGIC_VECTOR(4 downto 0):= "00001";
	constant STAGE8: STD_LOGIC_VECTOR(4 downto 0):= "00001";
	constant STAGE9: STD_LOGIC_VECTOR(4 downto 0):= "00001";
	constant STAGE10: STD_LOGIC_VECTOR(4 downto 0):= "00001";
	constant STAGE11: STD_LOGIC_VECTOR(4 downto 0):= "00001";
	constant STAGE12: STD_LOGIC_VECTOR(4 downto 0):= "00001";
	constant STAGE13: STD_LOGIC_VECTOR(4 downto 0):= "00011";
	constant STAGE14: STD_LOGIC_VECTOR(4 downto 0):= "00000";
	constant STAGE15: STD_LOGIC_VECTOR(4 downto 0):= "00001";

	signal DATA: STAGE_BLOCK;

begin 
	
	BUS_DATA <= DATA;
	
	-- Dependiendo del indice dado, retornamos una ventana del escenario
	process(INDEX) begin
		
		case INDEX is
			when 0 => DATA <= (STAGE1, STAGE2, STAGE3, STAGE4, STAGE5, STAGE6);
			when 1 => DATA <= (STAGE2, STAGE3, STAGE4, STAGE5, STAGE6, STAGE7); 
			when 2 => DATA <= (STAGE3, STAGE4, STAGE5, STAGE6, STAGE7, STAGE8);  
			when 3 => DATA <= (STAGE4, STAGE5, STAGE6, STAGE7, STAGE8, STAGE9);
			when 4 => DATA <= (STAGE5, STAGE6, STAGE7, STAGE8, STAGE9, STAGE10);
			when 5 => DATA <= (STAGE6, STAGE7, STAGE8, STAGE9, STAGE10, STAGE11);
			when 6 => DATA <= (STAGE7, STAGE8, STAGE9, STAGE10, STAGE11, STAGE12);
			when 7 => DATA <= (STAGE8, STAGE9, STAGE10, STAGE11, STAGE12, STAGE13);
			when 8 => DATA <= (STAGE9, STAGE10, STAGE11, STAGE12, STAGE13, STAGE14);
			when 9 => DATA <= (STAGE10, STAGE11, STAGE12, STAGE13, STAGE14, STAGE15);
			when others => DATA <= (STAGE1, STAGE1, STAGE1, STAGE1, STAGE1, STAGE1);
		end case;
		
	end process;

end STAGE;