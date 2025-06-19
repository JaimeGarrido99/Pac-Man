----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 16.10.2024 09:22:02
-- Design Name: 
-- Module Name: comparador - Behavioral
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

entity comparador is
    Generic (Nbit: integer :=8;
    End_Of_Screen: integer :=10;
    Start_Of_Pulse: integer :=20;
    End_Of_Pulse: integer := 30;
    End_Of_Line: integer := 40);
    Port ( clk : in STD_LOGIC;
           reset : in STD_LOGIC;
           data : in STD_LOGIC_VECTOR (Nbit-1 downto 0);
           O1 : out STD_LOGIC;
           O2 : out STD_LOGIC;
           O3 : out STD_LOGIC);
end comparador;

architecture Behavioral of comparador is
signal dato: unsigned(Nbit-1 downto 0);
begin

comp:process(clk,reset)
begin   
    if(reset='1')then
        O1<='0';
        O2<='0';
        O3<='0';
        elsif(rising_edge(clk)) then
            if(dato > End_Of_Screen) then
                O1<='1';
            else
                O1<='0';
            end if;
             if (Start_Of_Pulse<dato and dato<End_Of_Pulse) then
                O2<='0';
            else
                O2<='1';
            end if;
            if(dato=End_Of_Line) then
                O3<='1';
            else
                O3<='0';
            end if;
    end if;
   
end process;

dato<=unsigned(data);           
     


end Behavioral;
