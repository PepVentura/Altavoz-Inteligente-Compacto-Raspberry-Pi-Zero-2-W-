Guía Completa de Proyecto: Altavoz Inteligente Búho (Raspberry Pi Zero 2 W)
1. Visión General del Proyecto
Este proyecto consiste en la creación de un altavoz inteligente con diseño mecatrónico en forma de búho robotizado. Utiliza una Raspberry Pi Zero 2 W como unidad central de procesamiento, integración de audio digital I2S, anillos de LEDs WS2812B (Neopixel) para los ojos e integración con la API de Gemini para la interacción por voz.
Componente
Especificación / Modelo
Función
Cerebro
Raspberry Pi Zero 2 W
Procesamiento de voz local, conexión a la API de Gemini y control de periféricos.
Altavoz
Dayton Audio DMA45-4 (1.8", 4 Ω)
Reproducción de sonido de alta fidelidad en el cuerpo compacto.
Amplificador / DAC
MAX98357A (I2S, 5V)
Conversión de audio digital desde GPIO a señal analógica de potencia.
Iluminación / Ojos
2x Anillos Neopixel WS2812B
Feedback visual del estado del asistente (escuchando, pensando, respondiendo).
Carcasa
Impresión 3D (PLA / PETG)
Diseño estanco en forma de búho con lentes difusoras traslúcidas.

2. Esquema de Conexiones GPIO
A continuación se detalla el patillaje de conexión entre la Raspberry Pi Zero 2 W, el amplificador I2S y los anillos de LEDs Neopixel:
Componente
Pin en Módulo
Pin Físico Raspberry Pi
Función GPIO
MAX98357A
LRC / LRCK
Pin 35
GPIO 19 (PCM_FS)
MAX98357A
BCLK
Pin 12
GPIO 18 (PCM_CLK)
MAX98357A
DIN
Pin 40
GPIO 21 (PCM_DOUT)
MAX98357A
VIN / GND
Pin 2 (5V) / Pin 6 (GND)
Alimentación principal
Neopixel WS2812B
DIN
Pin 33
GPIO 13 (PWM1)

3. Paso a Paso: Configuración del Sistema Operativo y Audio I2S
Paso 1: Grabado de la Tarjeta MicroSD
Usar Raspberry Pi Imager para instalar Raspberry Pi OS Lite (64-bit).
Configurar el Hostname a buho-smart.
Activar SSH e introducir credenciales de acceso.
Configurar la red Wi-Fi de 2.4 GHz.
Paso 2: Instalar Dependencias del Sistema
sudo apt update && sudo apt upgrade -y
sudo apt install -y python3-pip python3-venv git alsa-utils libasound2-dev
Paso 3: Habilitar Driver I2S en el Firmware
Editar el archivo de configuración: sudo nano /boot/firmware/config.txt
Desactivar audio integrado comentando: # dtparam=audio=on
Añadir los parámetros de soporte I2S al final del archivo:
dtparam=i2s=on
dtoverlay=max98357a
Reiniciar la Raspberry Pi: sudo reboot
Paso 4: Verificación de Audio
# Comprobar tarjeta detectada
aplay -l

# Probar salida de altavoz
speaker-test -c 2 -twav -l 1
4. Código de Control Visual para los Ojos Neopixel (Python)
Guardar el siguiente script en src/led_controller.py para gestionar los efectos luminosos de los ojos según el estado del asistente:
import time
import board
import neopixel

NUM_LEDS = 24
pixels = neopixel.NeoPixel(board.D13, NUM_LEDS, brightness=0.4, auto_write=False)

def modo_reposo():
    pixels.fill((0, 20, 50))
    pixels.show()

def modo_escuchando():
    pixels.fill((0, 255, 150))
    pixels.show()

def modo_pensando_gemini():
    for i in range(NUM_LEDS):
        pixels.fill((0, 0, 0))
        pixels[i] = (0, 200, 255)
        pixels[(i + 1) % NUM_LEDS] = (150, 0, 255)
        pixels.show()
        time.sleep(0.05)

if __name__ == "__main__":
    modo_pensando_gemini()
5. Parámetros de Impresión 3D para Lentes Difusoras
Material: PLA Transparente o PETG Clear.
Relleno (Infill): 0% (Hueco).
Perímetros / Paredes: 3 a 4 líneas.
Grosor de capa: 0.12 mm o 0.16 mm.
Temperatura: 5 °C a 10 °C por encima del estándar del filamento.
