/* BaseConocimientos1: diagnosticos y sintomas
   Dominio: diagnostico medico. Trata los sintomas como una lista multi-elementos
*/

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
    


