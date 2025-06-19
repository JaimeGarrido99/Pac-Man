----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 10.11.2024 18:51:15
-- Design Name: 
-- Module Name: SUPERIOR - Behavioral
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

entity SUPERIOR is
    Port ( RED : out STD_LOGIC_VECTOR (3 downto 0);
           GRN : out STD_LOGIC_VECTOR (3 downto 0);
           BLU : out STD_LOGIC_VECTOR (3 downto 0);
           clk : in STD_LOGIC;
           up :in STD_LOGIC;
           down:in STD_LOGIC;
           left:in STD_LOGIC;
           right:in STD_LOGIC;
           reset : in STD_LOGIC;
           VS : out STD_LOGIC;
           HS : out STD_LOGIC;
           DP : out STD_LOGIC;
           AN : out STD_LOGIC_VECTOR(3 downto 0);
           A : out STD_LOGIC;
           B : out STD_LOGIC;
           C : out STD_LOGIC;
           D : out STD_LOGIC;
           E : out STD_LOGIC;
           F : out STD_LOGIC;
           G : out STD_LOGIC
             );
end SUPERIOR;

architecture Behavioral of SUPERIOR is

component tabla_mem IS
  PORT (
   clka : IN STD_LOGIC;
    ena : IN STD_LOGIC;
    wea : IN STD_LOGIC_VECTOR(0 DOWNTO 0);
    addra : IN STD_LOGIC_VECTOR(8 DOWNTO 0);
    dina : IN STD_LOGIC_VECTOR(2 DOWNTO 0);
    douta : OUT STD_LOGIC_VECTOR(2 DOWNTO 0);
    clkb : IN STD_LOGIC;
    web : IN STD_LOGIC_VECTOR(0 DOWNTO 0);
    addrb : IN STD_LOGIC_VECTOR(8 DOWNTO 0);
    dinb : IN STD_LOGIC_VECTOR(2 DOWNTO 0);
    doutb : OUT STD_LOGIC_VECTOR(2 DOWNTO 0));
END component;

component acceso_mem is
        
 Port ( --Entradas comecocos
        addrc : in STD_LOGIC_VECTOR(8 DOWNTO 0);
        din_c : in STD_LOGIC_VECTOR(2 DOWNTO 0); 
        wec : in STD_LOGIC_VECTOR(0 DOWNTO 0);  
        enable_memc: in STD_LOGIC;
        doutc : out STD_LOGIC_VECTOR(2 DOWNTO 0);
    -- --Entrada a memoria
       addra : out STD_LOGIC_VECTOR(8 DOWNTO 0);
       din_a : out STD_LOGIC_VECTOR(2 DOWNTO 0);
       wea:out std_logic_vector(0 downto 0);
       doutac : in STD_LOGIC_VECTOR(2 DOWNTO 0);
       ena : out std_logic; 
     -- Entrada a fantasma
      addrf: in STD_LOGIC_VECTOR(8 DOWNTO 0);
      dinf : in STD_LOGIC_VECTOR(2 DOWNTO 0);
      wef : in STD_LOGIC_VECTOR(0 DOWNTO 0);
      enable_memf: in STD_LOGIC;
       doutaf : out STD_LOGIC_VECTOR(2 DOWNTO 0);
      --Entradas a fantasma2
       addrf2: in STD_LOGIC_VECTOR(8 DOWNTO 0);
      dinf2 : in STD_LOGIC_VECTOR(2 DOWNTO 0);
      wef2 : in STD_LOGIC_VECTOR(0 DOWNTO 0);
      enable_memf2: in STD_LOGIC;
       doutaf2 : out STD_LOGIC_VECTOR(2 DOWNTO 0)
 );
 
end component;

component VGA_driver is

    Port ( clk : in STD_LOGIC;
           reset : in STD_LOGIC;
           RGB_in: in STD_LOGIC_VECTOR (11 downto 0);
           VS : out STD_LOGIC;
           HS : out STD_LOGIC;
           RED_out : out STD_LOGIC_VECTOR (3 downto 0);
           GRN_out : out STD_LOGIC_VECTOR (3 downto 0);
           BLU_out: out STD_LOGIC_VECTOR (3 downto 0);
           ejex_out:out STD_LOGIC_VECTOR (9 downto 0);
           ejey_out:out STD_LOGIC_VECTOR (9 downto 0);
           refresh:out STD_LOGIC);
