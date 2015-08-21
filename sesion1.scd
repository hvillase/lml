// =====================================================================
// SuperCollider - Laboratorio de Musica Libre, Rancho Electrónico
// Sesion1 - Agosto 2015
// =====================================================================

// Instalar SuperCollider

// SuperCollider es una herramienta para programar sonido con código.
// Esta compuesto por tres partes:
// sclang: es el lenguaje de programación, el código que escribes.
// scsynth: es el motor de sintesis, recibe paquetes de datos por osc (open sound control).
// ide: es lo que ves en la pantalla de tu compu, está dividida en el espacio de trabajo, la ayuda y la ventana post la cual informa el estado del programa y los errores.


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
// fase: donde empieza la onda
// amplitud en forma de multiplicación: volumen. Rango normalizado de 0 a 1

// podemos decir que al hablar de sonido hay dos campos
// físico: objetivo, cuantitativo. Frecuencia en Herzt y amplitud en decibeles de presión sonora
// psicológico: subjetivo, caulitativo. Altura (agudo, grave) y sonoridad (bajo, fuerte)

// volviendo al lenguaje de supercollider algunos caracteres que nos indican algo acerca de la sintáxis
// comentario corto
/* comentario largooooooooooooooooooo */
() argumentos y encapsulado de código
[] arreglos
{} funciones
Objeto: SinOsc
variable global: a
~variable de ambiente: ~algo
.mensaje: .ar
\nombre
"palabras"
, separa argumentos
; rompe línea de código

// Cómo usar la ayuda
Help.gui

// Programando como Función
{LFTri.ar(500,0,0.5)}.play
{Saw.ar(200,0.2)!2}.play
{Pulse.ar(60,0.5,0.2)!2}.play
{Pulse.ar(MouseX.kr(20,60),0.5,0.2)!2}.play

// Visualizamos la onda con la ayuda de scope
{LFTri.ar(500,0,0.5)}.scope
{Pulse.ar(MouseX.kr(20,60),MouseY.kr(0.01,0.5),0.2)!2}.scope
{SinOsc.ar(MouseX.kr(100,1000),0,0.2)!2}.scope

// diferencia entre ar y kr
ar son mensajes de audio: señal
kr son mensajes de control: modulación

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

{SinOsc.ar(300,0,0.5)*LFNoise0.ar(3)!2}.play

// argumentos externos y variables
a=10;
a
a={SinOsc.ar(300,0,0.5)*LFNoise0.ar(3)!2}
a.play

a={|imp=3|SinOsc.ar(300,0,0.5)*LFNoise0.ar(imp)!2}.play
a.set(\imp,4)

b={|imp=3,frec=300|SinOsc.ar(frec,0,0.2)*LFNoise0.ar(imp)!2}.play
b.set(\imp,8,\frec,500)

// Ejemplos con envolvente

// Line como envolvente
{Pulse.ar(MouseX.kr(20,60),MouseY.kr(0.01,0.5),0.2)*Line.kr(1,0,0.4,doneAction:2)!2}.play

//Envolvente percusivo
{Pulse.ar(10,0.5,0.2)*EnvGen.kr(Env.perc(0.1,0.4),doneAction:2)!2}.play

// Modificar código mientras corre con Ndef

Ndef(\uno).play
Ndef(\uno,{LFTri.ar(250,0,0.25)!2});
Ndef(\uno).stop

Ndef(\uno).fadeTime=2

Ndef(\dos).play
Ndef(\dos,{|frec=300|LFTri.ar(frec,0,0.3)!2})
Ndef(\dos).set(\frec,400);

// secuencias con Tdef
Tdef(\y,{"hola".postln})
Tdef(\y).play

Tdef(\y,{10.do{"hola".postln}})

Tdef(\y,{20.do{"hola".scramble.postln;0.25.wait}})

// con sonido

// prendo Ndef(\tres) sin no esta sonando
Ndef(\tres).play
Ndef(\tres,{|frec=300|LFTri.ar(frec,0,0.3)!3})

Tdef(\frec,{100.do{Ndef(\tres).set(\frec,100.rrand(200));0.125.wait}});
Tdef(\frec).play

// apago Ndef(\tres)
Ndef(\tres).stop

// ejemplos de secuencias con Tdef
(
Tdef(\frec,{
1.do{Ndef(\tres).play;0.5};
100.do{Ndef(\tres).set(\frec,100.rrand(200));0.125.wait};
1.do{Ndef(\tres).stop;0.1.wait};
});
);

(// parentesis encapsulan código
Ndef(\cuatro,{|frec=200,pwm=0.1,amp=0.5|Pulse.ar(frec,pwm,amp)!2}); // declaro el Ndef

Tdef(\secuencia,{
	1.do{Ndef(\cuatro).play;0.5.wait}; // activo el Ndef y espero 0.5 segundos
	100.do{Ndef(\cuatro).set(\frec,200.rrand(800),\pwd,0.1.rrand(0.5),\amp,0.1.rrand(0.5));0.125.wait}; // le mando diversos mensajes aleatorios
	1.do{Ndef(\cuatro).stop;0.1.wait} // apago el ndef
})
)

// control
Tdef(\secuencia).play
Tdef(\secuencia).stop

// notas midi y envolvente

Ndef(\cinco).play
Ndef(\cinco,{|frec=60,vol=0.5,at=0.01,rel=0.7|Saw.ar(frec,vol)*EnvGen.kr(Env.perc(at,rel),doneAction:2)!2});
Ndef(\cinco).spawn
Ndef(\cinco).spawn([\frec,62])
Ndef(\cinco).spawn([\frec,62.midicps]) // con midicps la frecuencia 62 se convierte en re

Tdef(\midi).play

(
Tdef(\midi,{
4.do{Ndef(\cinco).spawn([\frec,[60,62,64,65].choose.midicps]);0.125.wait};
1.do{Ndef(\cinco).spawn([\frec,62.midicps]);0.5.wait};
})
);

// en loop
(
Tdef(\midi,{
loop{
4.do{Ndef(\cinco).spawn([\frec,[60,62,64,65].choose.midicps]);0.125.wait};
1.do{Ndef(\cinco).spawn([\frec,62.midicps]);0.5.wait};
}
})
);

// usando todas los argumentos de entrada
(
Tdef(\midi,{
loop{
1.do{Ndef(\cinco).spawn([\frec,60.midicps,\vol,0.2,\at,0.05,\rel,0.1]);0.5.wait};
1.do{Ndef(\cinco).spawn([\frec,64.midicps,\vol,0.2,\at,0.05,\rel,0.3]);0.5.wait};
1.do{Ndef(\cinco).spawn([\frec,67.midicps,\vol,0.2,\at,0.05,\rel,0.2]);0.5.wait};
1.do{Ndef(\cinco).spawn([\frec,72.midicps,\vol,0.2,\at,0.05,\rel,0.9]);0.5.wait};
}
});
)

// Grabando el resultado
s.makeGui;
thisProcess.platform.recordingsDir;
thisProcess.platform.recordingsDir=("/home/hernani/Escritorio/");
s.recHeaderFormat="WAV";
s.recSampleFormat="int16";

// Cómo guardar mi documento
// Lo más conveniente es guardarlo con la extensión scd
// supercollider document, esto no s asegura que podremos abrirlo en otras plataformas