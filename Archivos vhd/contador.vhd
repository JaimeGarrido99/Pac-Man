----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 15.10.2024 10:45:55
-- Design Name: 
-- Module Name: contador - Behavioral
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

entity contador is
    Generic (Nbit: INTEGER := 8);
    Port ( clk : in STD_LOGIC;
           reset : in STD_LOGIC;
           enable : in STD_LOGIC;
           resets : in STD_LOGIC;
           Q : out STD_LOGIC_VECTOR (Nbit-1 downto 0));
end contador;

architecture Behavioral of contador is
signal cont, p_cont : unsigned (Nbit-1 downto 0);
begin
reloj:process (clk,reset,resets)
begin
if (reset = '1') then
    cont<=(others=>'0');
        elsif (rising_edge(clk)) then
            if(resets='1') then
                cont<=(others=>'0');
            else
                cont<=p_cont;
            end if;
end if;
end process;

conta:process(cont,enable)
begin
p_cont<=cont;
    if (enable = '1') then
        p_cont<=cont+1;
    end if;
end process;
    
Q<=std_logic_vector(cont);

end Behavioral;