end component;

component dibuja is
    Port ( eje_x : in STD_LOGIC_VECTOR (9 downto 0);
    eje_y : in STD_LOGIC_VECTOR (9 downto 0);
    dout_b:in STD_LOGIC_VECTOR(2 DOWNTO 0);
    adde_b:out STD_LOGIC_VECTOR(8 downto 0);
    dout:in STD_LOGIC_VECTOR(11 downto 0);
    ADDR:out STD_LOGIC_VECTOR(13 DOWNTO 0);
    RGB:out STD_LOGIC_VECTOR(11 downto 0);
    posicion : in std_logic_vector(3 downto 0)
    );
end component;

component memoria_sprite IS
  PORT (
    clka : IN STD_LOGIC;
    addra : IN STD_LOGIC_VECTOR(13 DOWNTO 0);
    douta : OUT STD_LOGIC_VECTOR(11 DOWNTO 0)
  );
  end component;
  
  
  component maquina_cmc is
    PORT(clk: in STD_LOGIC;
        reset : in STD_LOGIC;
        movec : in STD_LOGIC; 
        udlr : in STD_LOGIC_VECTOR(3 DOWNTO 0);
        ADDR : out std_logic_vector(8 DOWNTO 0);
        doutc : in std_logic_vector(2 downto 0); 
        donec : out STD_LOGIC;
        din : out std_logic_vector(2 downto 0);
        wec: out STD_LOGIC_VECTOR(0 DOWNTO 0);
        enable_mem: out STD_LOGIC;
        come_bola : out std_logic;
        posicion : out std_logic_vector(3 downto 0)
        
        );     
    end component;
    
  component maquina_fantasma is
generic (Max_cont:integer:=12);
  Port (clk : in STD_LOGIC;
        reset : in STD_LOGIC; 
        movef : in STD_LOGIC; 
        ADDRf : out std_logic_vector(8 DOWNTO 0);
        doutf : in std_logic_vector(2 downto 0);
        donef : out STD_LOGIC;
        dinf : out std_logic_vector(2 downto 0);
        wef: out STD_LOGIC_VECTOR (0 DOWNTO 0);
        enable_memf: out STD_LOGIC);
        
end component;

component maquina_fantasma2 is
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
end component;

    
component movimiento_fantasma is
  Port(reset  : in  std_logic;
       clk    : in  std_logic;                    
       count  : out std_logic_vector (3 downto 0)
       );
  end component ;
    
    component  frec_pixel is
    Port ( clk : in STD_LOGIC;
           reset : in STD_LOGIC;
           clk_pixel : out STD_LOGIC);
end component;

   
    component divisor_mov is
    Port ( clk : in STD_LOGIC;
           reset : in STD_LOGIC;
           refresh : in std_logic;
           clk_pixel : out STD_LOGIC);
end component;



    component gestion_botones is 
     Port (udlr : out STD_LOGIC_VECTOR(3 DOWNTO 0);
      up : in STD_LOGIC;
      down : in STD_LOGIC;
      left : in STD_LOGIC;
      right : in STD_LOGIC 
           );
    end component;
    
    component puntos is
    Port ( clk : in STD_LOGIC;
           reset : in STD_LOGIC;
           punto : in STD_LOGIC;
           DP : out STD_LOGIC;
           AN : out STD_LOGIC_VECTOR(3 downto 0);
           A : out STD_LOGIC;
           B : out STD_LOGIC;
           C : out STD_LOGIC;
           D : out STD_LOGIC;
           E : out STD_LOGIC;
           F : out STD_LOGIC;
           G : out STD_LOGIC);
    end component;
    
    
