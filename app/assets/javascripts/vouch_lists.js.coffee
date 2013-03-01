$ ->
  firstTime = true

  $("#add_restaurant").on "click", (e) ->
    e.preventDefault()
    name = $("#typed_restaurant_name").val()

    if (name == "")
      $(".restaurant-input-error").html("Please enter a restaurant name.")
      $(".restaurant-input-error").fadeIn("fast")
      return;

    $(".restaurant-input-error").fadeOut("fast")

    if (firstTime == true)
      # Make a new list!
      console.log "make a new list"

    # Add item to the list
    $.ajax '/businesses/' + CITY + "/" + name + "/details",
      type: 'post'
      dataType: 'json'
      beforeSend: ->
        $(".loading-image").show()
      success: (data, status, xhr) ->
        new_tr = "<tr>" +
                 "<td>" + data['business']['name'] + "</td>" +
                 "<td>" + data['business']['neighborhood']   + "</td>" +
                 "<td>" + data['business']['city'] + "</td>" +
                 "<td>" + data['business']['yelp_rating']    + "</td>" +
                 "<td>" + data['business']['yelp_review_count'] + "</td>" +
                 "</tr>"
        $(".restaurants-table tr:last").after(new_tr)
        $("#typed_restaurant_name").val('')

        if (firstTime == true)
          $(".restaurant-placeholder").remove()
          firstTime = false
      error: (xhr, status, error) ->
        $(".list-errors").html("Errors: " + error)
        $(".list-errors").fadeIn("fast")
      complete: ->
        $(".loading-image").hide()


  $(".submit-list").on "click", (e) ->
    # Do some error checking    
