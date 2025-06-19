---------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 17.10.2024 14:27:23
-- Design Name: 
-- Module Name: FSM - Behavioral
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

 entity maquina_cmc is
 generic (Max_cont:integer:=12);
 Port ( clk : in STD_LOGIC;
        reset : in STD_LOGIC; 
        movec : in STD_LOGIC; 
        udlr : in STD_LOGIC_VECTOR(3 DOWNTO 0);
        ADDR : out std_logic_vector(8 DOWNTO 0);
        doutc : in std_logic_vector(2 downto 0); 
        donec : out STD_LOGIC;
        come_bola : out STD_LOGIC;
        din : out std_logic_vector(2 downto 0);
        wec: out STD_LOGIC_VECTOR (0 DOWNTO 0);
        enable_mem: out STD_LOGIC;
        posicion : out std_logic_vector(3 downto 0)
        );
       
 end maquina_cmc;

architecture Behavioral of maquina_cmc is
--Estados
type SERIE is (Reposo,Comprobar_direccion,Comprobar_dato,Vaciar_casilla,Actualiza_posicion,Mover,Muerte,Hay_muro,Comprobar_muro);
--Señales para reccordar la posicion
signal last_udlr,p_last_udlr: std_logic_vector(3 DOWNTO 0):=(others => '0');

--Señales para la posicion en el eje x y eje y
signal posx, p_posx: unsigned (4 downto 0) := ("01111");
signal posy, p_posy: unsigned (3 downto 0) := ("1110");

--Señales para almacenar el estado en el que se encuentra 
signal estado, p_estado: SERIE:= Reposo;

--Señal que se activará cuando el pacman coma una bola
signal p_pulso_bola,pulso_bola_s: STD_LOGIC;

--Señal para la actualizacion de din
signal p_din,din_s: std_logic_vector(2 downto 0);

--Señales para el contador auxiliar para aumentar el numero de clk de los estados
signal cont, p_cont: unsigned(6 downto 0);

--Señales para la señal ADDR
signal ADDR_s,p_ADDR: std_logic_vector(8 downto 0):= "111001111";

--Señales para transmitir el dato de cada direccion 
signal dout_s,p_dout: std_logic_vector(2 downto 0);

--Señales para activar la escritura en memoria
signal we_s, p_we: std_logic_vector(0 downto 0);

--Señal para enable_mem de la memoria 
signal enable_mems, p_enable_mems: std_logic;

--Señales auxiliares para gestionar el movimiento del pac-man
signal direccion_actual,direccion_actual_s : std_logic_vector(3 downto 0);
signal direccion_usar,direccion_usar_s : std_logic_vector (3 downto 0);

--Señal para activar el movimiento del fantasma
signal p_done,done_s : std_logic;


begin
  --Asignacion de señales síncronas a las entradas/salidas de la entidad
  ADDR <= ADDR_s;
  din <= din_s;
  enable_mem <= enable_mems;
  wec <= we_s;
  come_bola <= pulso_bola_s;
  donec <= done_s;
  posicion <= last_udlr;
 --Inicio proceso sincrono, establezco reset y actualizo variables mediante los ciclos de reloj
    sinc : process(clk,reset)
   begin 
   
   if (reset = '1') then 
    --Inicializamos variables sincronas
     estado <= Reposo;
     din_s  <= "100";
     we_s <= (others => '0');
     posx <= ("01111");
     posy <= ("1110");
     cont <= (others=>'0');
     ADDR_s <= "111001111";
     enable_mems <= '0';
     last_udlr <= "0000";
     direccion_actual_s <= "0000";
     done_s <= '0';

elsif(rising_edge(clk)) then  
    --Actualizacion de señales síncronas al tener un clk
     estado <= p_estado;
     posx <= p_posx;
     posy <= p_posy;
     cont <= p_cont;
     din_s <= p_din;
     ADDR_s <= p_ADDR;
     we_s <= p_we;
     enable_mems <= p_enable_mems;
     last_udlr <= p_last_udlr;
     direccion_usar_s <= direccion_usar;
     direccion_actual_s <= direccion_actual;
     last_udlr <= p_last_udlr;
     done_s <= p_done;
     pulso_bola_s <= p_pulso_bola;
    
