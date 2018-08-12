let userSelectBuilder = function (element, otherElement) {
  $(element).select2({
    selectOnClose: true,
    theme: 'bootstrap',
    width: '50%',
    minimumInputLength: 2,
    ajax: {
      url: '/users/find',
      dataType: 'json',
      type: "GET",
      delay: 250,
      data: function (params) {
        return {
          search: params.term,
          exclude: getPlayerId(otherElement)
        };
      },
      processResults: resultsProcessor
    }
  });
};

let resultsProcessor = function (data) {
  return {
    results: $.map(data, function(item) {
      return {
        text: item.full_name,
        id: item.id
      };
    })
  };
};

let getPlayerId = function(element) {
  return $(element)[0].value;
};

let formatScenario = function (scenario) {
  return `${scenario.name}`
};

$(document).on('turbolinks:load', function() { 
  $("#scenario-select").select2({
    theme: "bootstrap",
    placeholder: "Please pick a scenario",
    selectOnClose: true,
    minimumInputLength: 2,
//    templateResult: formatScenario,
    ajax: {
      url: '/scenarios/find',
      dataType: 'json',
      type: "GET",
      delay: 250,
      data: function (params) {
        return {
          search: params.term,
        };
      },
      processResults: function (data) {
        return {
          results: $.map(data, function (item) {
            return {
              text: item.name,
              id: item.id
            }
          })
        };
      }
    }
  });
});

$(document).on('turbolinks:load', function() { 
    $("#scenario-select2").select2({
    theme: "bootstrap",
    placeholder: "Please pick a scenario",
    selectOnClose: true
    }); 
});

$(document).on("change", "#scenario-select", function(){
  userSelectBuilder("#player-select-0", "#player-select-1");
  userSelectBuilder("#player-select-1", "#player-select-0");
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


