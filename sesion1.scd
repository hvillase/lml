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
{LFTri.ar(500,0,0.5)}.play;

{Saw.ar(200,0.2)!2}.play;

{Pulse.ar(60,0.5,0.2)!2}.play;

{Pulse.ar(MouseX.kr(20,60),0.5,0.2)!2}.play;

// Visualizamos la onda con la ayuda de scope
{LFTri.ar(500,0,0.5)}.scope;

{Pulse.ar(MouseX.kr(20,60),MouseY.kr(0.01,0.5),0.2)!2}.scope;

{SinOsc.ar(MouseX.kr(100,1000),0,0.2)!2}.scope;

// diferencia entre ar y kr
ar son mensajes de audio: señal
kr son mensajes de control: modulación

// UGens - Ondas y Ruidos, puedes sustituirlos en los ejemplos anteriores
LFTri
SinOsc
Pulse
Saw
WhiteNoise
PinkNoise

// Moduladores
LFCub
LFSaw
LFNoise0, LFNoise1, LFNoise2

{SinOsc.ar(300,0,0.5) * LFNoise0.ar(3)!2}.play;

// argumentos externos y variables
a=10; // variable globa a es igual a 10

a

a={SinOsc.ar(300,0,0.5)*LFNoise0.ar(3)!2}; // variable global a es igual a una función

a.play

a={|imp=3|SinOsc.ar(300,0,0.5)*LFNoise0.ar(imp)!2}.play; // variable global a es igua a una función

a.set(\imp,4); // mensaje .set dice: variable a cambia el valor del argumento \imp

b={|imp=3,frec=300|SinOsc.ar(frec,0,0.2)*LFNoise0.ar(imp)!2}.play; // ahora con dos argumentos

b.set(\imp,8, \frec,500); // cambia el valor de dos argumentos a la vez

// Ejemplos con envolvente (lo que hace que el sonido dure un tiempo determinado)

// Line como envolvente
{Pulse.ar(MouseX.kr(20,60),MouseY.kr(0.01,0.5),0.2)*Line.kr(1,0,0.4,doneAction:2)!2}.play;

// EnvGen como envolvente percusivo
{Pulse.ar(10,0.5,0.2)*EnvGen.kr(Env.perc(0.1,0.4),doneAction:2)!2}.play;

// Modificar código mientras corre con Ndef, declara linea por linea
// Pon play al Ndef, luego corre la segunda linea, ya que esta sonando cambia los valores internos y sin parar el sonido vuelve a declar la segunda linea de código

// ejemplo uno
Ndef(\uno).play; // inica el la definición de nodo (node definition = Ndef)

Ndef(\uno,{LFTri.ar(250, 0, 0.25)!2}); // esto es lo que suena en el nodo

Ndef(\uno).fadeTime=2; // crea un desvanecimiento entre valores

Ndef(\uno).stop; // para la actividad del nodo

// ejemplo dos, corre linea por linea
Ndef(\dos).play;

// esta liena la puedes modificar varias veces si parar el programa, cada cabmio o cabios que realices vuelvela a declarar
Ndef(\dos,{|frec=300|LFTri.ar(frec,0,0.3)!2});

Ndef(\dos).set(\frec,400); // manda un mensaje desde afuera

Ndef(\dos).stop; // para

// Secuencias con Tdef (tasl definition) o definición de tarea
// declara linea por linea, observa la ventana post
Tdef(\y,{"hola".postln});

Tdef(\y).play;

Tdef(\y,{10.do{"hola".postln}});

Tdef(\y,{20.do{"hola".scramble.postln;0.25.wait}});

// Tdef con sonido producido por Ndef

// ejemplo tres ------------------------------------------------------
// prendo Ndef(\tres) sin no esta sonando, declara liena por linea
Ndef(\tres).play; // prende el Ndef

Ndef(\tres,{|frec=300|LFTri.ar(frec,0,0.3)!3}); // suena el Ndef sin variar

Tdef(\frec,{100.do{Ndef(\tres).set(\frec,100.rrand(200));0.125.wait}}); // asigno la tarea de cambiar nota

Tdef(\frec).play; // prendo la tarea para cambiar nota

Ndef(\tres).stop; // deja de sonar

// Ejemplos de secuencias con Tdef
// ejemplo uno, requiere del Ndef anterior

Ndef(\tres,{|frec=300|LFTri.ar(frec,0,0.3)!3}); // declara esta linea primero

// luego selecciona todo este código y delcarlo, se prende y apaga solo
(
Tdef(\frec,{
1.do{Ndef(\tres).play;0.5};
100.do{Ndef(\tres).set(\frec,100.rrand(200));0.125.wait};
1.do{Ndef(\tres).stop;0.1.wait};
});
);

// ejemplo dos Ndef y Tdef al mismo tiempo

Ndef(\cuatro,{|frec=200,pwm=0.1,amp=0.5|Pulse.ar(frec,pwm,amp)!2}); // declara esta linea

// delclara to el código siguiente, todo lo que esta entre parentesis
(
Tdef(\secuencia,{
	1.do{Ndef(\cuatro).play;0.5.wait}; // activo el Ndef y espero 0.5 segundos
	100.do{Ndef(\cuatro).set(\frec,200.rrand(800),\pwd,0.1.rrand(0.5),\amp,0.1.rrand(0.5));0.125.wait}; // le mando diversos mensajes aleatorios
	1.do{Ndef(\cuatro).stop;0.1.wait} // apago el ndef
})
);

