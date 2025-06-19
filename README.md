# 🎮 **Pac-Man en FPGA** 🎮

## 🌟 Descripción
Este repositorio contiene el código y los archivos necesarios para implementar el clásico **videojuego Pac-Man** en una **FPGA**. El proyecto fue realizado entre 3 compañeros como parte de una asignatura, donde los profesores proporcionaban la estructura básica y nosotros debíamos escribir el código necesario para cada bloque. 

El diseño incluye:
- Lógica del juego (movimiento de Pac-Man, fantasmas, recogida de puntos y colisiones) 🏃‍♂️👻
- Gestión del sistema de visualización 🖥️
- Control de entradas 🎮

El objetivo de este proyecto es utilizar la arquitectura de la FPGA para garantizar un funcionamiento eficiente y rápido. 🚀

## 📋 Requisitos
- **FPGA**: El diseño ha sido probado en dispositivos **Xilinx** 🔧.
- **Lenguaje**: El código está escrito en **VHDL** ✍️.
- **Pantalla**: Se puede usar un monitor **VGA** 💻.
- **Entradas**: Se utilizan los propios botones de la **FPGA** para controlar el videojuego 🎮.
- **Herramientas de desarrollo**:
  - **Xilinx Vivado** ⚙️.
  - **Vivado Simulator** para simular el diseño 🧪.

## 📂 Estructura del Proyecto
La estructura de los archivos del proyecto es la siguiente:

### 1. **divisor_mov.vhd** ⏱️
  - Este archivo VHDL describe un divisor de frecuencia para manejar las señales temporales dentro del sistema de control de movimiento.

### 2. **frec_pixel.vhd** 🔄
  - Bloque que asegura que los personajes se muevan con una velocidad adecuada al generar una señal tras un número de ciclos de reloj.

### 3. **gestion_botones.vhd** 🎮
  - Archivo que maneja la entrada de botones para controlar el personaje.

### 4. **maquina_cmc.vhd** 🤖
  - Implementación de una máquina de estados finitos que gestiona el control del Pac-Man.

### 5. **maquina_fantasma.vhd** 👻
  - Máquina de estados que simula el movimiento de un fantasma con un comportamiento predefinido.

### 6. **maquina_fantasma_2.vhd** 👻
  - Segunda máquina de estados que simula otro fantasma con movimiento predefinido.

### 7. **SUPERIOR.vhd** 🧩
  - Interconecta todos los bloques del proyecto mediante señales.

### 8. **VGA_driver.vhd** 🖥️
  - Permite representar los colores de los píxeles en la pantalla.

### 9. **acceso_mem.vhd** 💾
  - Establece una jerarquía entre Pac-Man y los fantasmas para acceder a la memoria.

### 10. **comparador.vhd** 🔄
  - Actualiza la pantalla.

### 11. **dibuja.vhd** 🎨
  - Pinta los diferentes elementos del tablero en pantalla.

---
