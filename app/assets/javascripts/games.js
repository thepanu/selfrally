$(document).on('turbolinks:load', function() { 
    $("#scenario-select").select2({
    theme: "bootstrap",
    placeholder: "Please pick a scenario",
    selectOnClose: true
    }); 
});
$(document).on('turbolinks:load', function() { 
    $("#player-select-0").select2({
    theme: "bootstrap",
    placeholder: "Please pick a player",
    selectOnClose: true,
    width: '75%'
    }); 
});
$(document).on('turbolinks:load', function() { 
    $("#player-select-1").select2({
    theme: "bootstrap",
    placeholder: "Please pick a player",
    selectOnClose: true,
    width: '75%'
    }); 
});
$(document).on("change", "#scenario-select", function(){
  var scenario_id = $(this).val();
  $.ajax({
        url: "/games/update_players",
        method: "GET",  
        dataType: "json",
        data: {scenario_id: scenario_id},
    error: function (xhr, status, error) {
            console.error('AJAX Error: ' + status + error);
          
    },
    success: function (response) {
      $("#force-name-0").html(response["0"]["name"])
      $("#force-name-1").html(response["1"]["name"])
      $("#game_game_players_attributes_0_force_id")[0].value = response["0"]["id"]
      $("#game_game_players_attributes_1_force_id")[0].value = response["1"]["id"]
      $("#forces")[0].className = "d-sm-block"
    }
  });
});

