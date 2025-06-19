library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity maquina_fantasma2 is
    generic (
        Max_cont : integer := 12
    );
    Port (
        clk         : in  STD_LOGIC;
        reset       : in  STD_LOGIC;
        movef2       : in  STD_LOGIC;
        ADDRf2       : out std_logic_vector(8 DOWNTO 0);
        doutf2       : in  std_logic_vector(2 downto 0);
        donef2       : out STD_LOGIC;
        dinf2        : out std_logic_vector(2 downto 0);
        wef2         : out STD_LOGIC_VECTOR (0 DOWNTO 0);
        enable_memf2 : out STD_LOGIC
    );
end maquina_fantasma2;

architecture Behavioral of maquina_fantasma2 is
    type SERIE is (Reposo, Comprobar_direccion, Comprobar_dato, Vaciar_casilla, Actualiza_posicion,Mover);

   --Señales para reccordar la posicion
    signal last_udlr, p_last_udlr       : std_logic_vector(3 DOWNTO 0) := (others => '0');
    
    --Señales para la posicion en el eje x y eje y
    signal posx, p_posx                : unsigned (4 downto 0) := ("00001");
    signal posy, p_posy                : unsigned (3 downto 0) := ("1001");
    
    --Señales para almacenar el estado en el que se encuentra 
    signal estado, p_estado            : SERIE := Reposo;
    
    --Señal para la actualizacion de din
    signal p_din, din_s                : std_logic_vector(2 downto 0) := (others => '0');
    
    --Señales para el contador auxiliar para aumentar el numero de clk de los estados
    signal cont, p_cont                : unsigned(6 downto 0) := (others => '0');
    
    --Señales para la señal ADDR
    signal ADDR_s, p_ADDR              : std_logic_vector(8 downto 0) := ("100100001") ;
    
    --Señales para transmitir el dato de cada direccion
    signal dout_s, p_dout              : std_logic_vector(2 downto 0);
    
    --Señales para activar la escritura en memoria
    signal we_s, p_we                  : std_logic_vector(0 downto 0) := (others => '0');
    
    --Señal para enable_mem de la memoria
    signal enable_mems, p_enable_mems  : std_logic := '0';
    
    --Señales para gestionar la direccion del fantasma2
    signal direccion_usar, direccion_usar_s    : std_logic_vector(3 DOWNTO 0):= "0100";
    
    --Señales auxiliares para pintar el objeto en la casilla cuando pase el fantasma2
    signal dato_ant, p_dato_ant        : std_logic_vector(2 downto 0) := (others => '0');
    signal dato_prox, p_dato_prox      : std_logic_vector(2 downto 0) := (others => '0');
    
    --Señal para done del fantasma2
    signal p_donef, donef_s:std_logic;

