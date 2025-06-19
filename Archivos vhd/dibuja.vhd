-------------------------------------------------------------------------
---------
-- Company:
-- Engineer:
--
-- Create Date: 27.10.2022 10:50:36
-- Design Name:
-- Module Name: dibuja - Behavioral
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
-------------------------------------------------------------------------
---------
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
use IEEE.NUMERIC_STD.ALL;
-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;
entity dibuja is
Port ( eje_x : in STD_LOGIC_VECTOR (9 downto 0);
    eje_y : in STD_LOGIC_VECTOR (9 downto 0);
    dout_b:in STD_LOGIC_VECTOR(2 DOWNTO 0);
    adde_b:out STD_LOGIC_VECTOR(8 downto 0);
    dout:in STD_LOGIC_VECTOR(11 downto 0);
    ADDR:out STD_LOGIC_VECTOR(13 DOWNTO 0);
    RGB:out STD_LOGIC_VECTOR(11 downto 0);
    posicion:in std_logic_vector(3 DOWNTO 0)
    );
end dibuja;

architecture Behavioral of dibuja is
    signal RGB_in:STD_LOGIC_VECTOR(11 downto 0);
    signal fila : STD_LOGIC_VECTOR(7 downto 4);
    signal col : STD_LOGIC_VECTOR(8 downto 4);
    signal bit: std_logic_vector(5 downto 0);
    signal posicion_s: std_logic_vector(3 DOWNTO 0):=(others => '0');
begin
dibuja: process(eje_x, eje_y)
begin
ADDR <= (others=>'0');
bit <= "000000";
fila<=eje_y(7 downto 4);
        col<=eje_x(8 downto 4);
        posicion_s<=posicion;
        adde_b<= fila & col;
      
    if ((unsigned(eje_x)>0 and unsigned(eje_x)<512) and
    (unsigned(eje_y)>0 and unsigned(eje_y)<256)) then
      
            case dout_b is
                when "000" =>
                    bit <= "000000";
                    ADDR<= bit & eje_y(3 downto 0)& eje_x(3 downto 0);
                    RGB_in<=dout;
                when "001" =>
                    bit <= "000001";
                    ADDR<= bit & eje_y(3 downto 0)& eje_x(3 downto 0);    
                    RGB_in<=dout;
                when "010" =>
                    bit <= "000010"; 
                    ADDR<= bit & eje_y(3 downto 0)& eje_x(3 downto 0);    
                    RGB_in<=dout;
                when "011" =>
                    bit <= "000011";
                    ADDR<= bit & eje_y(3 downto 0)& eje_x(3 downto 0); 
                    RGB_in<=dout;
                when "100" =>
                RGB_in<=dout;
                    if (posicion_s= "1000") then
                        bit <= "000100";
                        ADDR<= bit & ( eje_x(3 downto 0) & eje_y(3 downto 0));--Mirando hacia arriba
                    elsif (posicion_s= "0100") then
                        bit <= "000101";
                        ADDR<= bit & (eje_x(3 downto 0) & eje_y(3 downto 0));--Mirando hacia abajo
                    elsif (posicion_s = "0010") then
                        bit <= "000100";
                        ADDR<= bit &( eje_y(3 downto 0) & eje_x(3 downto 0));--Mirando hacia izquierda
                    elsif (posicion_s= "0001") then
                        bit<="000101";
                        ADDR<= bit & eje_y(3 downto 0)& eje_x(3 downto 0);--Mirando hacia derecha
                    
                    end if;
                 when "101" =>
                 bit <= "000110";
                 ADDR<= bit & eje_y(3 downto 0)& eje_x(3 downto 0);    
                 RGB_in<=dout;
                

                when others=>
                    RGB_in<=dout;
             end case;
     else 
         RGB_in<="111111111111";
     
    end if;

end process;
    
RGB <= RGB_in;

end Behavioral;