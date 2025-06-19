----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 16.10.2024 14:30:15
-- Design Name: 
-- Module Name: VGA_driver - Behavioral
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
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity VGA_driver is

    Port ( clk : in STD_LOGIC;
           reset : in STD_LOGIC;
           RGB_in : in STD_LOGIC_VECTOR (11 downto 0);
           VS : out STD_LOGIC;
           HS : out STD_LOGIC;
           RED_out : out STD_LOGIC_VECTOR (3 downto 0);
           GRN_out : out STD_LOGIC_VECTOR (3 downto 0);
           BLU_out: out STD_LOGIC_VECTOR (3 downto 0);
           ejex_out:out STD_LOGIC_VECTOR (9 downto 0);
           ejey_out:out STD_LOGIC_VECTOR (9 downto 0);
           refresh:out STD_LOGIC
           );
end VGA_driver;

architecture Behavioral of VGA_driver is

component contador is
    Generic (Nbit: INTEGER := 8);
    Port ( clk : in STD_LOGIC;
           reset : in STD_LOGIC;
           enable : in STD_LOGIC;
           resets : in STD_LOGIC;
           Q : out STD_LOGIC_VECTOR (Nbit-1 downto 0));
end component;

component comparador is
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
end component;

component frec_pixel is
    Port ( clk : in STD_LOGIC;
           reset : in STD_LOGIC;
           clk_pixel : out STD_LOGIC);
end component;





signal clk_pixel_s,and_s, O3_hs, O3_vs, O1_hs, O2_hs, O1_vs, O2_vs: std_logic;
signal ejex_s,ejey_s: std_logic_vector(9 downto 0);
signal RED_s,GRN_s,BLU_s : std_logic_vector(3 downto 0);
signal Blank_H, Blank_V : std_logic;

signal RED2_s, GRN2_s, BLU2_s : std_logic_vector(3 downto 0);


begin


frec: frec_pixel
PORT MAP(clk=>clk,
         reset =>reset,
         clk_pixel=>clk_pixel_s);

conth: contador
generic map( Nbit=>10)
PORT MAP(clk=>clk,
         reset=>reset,
         enable=>clk_pixel_s,
         resets=>and_s,
         Q=>ejex_s );
      
contv: contador
generic map( Nbit=>10)
PORT MAP(clk=>clk,
         reset=>reset,
         enable=>and_s,
         resets=>O3_vs,
         Q=>ejey_s );
         
comph: comparador
generic map(Nbit=>10, 
        End_Of_Screen=>639, 
        Start_Of_Pulse=>655,
        End_Of_Pulse=>751, 
        End_Of_Line=>799)
PORT MAP(clk=>clk,
         reset=>reset,
         data=>ejex_s, 
         O1=>O1_hs,  
         O2=>O2_hs,
         O3=>O3_hs);

compv: comparador
generic map(Nbit=>10, 
        End_Of_Screen=>479, 
        Start_Of_Pulse=>489,
        End_Of_Pulse=>491, 
        End_Of_Line=>520)
PORT MAP(clk=>clk,
         reset=>reset,
         data=>ejey_s, 
         O1=>O1_vs,  
         O2=>O2_vs,
         O3=>O3_vs);
 
 Blank_H<=O1_hs;
Blank_V<=O1_vs;    
         
gen_color:process(Blank_H, Blank_V, RGB_in)
begin 
if (Blank_H='1' or Blank_V='1') then
    RED_out<=(others => '0'); 
    GRN_out<=(others => '0');
    BLU_out<=(others => '0');
else
    RED_out<=RGB_in(11 downto 8); 
    GRN_out<=RGB_in(7 downto 4); 
    BLU_out<=RGB_in(3 downto 0);
end if;
end process;



VS<=O2_vs;
HS<=O2_hs;
and_s<=clk_pixel_s and O3_hs;
refresh<=O3_vs;
ejex_out<=ejex_s;
ejey_out<=ejey_s;


end Behavioral;