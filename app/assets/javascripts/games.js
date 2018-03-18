$(document).on('turbolinks:load', function() { 
    $("#scenario-select").select2({
    theme: "bootstrap",
    placeholder: "Please pick a scenario",
    selectOnClose: true
    }); 
});
$(document).on('turbolinks:load', function() { 
    $("#player-select-1").select2({
    theme: "bootstrap",
    placeholder: "Please pick a player",
    selectOnClose: true
    }); 
});
$(document).on('turbolinks:load', function() { 
    $("#player-select-2").select2({
    theme: "bootstrap",
    placeholder: "Please pick a player",
    selectOnClose: true
    }); 
});

