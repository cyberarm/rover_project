var subscribed = false;
var eventStream;

function handleEvent(event) {
  data = JSON.parse(event.data);
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
  if (!subscribed && !eventStream) {
    eventStream = new EventSource('telemetry');
    subscribed = true

    eventStream.onopen = function(event) {console.log("Connected");};
    eventStream.onmessage = function(event) {handleEvent(event);};
    eventStream.onerror = function(event) {
      var action_button = document.getElementById("action_button_text");
      var telemetry = document.getElementById("telemetry");
      if (action_button.innerHTML !== "ERROR") {
        action_button.innerHTML = "ERROR";
      }
      var string = "Connection error, not connected to server."
      if (telemetry.innerHTML !== string) {
        telemetry.innerHTML = string;
      }
    };
  }
}

$( document ).ready(function() {
  console.log("Page loaded.");

  subscribe();;

  $(".action_button").click(function(){
    sendProgram();
  });
})