-- Señales para la memoria
signal addra_s: STD_LOGIC_VECTOR(8 DOWNTO 0); --señal de direccion del puerto A de la tabla_mem
signal addrb_s: STD_LOGIC_VECTOR(8 DOWNTO 0); --señal de direccion del puerto B de la tabla_mem
signal doutb_s: STD_LOGIC_VECTOR(2 DOWNTO 0); --señal de salida del puerto B de la memoria
signal douta_s: STD_LOGIC_VECTOR(2 DOWNTO 0); --señal de salida del puerto A de la memoria
signal dina_s: STD_LOGIC_VECTOR(2 DOWNTO 0); --señal de entrada a memoria del puerto A de la memoria
signal ena_s, enb_s:STD_LOGIC; --señales de enable de la memoria 
signal wea_s:STD_LOGIC_VECTOR(0 DOWNTO 0); --señal de escribir en memoria del puuerto A de la memoria

-- Señales usadas en VGA_driver
signal RGB_s: std_logic_vector(11 downto 0);
signal ejex_s,ejey_s: std_logic_vector(9 downto 0);
signal dout_s:STD_LOGIC_VECTOR(11 downto 0); --Señal de datos para "dibuja" y "mem_sprite"
signal ADDR_s: STD_LOGIC_VECTOR(13 DOWNTO 0); -- Bus de direcciones para "dibuja" y "mem_sprite"
-- Señales para el divisor de frecuencia
signal refresh_s: STD_LOGIC; --Señal para conectar el VGA_Driver al divisor_mov 
signal div_refresh: std_logic; -- Señal para el divisor de frecuencia 

--Señales para el comecocos
signal comebola_s: STD_LOGIC;
signal enables_mem: STD_LOGIC;
signal udlr_s: STD_LOGIC_VECTOR(3 DOWNTO 0); --Bus para transmitir las direcciones
signal ADDRC_s: STD_LOGIC_VECTOR(8 DOWNTO 0); --Bus de direcciones del comecocos
signal doutc_s: STD_LOGIC_VECTOR(2 DOWNTO 0); -- Bus de datos del comecocos
signal din_s: STD_LOGIC_VECTOR(2 DOWNTO 0); -- Bus para enviar el dato a escribir
signal we_s:STD_LOGIC_VECTOR(0 DOWNTO 0); --Señal para activar la escritura en memoria
signal done_s:std_logic; -- Señal para comenzar el mov del f1

--Señales para el fantasma
signal addra_f: STD_LOGIC_VECTOR(8 DOWNTO 0); --Bus de direcciones del f1
signal douta_f: STD_LOGIC_VECTOR(2 DOWNTO 0); --Bus de datos
signal dina_f: STD_LOGIC_VECTOR(2 DOWNTO 0); --Bus para enviar el dato a escribir
signal wea_f:STD_LOGIC_VECTOR(0 DOWNTO 0); --Señal para escribir el dato en memoria
signal enables_memf: STD_LOGIC; --Señal para activar acceso a memoria
signal movf: std_logic_vector(3 DOWNTO 0); --Señal para comenzar a mover el f1
signal done_fs:std_logic; --Señal para indicar fin del mov del f1

--Señales para el fantasma 2
signal addra_f2: STD_LOGIC_VECTOR(8 DOWNTO 0);--Bus de direcciones del f2          
signal douta_f2: STD_LOGIC_VECTOR(2 DOWNTO 0);--Bus de datos                       
signal done_s2:std_logic;  --Señal para indicar fin del mov del f2                    
signal dina_f2: STD_LOGIC_VECTOR(2 DOWNTO 0); --Bus para enviar el dato a escribir
signal wea_f2:STD_LOGIC_VECTOR(0 DOWNTO 0); --Señal para escribir el dato en memoria                
signal enables_memf2: STD_LOGIC; --Señal para activar acceso a memoria          
signal movf2: std_logic_vector(3 DOWNTO 0); --Señal para comenzar a mover el f2                  
signal done_fs2:std_logic; --Señal para indicar fin del mov del f2

--Señales para los botones con la arquitectura superior
signal right_s : std_logic; --Señal mover izq
signal left_s : std_logic; --Señal mover dcha
signal up_s : std_logic; --Señal mover arriba
signal down_s : std_logic; -- Señal mover abajo
signal posicion_s : std_logic_vector(3 downto 0); --Señal auxiliar para rotar el pacman

