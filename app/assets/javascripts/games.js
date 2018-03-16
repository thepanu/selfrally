$(document).on('turbolinks:load', function() { 
    $("#scenario-select").select2({
    theme: "bootstrap",
    placeholder: "Please pick a  scenario"
    }); 
});
$(document).on('turbolinks:load', function() { 
    $("#status-select").select2({
    theme: "bootstrap",
    }); 
});

