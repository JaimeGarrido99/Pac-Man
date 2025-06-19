----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 14.11.2024 01:34:18
-- Design Name: 
-- Module Name: gestion_botones - Behavioral
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

entity gestion_botones is
Port (udlr : out STD_LOGIC_VECTOR(3 DOWNTO 0);
      up : in STD_LOGIC;
      down : in STD_LOGIC;
      left : in STD_LOGIC;
      right : in STD_LOGIC 
      );
end gestion_botones;

architecture Behavioral of gestion_botones is
signal p_posx,posx: unsigned(4 DOWNTO 0);
signal p_posy,posy: unsigned(3 DOWNTO 0);
begin

comb : process (up, down,right,left)
begin
p_posy <= posy;
p_posx <= posx;
    if (up = '1') then
        p_posy <= (posy - 1);
        p_posx <= (posx);
        
    elsif(down = '1') then
        p_posy <= (posy + 1);
        p_posx <= (posx);
   
    elsif(right = '1') then
        p_posx <= (posx+1);
        p_posy <= posy;
      
     elsif(left = '1') then
        p_posx <= (posx-1);
        p_posy <= posy;
        
    end if;
end process;

udlr(3) <= up;
udlr(2) <= down;
udlr(1) <= left;
udlr(0) <= right;

end Behavioral;
