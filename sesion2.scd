// =====================================================================
// SuperCollider - Laboratorio de Musica Libre, Rancho Electrónico
// Sesion2 - Agosto 2015
// =====================================================================

s.boot;

// SynthDef es la definición de un sintetizador
// Formas de onda básicas  ruido

// Sine
(
SynthDef(\sin,{|frec=400, vol=0.5, pan=0, at=0.1, rel=1|
	var sen, paneo, env;
	sen=SinOsc.ar(frec,0,vol); // segundo argumento es fase
	paneo=Pan2.ar(sen,pan); // pan es panorámico, lado izquierdo -1, lado derecho 1
	env=EnvGen.kr(Env.perc(at,rel),doneAction:2);
Out.ar(0, paneo*env);
}).add
);

Synth(\sin); // para llamar al SynthDef

Synth(\sin,[\frec, 880]); // llama al SynthDef y cambia valores de argumentos

// Triangular
(
SynthDef(\tri,{|frec=400, vol=0.5, pan=0, at=0.1, rel=1|
	var sen, paneo, env;
	sen=LFTri.ar(frec,0,vol); // segundo argumento es fase
	paneo=Pan2.ar(sen,pan);
	env=EnvGen.kr(Env.perc(at,rel),doneAction:2);
Out.ar(0, paneo*env);
}).add
);

Synth(\tri);

// Cuadrada
(
SynthDef(\pulse,{|frec=400, pw=0.1, vol=0.5, pan=0, at=0.1, rel=1|
	var sen, paneo, env;
	sen=Pulse.ar(frec,pw,vol); // segundo argumento es ancho de pulso (0.1-0.5)
	paneo=Pan2.ar(sen,pan);
	env=EnvGen.kr(Env.perc(at,rel),doneAction:2);
Out.ar(0, paneo*env);
}).add
);

Synth(\pulse);

Synth(\pulse, [\frec, 300, \pw, 0.5])

// Diente de sierra
(
SynthDef(\saw,{|frec=400, vol=0.5, pan=0, at=0.1, rel=1|
	var sen, paneo, env;
	sen=Saw.ar(frec,vol);
	paneo=Pan2.ar(sen,pan);
	env=EnvGen.kr(Env.perc(at,rel),doneAction:2);
Out.ar(0, paneo*env);
}).add
);

Synth(\saw);

// Ruido blanco
(
SynthDef(\ruido,{|vol=0.5, pan=0, at=0.1, rel=1|
	var sen, paneo, env;
	sen=WhiteNoise.ar(vol);
	paneo=Pan2.ar(sen,pan);
	env=EnvGen.kr(Env.perc(at,rel),doneAction:2);
Out.ar(0, paneo*env);
}).add
);

Synth(\ruido);

// Secuenciar con Patterns (patrones)
// Usamos Pdef, definición de patrones para modificar sin parar 
// Pbind usa una combinación de llave-valor, \volumen, 0.1 para combinar flujos de datos
// un Patrón usa una lista y un número de veces en que obtendrá valores de la lista
// lista es: [100,200,400,500]

Pseq([200,400,500],2); // lee la lista dos veces en un orden definido
Prand([200,300,400],inf); // lee la lista infinitamente en un orden aleatorio

(
~sin=Pdef(\sin, Pbind(\instrument, \sin,
	\dur, Pseq([0.25, 0.5, 1, 0.5],inf), // duracion (ritmo)
	\frec, Pseq([200, 400, 900],inf), // frecuencia
	\pan, Prand([-1,0,1],inf), // izquierda,centro,derecha
	\at, 0.01,
	\rel, 0.5
))
);

// control del Pdef
~sin.play.quant_(4); // usamos quant para sincronizar los patrones
~sin.stop;

// grabar resultado, ver el archivo sesion1.scd para explicacion
s.makeGui;
thisProcess.platform.recordingsDir;
s.recHeaderFormat="WAV";
s.recSampleFormat="int16";
