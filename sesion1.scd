// =====================================================================
// SuperCollider - Laboratorio de Musica Libre, Rancho Electrónico
// Sesion1 - Agosto 2015
// =====================================================================

// Instalar SuperCollider

// SuperCollider es una herramienta para programar sonido con código
// Esta compuesto por tres partes:
// sclang: es el lenguaje de programación, el código que escribes
// scsynth: es el motor de sintesis, recibe paquetes de datos por osc
// ide: es lo que ves en la pantalla de tu compu, esta dividida en el espacio de trabajo, la ayuda y la ventana post la cual informa el estad del programa y los errores


// primero prendemos supercollider
s.boot;

// primer sonido
{SinOsc.ar(400,0,0.5)}.play

// para para el sonido identifica como parar el interprete
ctrl + punto

// mismo sonido en dos bocinas
{SinOsc.ar(600,0,0.5)!2}.play

// notamos que el sonido tiene tres cifras entre parentesis que corresponde a:
// frecuencia: número de ciclos por segundo
// fase
// amplitud, en forma de multiplicación

// podemos decir que al hablar de sonido hay dos campos
// físico: objetivo, cuantitativo. Frecuencia en Herzt y amplitud en decibeles de presión sonora
// psicológico: subjetivo, caulitativo. Altura (agudo, grave) y sonoridad (bajo, fuerte)

// volviendo al lenguaje de supercollider algunos caracteres que nos indican algo acerca de la sintáxis
// comentario corto
/* comentario largooooooooooooooooooo */
() argumentos
[] arreglos
{} funciones
Objeto: SinOsc
variable: a
~variable: ~algo
.mensaje: .ar
\nombre
"palabras"

// Cómo usar la ayuda
Help.gui

// Programando como Función
{LFTri.ar(500,0,0.5)}.play

// Visualizamos
{LFTri.ar(500,0,0.5)}.scope

// UGens - Ondas y Ruidos
LFTri
SinOsc
Pulse
Saw
WhiteNoise
PinkNoise

// Moduladores
LFCub
LFSaw
LFNoise0

// Grabación del resultado
s.makeGui;
thisProcess.platform.recordingsDir;
thisProcess.platform.recordingsDir=("/home/hernani/Escritorio/");
s.recHeaderFormat="WAV";
s.recSampleFormat="int16";

// Modificar código mientras corre con Ndef

Ndef(\uno).play
Ndef(\uno,{LFTri.ar(500,0,0.5)});

Tdef(\x).play