begin

    ADDRf2 <= ADDR_s;
    dinf2 <= din_s;
    enable_memf2 <= enable_mems;
    wef2 <= we_s;
    donef2 <= donef_s;
    
    -- Proceso sincrono
    sinc : process(clk, reset)
    begin
        if reset = '1' then
            estado <= Reposo;
            din_s <= (others => '0');
            we_s <= (others => '0');
            direccion_usar_s <= "0100";
            posx <= "00001";
            posy <= "1001";
            cont <= (others => '0');
            ADDR_s <= "100100001";
            enable_mems <= '0';
            last_udlr <= "0000";
            dato_ant <= "000";
            dato_prox <= "000";
            donef_s <= '0';

        elsif rising_edge(clk) then
            estado <= p_estado;
            posx <= p_posx;
            posy <= p_posy;
            cont <= p_cont;
            din_s <= p_din;
            ADDR_s <= p_ADDR;
            we_s <= p_we;
            --contaux <= p_contaux;
            enable_mems <= p_enable_mems;
            last_udlr <= p_last_udlr;
            direccion_usar_s <= direccion_usar;
            dato_ant <= p_dato_ant;
            dato_prox <= p_dato_prox;
            donef_s <= p_donef;

        end if;
    end process;

    -- Proceso combinacional
    comb : process(movef2,direccion_usar_s,last_udlr,posx,cont, posy, estado)
    begin
        p_estado <= estado;
        p_posx <= posx;
        p_posy <= posy;
        p_we <= we_s;
        p_cont <= cont;
        p_din <= din_s;
        p_ADDR <= ADDR_s;
        p_enable_mems <= enable_mems;  
        p_last_udlr <= last_udlr;
        direccion_usar <= direccion_usar_s;
        p_dato_ant <= dato_ant;
        p_dato_prox <= dato_prox;
        p_donef <= donef_s;

        
        -- Maquina de estados
        case estado is
        
            --Reposo: inicializamos valores y al recibir movef, pasamos al siguiente estado
            when Reposo =>
                p_cont <= (others => '0');
                p_we <= (others => '0');
                if movef2 = '1' then                   
                    p_enable_mems <= '1';
                    p_donef <= '0';
                    p_estado <= Comprobar_direccion;
                end if;

            --Comprobar_direccion:Comprobamos direccion a la que queremos movernos
            when Comprobar_direccion =>
                if direccion_usar_s = "1000" then
                    p_ADDR <= std_logic_vector((posy - 1) & posx);
                elsif direccion_usar_s = "0100" then
                    p_ADDR <= std_logic_vector((posy + 1) & posx);
                elsif direccion_usar_s = "0010" then
                    p_ADDR <= std_logic_vector(posy & (posx - 1));
                elsif direccion_usar_s = "0001" then
                    p_ADDR <= std_logic_vector(posy & (posx + 1));
                end if;
                
                if cont = Max_cont then
                p_estado <= Comprobar_dato;
                p_cont <= (others => '0');
                else 
                p_cont <= cont + 1;
                end if;
            
            --Comprobar_dato:Comprobamos el dato contenido en la direccion de memoria    
            when Comprobar_dato =>
                --Movimiento determinado
                --Al llegar abajo, si se encuentra muro y la direccion usada es hacia abajo,
                --pasa a moverse a la dcha
                if (doutf2 = "001" and direccion_usar_s = "0100") then
                 direccion_usar <= "0001";
                 p_estado <= Comprobar_direccion;   
                
                --Si nos estamos moviendo a la dcha y encuentra muro,
                --pasa a moverse a la izq        
                elsif (doutf2 = "001" and direccion_usar_s = "0001")then
                  direccion_usar <= "0010";
                  p_estado <= Comprobar_direccion;
            
                --Si nos estamos moviendo a la dcha y encuentra muro,
                --pasa a moverse a la izq       
                elsif (doutf2 = "001" and direccion_usar_s = "0010")then
                   direccion_usar <= "0001";
                   p_estado <= Comprobar_direccion;   
             
                --Si encuentra dato distinto de muro, pasa a Vaciar_casilla 
                elsif doutf2 = "000" or doutf2 = "010" or doutf2 = "011" then             
                    p_dato_prox <= doutf2;
                  if cont = Max_cont then
                    p_last_udlr <= direccion_usar_s;
                    p_estado <= Vaciar_casilla;   
                    p_cont <= (others => '0');
                    else 
                    p_cont <= cont + 1;
                    end if;
                
                --Si encuentra pacman
                elsif doutf2 = "100" then
                    p_posx <= posx; 
                    p_posy <= posy;
                    p_we <= (others => '1');
                    p_din <= "000";
                                   
                p_estado <= Reposo;
                end if;
                


        --Vaciar_casilla: Activo escritura en memoria y escribo el dato anterior 
           --en la casilla actual
            when Vaciar_casilla =>
                p_we <= (others => '1');
                p_din <= dato_ant;
                p_ADDR <= std_logic_vector(posy & posx);
                if cont = Max_cont then
                    p_estado <= Actualiza_posicion;
                    p_cont <= (others => '0');
                    p_we <= (others => '0');
                else
                    p_cont <= cont + 1;
                end if;
            
            --Actualiza_posicion: Doy nuevos valores a la posición del fantasma1 en funcion la dirección
            when Actualiza_posicion =>
                if (last_udlr = "1000") then
                    p_posy <= posy - 1;
                    p_posx <= posx;
                elsif (last_udlr = "0100") then
                    p_posy <= posy + 1;
                    p_posx <= posx;
                elsif (last_udlr = "0010") then
                    p_posy <= posy;
                    p_posx <= posx - 1;
                elsif (last_udlr = "0001") then
                    p_posy <= posy;
                    p_posx <= posx + 1;
                else
                    p_posy <= posy;
                    p_posx <= posx;
                end if;
                p_estado <= Mover;
            
            --Mover: Activo escritura en memoria y pinto el fantasma2 en la nueva posicion
            when Mover =>
                    p_we <= (others => '1');
                    p_dato_ant <= dato_prox;
                    p_ADDR <= std_logic_vector(posy & posx);
                    p_din <= "101";
                    p_donef <= '1';
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