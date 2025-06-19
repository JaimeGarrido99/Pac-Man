----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 13.11.2024 23:48:28
-- Design Name: 
-- Module Name: acceso_mem - Behavioral
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

entity acceso_mem is
 Port (--Conectado al comecocos
         addrc : in STD_LOGIC_VECTOR(8 DOWNTO 0);
         din_c : in STD_LOGIC_VECTOR(2 DOWNTO 0);
          wec : in STD_LOGIC_VECTOR(0 DOWNTO 0);
         enable_memc: in STD_LOGIC;
         doutc : out STD_LOGIC_VECTOR(2 DOWNTO 0);
      --Conectada a la memoria
         addra : out STD_LOGIC_VECTOR(8 DOWNTO 0);
         din_a : out STD_LOGIC_VECTOR(2 DOWNTO 0);
         wea : out STD_LOGIC_VECTOR(0 DOWNTO 0);
         doutac : in STD_LOGIC_VECTOR(2 DOWNTO 0);
         ena : out std_logic;
       --Conectado al fantasma
         addrf : in STD_LOGIC_VECTOR(8 DOWNTO 0);
         dinf : in STD_LOGIC_VECTOR(2 DOWNTO 0);
         wef : in STD_LOGIC_VECTOR(0 DOWNTO 0);
         enable_memf: in STD_LOGIC;
         doutaf : out STD_LOGIC_VECTOR(2 DOWNTO 0);
       --Conectado al fantasma2
         addrf2 : in STD_LOGIC_VECTOR(8 DOWNTO 0);
         dinf2 : in STD_LOGIC_VECTOR(2 DOWNTO 0);
         wef2 : in STD_LOGIC_VECTOR(0 DOWNTO 0);
         enable_memf2: in STD_LOGIC;
         doutaf2 : out STD_LOGIC_VECTOR(2 DOWNTO 0)  
         
);
       
       
end acceso_mem;

architecture Behavioral of acceso_mem is

-- Señales para conectar a la memoria
signal addr_s : STD_LOGIC_VECTOR(8 DOWNTO 0) := (others => '0');
signal din_s : STD_LOGIC_VECTOR(2 DOWNTO 0) := (others => '0');
signal dout_s : std_logic_vector(2 downto 0) := (others => '0');
signal we_s : STD_LOGIC_VECTOR(0 DOWNTO 0) := (others => '0');
signal ena_s: std_logic := '0';
begin

-- Asignaciones a las salidas
addra <= addr_s;
din_a <= din_s;
wea <= we_s;
dout_s <= doutac;
ena <= ena_s;

-- Proceso para controlar el acceso a la memoria
acceso: process(enable_memc, enable_memf, enable_memf2)
begin
    -- Valores por defecto para evitar latches
    addr_s <= (others => '0');
    din_s <= (others => '0');
    we_s <= (others => '0');
    doutc <= (others => '0');
    doutaf <= (others => '0');
    doutaf2 <= (others => '0');
    ena_s <= '0';

    -- Si esta activo enable_mem del comecocos
    if (enable_memc = '1') then
        addr_s <= addrc;
        din_s <= din_c;
        we_s <= wec;
        doutc <= dout_s;
        ena_s <= enable_memc;
        
    -- Si esta activo enable_mem del fantasma1    
    elsif (enable_memf = '1') then
        addr_s <= addrf;
        din_s <= dinf;
        we_s <= wef;
        doutaf <= dout_s;
        ena_s <= enable_memf;
        
     -- Si esta activo enable_mem del fantasma2   
     elsif (enable_memf2 = '1') then
        addr_s <= addrf2;
        din_s <= dinf2;
        we_s <= wef2;
        doutaf2 <= dout_s;
        ena_s <= enable_memf2;   
        
    end if;
end process;

end Behavioral;