end if;

    end process sinc;    
     
     --Proceso combinacional   
     comb : process(last_udlr,direccion_usar_s,direccion_actual_s,posx,movec,posy,estado)
     begin 
     --Actualizacion de señales combinacionales
     p_estado <= estado;
     p_posx <= posx;
     p_posy <= posy;
     p_we <= we_s;
      p_cont <= cont;
     p_din <= din_s;
     p_ADDR <= ADDR_s;
     p_enable_mems <= enable_mems;
     p_last_udlr <= last_udlr;
     direccion_actual <= direccion_actual_s;
     direccion_usar <= direccion_usar_s;
     p_last_udlr <= last_udlr;
     p_done <= done_s;
     p_pulso_bola <= pulso_bola_s;
    
     --Gestión de la direccion para mantener el movimiento   
     if (udlr /= "0000")then
        direccion_actual <= udlr;    
     else 
        direccion_usar <= direccion_actual_s;
     end if;
     
     --Comenzamos a distinguir los estados
     case (estado) is 
     --Reposo: inicializamos valores y al recibir movec, pasamos al siguiente estado
      when Reposo => 
                     p_cont<=(others=>'0');
                     p_we <= (others=> '0');
                      p_done <= '0';
      --Si recibe move, vamos al siguiente estado
      if (movec = '1') then 
       --if cont = Max_cont then
            p_enable_mems <= '1';
            p_estado <= Comprobar_direccion;
            p_cont <= (others => '0');
            p_we <= (others=>'0');
       end if;  
       
   --Comprobar_direccion:Comprobamos direccion a la que queremos movernos
     when Comprobar_direccion => 
     --Apuntamos a la direccion correspondiente de memoria en funcion del valor
     --de direccion_usar
    
     if (direccion_usar_s = "1000") then
     p_ADDR <= std_logic_vector((posy-1)& posx);
     elsif (direccion_usar_s= "0100") then
     p_ADDR <= std_logic_vector((posy+1)& posx);
     elsif (direccion_usar_s = "0010") then
     p_ADDR <= std_logic_vector(posy & (posx-1));
     elsif (direccion_usar_s = "0001") then
     p_ADDR <= std_logic_vector(posy & (posx+1));
    else 
     p_estado <= Reposo;
     p_ADDR <= std_logic_vector(posy & posx);
     end if;
    
    --Pasamos a Comprobar_dato
    if cont = Max_cont then
        p_estado <= Comprobar_dato;
        p_cont <= (others => '0');
        else 
        p_cont <= cont + 1;
     end if;
    
    
     --Comprobar_dato:Comprobamos el dato contenido en la direccion de memoria
     when Comprobar_dato =>
     --Si me encuentro un muro, pasamos al estado Hay_muro
    if (doutc = "001") then
    if cont = Max_cont then
        p_estado <= Hay_muro;   
        p_cont <= (others => '0');
        else 
        p_cont <= cont + 1;
     end if;
     
     --Si encuentro vacio, actualizamos una variable auxiliar con el valor de la 
     --direccion y pasamos a Vaciar_casilla     
     elsif (doutc = "000") then
        if cont = Max_cont then
        p_last_udlr <= direccion_usar_s;
        p_estado <= Vaciar_casilla;
        p_cont <= (others => '0');
        else 
        p_cont <= cont + 1;
     end if;  
     
     --Si encuentro bola, activo pulso_bolac, pensado para contar las bolas del pacman
     elsif (doutc = "010") then
        p_pulso_bola <= '1';
        p_estado <= Vaciar_casilla;
        p_last_udlr <= direccion_usar_s;
        p_we <= (others=>'1');
        p_din <= "000";
         
     --Si encontramos al fantasma vamor al estado Muerte y
     -- pintamos vacio en la casilla del pacman
     elsif (doutc ="011" or doutc ="101") then
        p_estado <= Muerte;
        p_we <= (others => '1');       
        p_din <= "000";               
        p_ADDR <= std_logic_vector(posy & posx);
  
     elsif (doutc = "100") then
        p_estado <= Vaciar_casilla;    
    end if;   
     
    --Hay_muro:Comprobamos la direccion a la que queremos movernos en funcion de la variable auxiliar "last_udlr"
    when Hay_muro =>
     if (last_udlr = "1000") then
     p_ADDR <= std_logic_vector((posy-1)& posx);
     elsif (last_udlr = "0100") then
     p_ADDR <= std_logic_vector((posy+1)& posx);
     elsif (last_udlr = "0010") then
     p_ADDR <= std_logic_vector(posy & (posx-1));
     elsif (last_udlr = "0001") then
     p_ADDR <= std_logic_vector(posy & (posx+1));
     else 
      p_ADDR <= std_logic_vector(posy & posx);
     end if;
         
     --Pasamos a Comprobar_muro
     if cont = Max_cont then
        p_estado <= Comprobar_muro;
        p_cont <= (others => '0');
        else 
        p_cont <= cont + 1;
     end if;
    
    --Comprobar_muro: Comprobamos el dato de la siguiente direccion 
    when Comprobar_muro =>
    --Si volvemos a encontrar un muro en la nueva direccion, actualizamos direccion_usar con
    --nuestra variable auxiliar last_udlr, y volvemos a Comprobar_direccion
    if doutc = "001" then
        direccion_usar <= last_udlr;
        
        if cont = Max_cont then
        p_estado <= Comprobar_direccion; -- Pasar al siguiente estado
        p_cont <= (others => '0');      -- Reiniciar el contador
        p_we <= (others => '0');        -- Deshabilitar escritura
            else
        p_cont <= cont + 1;
        end if;
    
    --Si no encontramos muro, seguimos en la misma direccion y pasamos a Vaciar_casilla
    else 
        direccion_usar <= direccion_usar_s;
        if cont = Max_cont then
      p_estado <= Vaciar_casilla; -- Pasar al siguiente estado
      p_cont <= (others => '0');      -- Reiniciar el contador
      p_we <= (others => '0');        -- Deshabilitar escritura
        else
      p_cont <= cont + 1;
        end if;
    end if;

     --Muerte: Devolvemos el pacman a la posicion inicial y volvemos a Reposo
     when Muerte =>  
      p_posx <= "01111";
      p_posy <= "1110";
      p_estado <= Reposo;
     
     --Vaciar_casilla: Activo escritura en memoria y vacio la casilla actual
    when Vaciar_casilla =>
    -- Activar escritura para vaciar la casilla actual
    p_pulso_bola <= '0';
    p_we <= (others => '1');       
    p_din <= "000";                
    p_ADDR <= std_logic_vector(posy & posx); 
    
    --Pasamos a Actualiza_posicion
    if cont = Max_cont then
        p_estado <= Actualiza_posicion; 
        p_cont <= (others => '0');      
        p_we <= (others => '0');        
    else
        p_cont <= cont + 1;
    end if;
   
    --Actualiza_posicion: Doy nuevos valores a la posición del pacman en funcion la dirección
     when Actualiza_posicion =>  
      if (last_udlr= "1000") then
       p_posy <= posy-1;
       p_posx <= posx;
     elsif (last_udlr = "0100") then
       p_posy <= posy+1;
       p_posx <= posx;       
     elsif (last_udlr = "0010") then
      p_posy <= posy;
       p_posx <= posx-1;
     elsif (last_udlr= "0001") then
     p_posy <= posy;
     p_posx <= posx+1;
     else 
      p_posy <= posy;
      p_posx <= posx;
     end if;           
      
      --Pasamos a mover  
      p_estado <= Mover;  

   --Mover: Activo escritura en memoria y pinto el pacman en la nueva posicion
   when Mover =>
    p_we <= (others => '1');   
    p_ADDR <= std_logic_vector(posy & posx); 
    p_din <= "100"; 
    p_done <= '1';
     
    --Volvemos a Reposo
    if cont = Max_cont then
        p_enable_mems <= '0';
        p_estado <= Reposo;  
        p_cont <= (others => '0');
        p_we <= (others => '0'); 
    else
        p_cont <= cont + 1;
    end if;

  end case;
   end process;
end Behavioral;
