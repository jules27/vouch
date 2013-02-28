$ ->
  $("#add_restaurant").on "click", (e) ->
    e.preventDefault()
    name = $("#typed_restaurant_name").val()
    if (name == "")
      console.log "no input"
      return;
    console.log "name is " + name