// control
Tdef(\secuencia).play // prendo la secuencia
Tdef(\secuencia).stop // apago la secuencia

// ejemplo tres
// Notas midi y envolvente, declara linea por linea

Ndef(\cinco).play;

Ndef(\cinco,{|frec=60,vol=0.5,at=0.01,rel=0.7|Saw.ar(frec,vol)*EnvGen.kr(Env.perc(at,rel),doneAction:2)!2});

Ndef(\cinco).spawn; // vuelve a generar sonido

Ndef(\cinco).spawn([\frec,62]); // cambia la frecuencia 62 herzt

Ndef(\cinco).spawn([\frec,62.midicps]); // con midicps la frecuencia 62 se convierte en la nota midi RE

Tdef(\midi).play; // prendo por adelantado la rutina

// declaro todo el código entre parentesis, suena 5 notas
(
Tdef(\midi,{
4.do{Ndef(\cinco).spawn([\frec,[60,62,64,65].choose.midicps]);0.125.wait};
1.do{Ndef(\cinco).spawn([\frec,62.midicps]);0.5.wait};
})
);

// delcarlo el código entre parentesis, debe sonra porque el Tdef midi esta activo
(
Tdef(\midi,{
loop{
4.do{Ndef(\cinco).spawn([\frec,[60,62,64,65].choose.midicps]);0.125.wait};
1.do{Ndef(\cinco).spawn([\frec,62.midicps]);0.5.wait};
}
})
);

Tdef(\midi).stop // para apagar el Tdef

// último ejemplo
// usando todas los argumentos de entrada;

Tdef(\midi2).play; // prendo nuevamente la tarea

// declaro todo el código entre parentesis, si no suena quiza necesitas volver a declarar el Ndef(\cinco) que esta arriba

// modifica los valores que quieras y sin parar vuelve a delcarar todo el código entre parentesis
// esto es una forma de hacer LiveCoding
(
Tdef(\midi2,{
loop{
1.do{Ndef(\cinco).spawn([\frec,[60,72].choose.midicps,\vol,0.3,\at,0.05,\rel,0.9]);0.1.wait};
1.do{Ndef(\cinco).spawn([\frec,62.midicps,\vol,0.35,\at,0.05,\rel,0.25]);0.1.wait};
1.do{Ndef(\cinco).spawn([\frec,65.midicps,\vol,0.6,\at,0.05,\rel,1.1]);0.1.wait};
1.do{Ndef(\cinco).spawn([\frec,71.midicps,\vol,0.2,\at,0.05,\rel,0.2]);0.1.wait};
1.do{Ndef(\cinco).spawn([\frec,69.midicps,\vol,0.3,\at,0.05,\rel,0.2]);0.1.wait};
1.do{Ndef(\cinco).spawn([\frec,64.midicps,\vol,0.35,\at,0.05,\rel,0.25]);0.1.wait};
1.do{Ndef(\cinco).spawn([\frec,67.midicps,\vol,0.6,\at,0.05,\rel,1.1]);0.1.wait};
1.do{Ndef(\cinco).spawn([\frec,71.midicps,\vol,0.2,\at,0.05,\rel,1.2]);0.1.wait};
}
});
)

// version escala akebono japonesa [62,64,65,69,70] = re,mi,fa,la,si-bemol
(
Tdef(\midi2,{
loop{
1.do{Ndef(\cinco).spawn([\frec,[62,74].choose.midicps,\vol,0.3,\at,0.05,\rel,2]);0.5.wait};
1.do{Ndef(\cinco).spawn([\frec,65.midicps,\vol,0.4,\at,0.05,\rel,2]);0.5.wait};
1.do{Ndef(\cinco).spawn([\frec,64.midicps,\vol,0.5,\at,0.05,\rel,2]);1.wait};
1.do{Ndef(\cinco).spawn([\frec,70.midicps,\vol,0.2,\at,0.05,\rel,2]);0.5.wait};
1.do{Ndef(\cinco).spawn([\frec,69.midicps,\vol,0.3,\at,0.05,\rel,2]);0.5.wait};
1.do{Ndef(\cinco).spawn([\frec,64.midicps,\vol,0.5,\at,0.05,\rel,2]);1.wait};
1.do{Ndef(\cinco).spawn([\frec,70.midicps,\vol,0.2,\at,0.05,\rel,2]);0.5.wait};
1.do{Ndef(\cinco).spawn([\frec,64.midicps,\vol,0.5,\at,0.05,\rel,1.5]);0.5.wait};
}
});
)

Tdef(\midi2).stop;

60.midicps = DO
62.midicps = RE
64.midicps = MI
65.midicps = FA
67.midicps = SOL
69.midicps = LA
71.midicps = SI
72.midicps = DO

// Grabando el resultado
s.makeGui; // se abre la venta localhost server
thisProcess.platform.recordingsDir; // te dice donde se guardaran tus sonidos
thisProcess.platform.recordingsDir=("/home/hernani/Escritorio/"); // tu le dices donde los quieres guardar
s.recHeaderFormat="WAV"; // cambia el formato a wav
s.recSampleFormat="int16"; // a 16 bits de resolución

// en la ventana localhost server hay un botón que dice recodr>, si lo presionas cambia a stop[] y comienza a grabar, para parar la grabación presionas stop[] y el sonido lo buscas en la ruta que le indicaste

// Cómo guardar mi documento de supercollider
// Lo más conveniente es guardarlo con la extensión scd (SuperCollider Document)
// Esto nos asegura que podremos abrirlo en distintas plataformas