begin

 frecuencia : divisor_mov
 port map(clk => clk,
          refresh => refresh_s, 
          reset => reset,
          clk_pixel => div_refresh
          );


memoria:tabla_mem
PORT MAP( clka=>clk, 
           ena=>ena_s,
           wea=>wea_s,
           addra=>addra_s,
           dina => dina_s, 
           douta=>douta_s,
           clkb =>clk,
           web => (others=>'0'),
           addrb => addrb_s,
           dinb => (others=>'0'),
           doutb=>doutb_s
           ); 
           
 vgadriver: VGA_driver
 PORT MAP(clk =>clk,
          reset=>reset,
          VS =>VS,
          HS =>HS,
          RGB_in =>RGB_s,
          RED_out=>RED,
          GRN_out=>GRN,
          BLU_out=>BLU,
          ejex_out=>ejex_s,
          ejey_out=>ejey_s,
          refresh=>refresh_s);

 dib: dibuja
 PORT MAP(eje_x=>ejex_s,
         eje_y=>ejey_s,
         RGB=>RGB_s,
         adde_b=>addrb_s,
         dout_b=>doutb_s,
         ADDR=>ADDR_s,
         dout=>dout_s,
         posicion => posicion_s
         );
    
mem_sprite: memoria_sprite
PORT MAP(clka=>clk,
        addra=>ADDR_s,
        douta=>dout_s);


maquina : maquina_cmc 
PORT MAP(clk=>clk,
     reset=>reset,
     ADDR => ADDRC_s,
     doutc => doutc_s,
     din => din_s,
     wec => we_s,
     movec => div_refresh,
     udlr => udlr_s,
     enable_mem => enables_mem,
     donec =>done_s,
     come_bola => comebola_s, 
     posicion => posicion_s
      );
      
 fantasma : maquina_fantasma
 PORT MAP(clk => clk,
        reset => reset,
        movef => done_s,
        ADDRf => addra_f,
        doutf => douta_f, 
        donef => done_fs,
        dinf  => dina_f,
        wef => wea_f,
        enable_memf => enables_memf
        );
        
   fantasma2: maquina_fantasma2
   PORT MAP(clk => clk,         
            reset => reset,      
            movef2 => done_fs,     
            ADDRf2 => addra_f2,     
            doutf2 => douta_f2,     
            donef2 => done_fs2,    
            dinf2  => dina_f2,     
            wef2 => wea_f2,       
            enable_memf2 => enables_memf2
            );     
        
           
movef : movimiento_fantasma
PORT MAP(reset => reset,
         clk => clk,
         count => movf
         
         );
           
gestion :  gestion_botones
PORT MAP(up=>up,
        down=>down,
        left=>left,
        right=>right,
        udlr=>udlr_s
         ); 
         

 accesomemoria: acceso_mem
 PORT MAP(   --Conexiones a memoria
        addra =>                    addra_s,
        din_a =>                    dina_s,
        wea =>                      wea_s,
        doutac =>                   douta_s,
        ena =>                      ena_s,
        --Conexiones a comecocos
        addrc =>                    ADDRC_s,
        din_c =>                    din_s,
        wec =>                      we_s,
        doutc =>                    doutc_s,
        enable_memc =>              enables_mem,
        --Conexiones a fantasma
         addrf =>                   addra_f,
         dinf =>                    dina_f,
         wef =>                     wea_f,
         enable_memf =>             enables_memf,
         doutaf =>                  douta_f,
         --Conexiones a fantasma
         addrf2 =>                   addra_f2,
         dinf2 =>                    dina_f2,
         wef2 =>                     wea_f2,
         enable_memf2 =>             enables_memf2,
         doutaf2 =>                  douta_f2
 
     );
     
     bolas : puntos
        port map(
            clk=>clk,
            reset=>reset,
            punto => comebola_s,
            DP=>dp,
            AN=>AN,
            A=>A,
            B=>B,
            C=>C,
            D=>D,
            E=>E,
            F=>F,
            G=>G
        );
     
     
     
     
    
end Behavioral;
