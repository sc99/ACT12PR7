$(function(){
    $(document).keypress(function(e){
        if(e.which == 13 && e.shiftKey){
                showAnswer()
        }
    });
});
let session;
let syntoms = [];
let mustShowSyntoms = false;
let hasExecutedOnce = false;

var addJustifyDiagnosisHeader = function(header){
    $("#justificationHeader").html(header);
};

var readResponseOf = function(question){
    let response = prompt(question + "\n (Debes contestar si, no o porque)");
    return response;
};

var writeDiagnosis = function(diagnosis){
    //console.log("WriteDiagnosis: "+diagnosis);
    if(diagnosis != 'UNKNOWN_DIAGNOSIS'){
        $("#prologResult").html("Diagnóstico exitoso");
        $("#diagnosis").html(diagnosis);
        mustShowSyntoms = true;
    }else
        showFailedDiagnosis();
};

var writeSyntomsHeader = function(header){
    //console.log("WriteSyntomsHeader: "+header);
    $("#syntomsHeader").html(header);
};

var writeSyntom = function(syntom){
    syntoms.push(syntom);
    console.log(syntoms);
};

function showSyntoms(){
    $("#syntoms").html("");
    syntoms.forEach(syntom => {
        $("#syntoms").append("<li>"+syntom+"</li>"); 
    });
}

function showFailedDiagnosis(){
    $("#prologResult").html("Algo salió mal");
}

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
    session.consult("target.pl", {
        success: function(){ successMessage('Diagnóstico Médico','Cuestionario de diagnóstico listo para ser contestado')},
        error: function(err){ handleError(err,'Ocurrió un error al cargar el cuestionario')}
    });
}

function processAnswer(answer){
    if(mustShowSyntoms)
        showSyntoms();
    syntoms = [];
}

function showAnswer(){
        session.answer({
            success: function(answer){ console.log(answer);processAnswer(answer);},
            fail: function(){console.log('fail'); Swal.fire('Son todas las respuestas')},
            error: function(err){console.log(err); handleError(err,'Ocurrió un error al procesar las respuestas')},
            limit: function(){ console.log('limit');Swal.fire('Límite excedido')}
        });
}

function startDiagnosis(){
    $("#justificationHeader").html("");
    $("#goalButton").blur();
    hasExecutedOnce = true;
    session.query("consulta.",{
        success: function(goal){ showAnswer()},
        error: function(err){handleError(err,'Ocurrió un error al iniciar la consulta')}
    })
}

function resetMedicalDiagnosisApp(){
    if(hasExecutedOnce){
        $("#resetDiagnosisButton").blur();
        session = null;
        loadProlog();
        $("#diagnosis").html("");
        $("#syntomsHeader").html("");
        $("#justificationHeader").html("");
        $("#syntoms").html("");
    }else
        warningMessage('Diagnóstico Médico','No puedes reiniciar el cuestionario sin haberlo hecho previamente');
}

