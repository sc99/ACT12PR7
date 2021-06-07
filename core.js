$(function(){
    $(document).keypress(function(e){
        if(e.which == 13 && e.shiftKey){
                showAnswer()
        }
    });
});
let session;

function successMessage(title,text){
    Swal.fire(title,text,'success');
}

function warningMessage(title,text){
    Swal.fire(title,text,'warning');
}

function handleError(err,message){
    console.log(err);
    warningMessage('Prolog',message);
}

function loadProlog(){
    session = pl.create();
    session.consult("diagnostico.pl", {
        success: function(){ successMessage('Prolog','Conexión realizada exitosamente a diagnostico')},
        error: function(err){ handleError(err,'Ocurrió un error al cargar la conexión')}
    });
    
    session.consult("BaseConocimientos.pl", {
        success: function(){ successMessage('Prolog','Conexión realizada exitosamente a la base de conocimiento')},
        error: function(err){ handleError(err,'Ocurrió un error al cargar la conexión')}
    });
}

function processAnswer(answer){
    $("#prologResult").append(session.format_answer(answer));
    $("#prologResult").append("<br>");
    
}

function canAnswer(){
    let goal = $("#goalInput").val();
    if(goal == "" || goal == null){
        warningMessage("Goal","Debes escribir una meta");
        return false;
    }
    if(goal.match(/^.*\.$/) == null){
        warningMessage("Goal", "La meta debe terminar con el caracter '.'");
        return false;
    }
    return true;
}

function showAnswer(){
    if(canAnswer()){
        session.answer({
            success: function(answer){ console.log(answer);processAnswer(answer);},
            fail: function(){console.log('fail'); Swal.fire('Son todas las respuestas')},
            error: function(err){console.log('error'); handleError(err,'Ocurrió un error al procesar las respuestas')},
            limit: function(){ console.log('limit');Swal.fire('Límite excedido')}
        });
    }
}

function runGoal(){
    $("#goalButton").blur();
    let goal = $("#goalInput").val();
    session.query(goal,{
        success: function(goal){ showAnswer()},
        error: function(err){handleError(err,'Ocurrió un error al cargar la consulta')}
    })
}