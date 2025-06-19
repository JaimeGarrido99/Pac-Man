
-- Company: 
-- Engineer: 
-- 
-- Create Date: 16.10.2024 12:37:23
-- Design Name: 
-- Module Name: frec_pixel - Behavioral
-- Project Name: 
-- Target Devices: 
-- Tool Versions: 
-- Description: 
-- 
-- Dependencies: 
-- 
-- Revision:
-- Revision 0.01 - File Created
-- Additional Comments:
-- 
----------------------------------------------------------------------------------


library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity divisor_mov is
    Port ( clk : in STD_LOGIC;
           reset : in STD_LOGIC;
           refresh : in std_logic;
           clk_pixel : out STD_LOGIC);
end divisor_mov;

architecture Behavioral of divisor_mov is
signal cont,cont_s: unsigned(15 downto 0);
begin

reloj:process(reset,clk)
begin
    if(reset='1') then
        cont<=(others=>'0');       
    elsif(rising_edge(clk)) then
            cont<=cont_s;
end if;
end process;               

conto:process(cont,refresh)
begin            
    cont_s <= cont;
    clk_pixel <= '0';
      
        if(refresh = '1') then
            cont_s <= cont+1;
            
            if(cont = 15) then
            clk_pixel <= '1';
            cont_s <= (others=>'0');
            end if;
        end if;
        
        
    
end process;

end Behavioral;