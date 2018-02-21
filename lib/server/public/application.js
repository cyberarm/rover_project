var subscribed = false;
var eventStream;

function handleEvent(event) {
  data = JSON.parse(event.data);
  var program = document.getElementById("program");
  var action_button = document.getElementById("action_button_text");
  var telemetry = document.getElementById("telemetry");
  if (data.active_program) {
    action_button.innerHTML = "STOP"
    program.value = data.active_program
    telemetry.innerHTML = data.telemetry
  } else {
    action_button.innerHTML = "Start"
    telemetry.innerHTML = "No Active Program. <br />Therefore No Data."
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
      eventStream.close;
      eventStream= false;
      subscribed = false;
      document.getElementById("action_button_text").innerHTML = "ERROR";
      document.getElementById("telemetry").innerHTML = "Connection error, not connected to server.";
      subscribe();
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
