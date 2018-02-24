var subscribed = false;
var eventStream;

function handleEvent(event) {
  console.log(event)
  data = JSON.parse(event);
  var program = document.getElementById("program");
  var action_button = document.getElementById("action_button_text");
  var telemetry = document.getElementById("telemetry");
  if (data.active_program) {
    if (action_button.innerHTML !== "STOP") {
      action_button.innerHTML = "STOP";
    }

    if (program.value != data.active_program) {
      program.value = data.active_program
    }

    if (telemetry.innerHTML != data.telemetry) {
      telemetry.innerHTML = data.telemetry
    }
  } else {
    if (action_button.innerHTML !== "Start") {
      action_button.innerHTML = "Start";
    }

    var string = "No Active Program. <br />Therefore No Data.";
    if (telemetry.innerHTML != string) {
      telemetry.innerHTML = string;
    }
  }
}

function sendProgram() {
  var program = document.getElementById("program"); // Jquery not working as expected...
  var action_button = document.getElementById("action_button_text");
  if (action_button.innerHTML === "STOP") {
    $.post({url: "/program", type: 'post', dataType: 'text', data: {stop: true}})
  } else {
    $.post({url: "/program", type: 'post', dataType: 'text', data: {program: program.value}})
  }
}

function subscribe() {
  window.setInterval(function() {
  $.get({
    url: "/telemetry",
    success: function( result ) {
      handleEvent(result);
    },
    dataType: "text"
  }).fail(function(jqXHR, textStatus, error) {
    console.log("Post Failed! jqXHR: "+jqXHR.status+", status: "+textStatus+" error: "+error)
    switch(jqXHR.status) {
      case 401:
        $("#telemetry").html( "Not authorized! Are you logged in? <a onclick='window.location.reload(true)'>Reload</a>" );
        break;
      case 403:
        $("#telemetry").html( "Not allowed! Are you logged in? <a onclick='window.location.reload(true)'>Reload</a>" );
        break;
      case 405:
        $("#telemetry").html( "Failed to receive new messages!" );
        break;
      case 500:
        $("#telemetry").html( "Internal Server Error! Try <a onclick='window.location.reload(true)'>reloading</a> the page." );
        break;
      case 502:
        $("#telemetry").html( "Bad Gateway! Server might be down for maintenance, try again later." );
        break;
      case 503:
        $("#telemetry").html( "Service Unavailable! Server might be down for maintenance, try again later." );
        break;
      }
    });
  }, 100);
}
//   eventStream.onerror = function(event) {
//     var action_button = document.getElementById("action_button_text");
//     var telemetry = document.getElementById("telemetry");
//     if (action_button.innerHTML !== "ERROR") {
//       action_button.innerHTML = "ERROR";
//     }
//     var string = "Connection error, not connected to server."
//     if (telemetry.innerHTML !== string) {
//       telemetry.innerHTML = string;
//     }
//   };
// }

$( document ).ready(function() {
  console.log("Page loaded.");

  subscribe();;

  $(".action_button").click(function(){
    sendProgram();
  });
})
