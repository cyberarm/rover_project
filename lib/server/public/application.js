var lastProgramsList = [];

  function handleEvent(event) {
  // console.log(event)
  data = JSON.parse(event);
  var program = document.getElementById("program");
  var action_button = document.getElementById("action_button_text");
  var telemetry = document.getElementById("telemetry");
  if (data.active_program) {
    if (action_button.innerHTML !== "STOP") { action_button.innerHTML = "STOP" }
    if (program.value != data.active_program) { program.value = data.active_program }
    if (telemetry.innerHTML != data.telemetry) { telemetry.innerHTML = data.telemetry }
  } else {
    if (action_button.innerHTML !== "Start") { action_button.innerHTML = "Start" }

    var string = "No Active Program. <br />Therefore No Data.";
    if (telemetry.innerHTML !== string) { telemetry.innerHTML = string }
  }
  if (String(lastProgramsList) !== String(data.programs)) {
    $("#program").html("")
    $.each(data.programs, function (i, v) {
      $("#program").append($("<option>", { value: v, html: v }))
    })
    console.log("Updated programs list")
  }
  lastProgramsList = data.programs
}

function sendProgram() {
  var program = document.getElementById("program"); // Jquery not working as expected...
  var action_button = document.getElementById("action_button_text");
  if (action_button.innerHTML === "STOP") {
    $.post({url: "/program", type: 'post', dataType: 'text', data: {stop: true}})
  } else if ((action_button.innerHTML === "Start")) {
    $.post({url: "/program", type: 'post', dataType: 'text', data: {program: program.value}})
  } else {
    console.log("Not sending program request.")
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
    switch(jqXHR.status) {
      case 0:
      $("#action_button_text").html("ERROR");
        $("#telemetry").html( "Connection error, not connected to server." );
        break;
      }
    });
  }, 100);
}

$( document ).ready(function() {
  console.log("Page loaded.");

  subscribe();;

  $(".action_button").click(function(){
    sendProgram();
  });
})
