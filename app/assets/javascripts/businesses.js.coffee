$ ->
  $("#vouch_business_action").on "click", (e) ->
    e.preventDefault()
    currentElement = $(this)
    success = false
    vouch_item_id = ""

    currentElement.addClass("disabled")

    $.ajax '/vouch_items/',
      type:     'post'
      async:    false
      dataType: 'json'
      data: {
        id: $("#vouch_list_id").val(),
        vouch_item: {
          business_id: $("#business_id").val()
        }
      }
      success: (data, status, xhr) ->
        success = true
        vouch_item_id = data.vouch_item_id

    # Make another ajax call to manually add taggings for this item
    $.ajax '/vouch_items/' + vouch_item_id + '/add_tagging_from_business',
      type:     'post'
      async:    false
      dataType: 'json'
      data: {
        business_id: $("#business_id").val()
      }
      success: (data, status, xhr) ->
        console.log "Taggings added!"

    if (success == true)
      # Disable this button as well as the wish button
      currentElement.addClass("disabled")
      currentElement.html("Added To Vouch List!")
      $("#wish_business_action").addClass("disabled")
    else
      currentElement.removeClass("disabled")

  # Add this business to my wish list
  $("#wish_business_action").on "click", (e) ->
    e.preventDefault()
    currentElement = $(this)
    success = false

    currentElement.addClass("disabled")

    $.ajax '/wish_items/add_independent',
      type:     'post'
      async:    false
      dataType: 'json'
      data: {
        wish_list_id: $("#wish_list_id").val()
        city_id: $("#city_id").val()
        wish_item: {
          business_id: $("#business_id").val()
        }
      }
      success: (data, status, xhr) ->
        success = true

    if (success == true)
      # Disable this button as well as the vouch button
      currentElement.addClass("disabled")
      currentElement.html("Added To Wish List!")
      $("#vouch_business_action").addClass("disabled")
    else
      currentElement.removeClass("disabled")
