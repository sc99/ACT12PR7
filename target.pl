:- dynamic(conocido/1).
:- use_module(library(js)).
:- use_module(library(dom)).

alert(Text) :-
    prop(alert, Alert),
    apply(Alert, [Text], _).

conocimiento('sarampion',
   ['el paciente esta cubierto de puntos','el paciente tiene temperatura alta',
    'el paciente tiene ojos rojos','el paciente tiene tos seca']).
    
conocimiento('influenza',
   ['el paciente tiene dolor en las articulaciones','el paciente tiene mucho estornudo',
    'el paciente tiene dolor de cabeza']).

conocimiento('malaria',
   ['el paciente tiene temperatura alta','el paciente tiene dolor en las articulaciones',
    'el paciente tiembla violentamente', 'el paciente tiene escalofrios']).

conocimiento('gripe',
   ['el paciente tiene cuerpo cortado', 'el paciente tiene dolor de cabeza',
    'el paciente tiene temparatura alta']).

conocimiento('tifoidea',
   ['el paciente tiene falta de apetito', 'el paciente tiene temperatura alta',
    'el paciente tiene dolor abdominal', 'el paciente tiene dolor de cabeza',
    'el paciente tiene diarrea']).
    
conocimiento('covid',
   ['el paciente tiene tos seca', 'el paciente tiene dolor de cabeza',
    'el paciente tiene temperatura alta', 'el paciente tiene dificultad para respirar',
    'el paciente tiene perdida del gusto y olfato']).


consulta:- 
          haz_diagnostico(X),
          escribe_diagnostico(X),
          ofrece_explicacion_diagnostico(X),
          clean_scratchpad.
consulta:-
        prop(writeDiagnosis,WriteDiagnosis),
        apply(WriteDiagnosis,['UNKNOWN_DIAGNOSIS'],_).
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

pregunta_sobre(Diagnosis,Sintoma,Reply):- 
          atom_concat('Es verdad que ',Sintoma,T),
          atom_concat(T, '?',X),
          prop(readResponseOf,ReadResponseOf),
          apply(ReadResponseOf,[X],Respuesta),
          process(Diagnosis,Sintoma,Respuesta,Reply).
          
process(_Diagnosis,Sintoma,si,si):- asserta(conocido(Sintoma)).
process(_Diagnosis,Sintoma,no,no):- asserta(conocido(is_false(Sintoma))).
process(Diagnosis,Sintoma,porque,Reply):- 
          atom_concat('Estoy investigando la hipotesis siguiente: ',Diagnosis, T1),
          atom_concat(T1,'.',T2),
          atom_concat(T2,'\n Para esto necesito saber si: ',T3),
          atom_concat(T3,Sintoma,T4),
          atom_concat(T4,'.',T5),
          alert(T5),
          pregunta_sobre(Diagnosis,Sintoma,Reply).

process(Diagnosis,Sintoma,Respuesta,Reply):- Respuesta \== no,
          Respuesta \== si, Respuesta \== porque,
          alert('Debes contestar si, no o porque.'),
          pregunta_sobre(Diagnosis,Sintoma,Reply).

escribe_diagnostico(Diagnosis):- 
          atom_concat('El diagnóstico es: ',Diagnosis,D),
          prop(writeDiagnosis,WriteDiagnosis),
          apply(WriteDiagnosis,[D],_).
          
ofrece_explicacion_diagnostico(Diagnosis):-
          pregunta_si_necesita_explicacion(Respuesta),
          actua_consecuentemente(Diagnosis,Respuesta).

pregunta_si_necesita_explicacion(Respuesta):-
            prop(readResponseOf,ReadResponseOf),
            apply(ReadResponseOf,['Quieres que justifique este diagnóstico?'],RespuestaUsuario),
            asegura_respuesta_si_o_no(RespuestaUsuario,Respuesta).

asegura_respuesta_si_o_no(si,si).
asegura_respuesta_si_o_no(no,no).
asegura_respuesta_si_o_no(_,Respuesta):- 
            alert('Debes contestar sí o no.'),
          pregunta_si_necesita_explicacion(Respuesta).

actua_consecuentemente(_Diagnosis ,no).
actua_consecuentemente(Diagnosis,si):- conocimiento(Diagnosis,ListaDeSintomas),
          prop(addJustifyDiagnosisHeader,AddJustifyDiagnosisHeader),
          apply(AddJustifyDiagnosisHeader,['Se determino este diagnostico porque se encontraron los siguentes sintomas: '],_),
          %alert(''),
          escribe_lista_de_sintomas(ListaDeSintomas).

escribe_lista_de_sintomas([]).
escribe_lista_de_sintomas([Head|Tail]):-
            prop(writeSyntom,WriteSyntom),
            apply(WriteSyntom,[Head],_),
            %alert(Head),
            escribe_lista_de_sintomas(Tail).

clean_scratchpad:- retract(conocido(_X)), fail.
clean_scratchpad.
conocido(_):- fail.
not(X):- X,!,fail.
not(_). 
