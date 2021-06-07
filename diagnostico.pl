/*  Sistema Experto: experto.pl
    Trata los sintomas como una lista. La cabeza es el diagnostico y la "cola"
    son los sintomas.
    Utiliza assert/1 para cambiar din�mica la base de conocimientos.
    Determina la verdad y falsedad de los sintomas conocidos.
    Puede contestar a las preguntas 'porque' e incluye capacidad de explicacion.
    Elimina dinamicamente las aseveraciones agregadas despues de cada consulta.
*/
:- dynamic conocido/1.
consulta:-
          haz_diagnostico(X),
          escribe_diagnostico(X),
          ofrece_explicacion_diagnostico(X),
          clean_scratchpad.
consulta:-
          write('No hay suficiente conocimiento para elaborar un diagnostico.'),
          clean_scratchpad.

haz_diagnostico(Diagnosis):-
          obten_hipotesis_y_sintomas(Diagnosis,ListaDeSintomas),
          prueba_presencia_de(Diagnosis,ListaDeSintomas).
          
obten_hipotesis_y_sintomas(Diagnosis,ListaDeSintomas):-
          conocimiento(Diagnosis,ListaDeSintomas).

prueba_presencia_de(_Diagnosis,[]).
prueba_presencia_de(Diagnosis,[Head|Tail]):- prueba_verdad_de(Diagnosis,Head),
          prueba_presencia_de(Diagnosis,Tail).
          
prueba_verdad_de(_Diagnosis,Sintoma):- conocido(Sintoma).
prueba_verdad_de(Diagnosis,Sintoma):- not(conocido(is_false(Sintoma))),
          pregunta_sobre(Diagnosis,Sintoma,Reply),Reply=si.

pregunta_sobre(Diagnosis,Sintoma,Reply):- write('Es verdad que '),
          write(Sintoma), write('? '),
          read(Respuesta), process(Diagnosis,Sintoma,Respuesta,Reply).
          
process(_Diagnosis,Sintoma,si,si):- asserta(conocido(Sintoma)).
process(_Diagnosis,Sintoma,no,no):- asserta(conocido(is_false(Sintoma))).
process(Diagnosis,Sintoma,porque,Reply):- nl,
          write('Estoy investigando la hipotesis siguiente: '),
          write(Diagnosis), write('.'), nl, write('Para esto necesito saber si '),
          write(Sintoma),write('.'),nl,pregunta_sobre(Diagnosis,Sintoma,Reply).
process(Diagnosis,Sintoma,Respuesta,Reply):- Respuesta \== no,
          Respuesta \== si, Respuesta \== porque, nl,
          write('Debes contestar si, no o porque.'), nl,
          pregunta_sobre(Diagnosis,Sintoma,Reply).

escribe_diagnostico(Diagnosis):- write('El diagnostico es '),
          write(Diagnosis), write('.'), nl.
          
ofrece_explicacion_diagnostico(Diagnosis):-
          pregunta_si_necesita_explicacion(Respuesta),
          actua_consecuentemente(Diagnosis,Respuesta).

pregunta_si_necesita_explicacion(Respuesta):-
          write('Quieres que justifique este diagnostico? '),
          read(RespuestaUsuario),
          asegura_respuesta_si_o_no(RespuestaUsuario,Respuesta).

asegura_respuesta_si_o_no(si,si).
asegura_respuesta_si_o_no(no,no).
asegura_respuesta_si_o_no(_,Respuesta):- write('Debes contestar si o no.'),
          pregunta_si_necesita_explicacion(Respuesta).

actua_consecuentemente(_Diagnosis ,no).
actua_consecuentemente(Diagnosis,si):- conocimiento(Diagnosis,ListaDeSintomas),
          write('Se determino este diagnostico porque se encontraron los siguentes sintomas: '),nl,
          escribe_lista_de_sintomas(ListaDeSintomas).

escribe_lista_de_sintomas([]).
escribe_lista_de_sintomas([Head|Tail]):-
          write(Head), nl, escribe_lista_de_sintomas(Tail).

clean_scratchpad:- retract(conocido(_X)), fail.
clean_scratchpad.
conocido(_):- fail.
not(X):- X,!,fail.
not(_).
% Prolog Code Here
