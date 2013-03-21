$ ->
  $('#add_business_to_wish_list').on "click", (e) ->
    business_name = $('#business_name').val()
    business_id = ""

    $(".wish-item-errors").hide()
    $(".wish-item-success").hide()

    # Get the business id from database using the name
    $.ajax "/businesses/#{CITY}/#{business_name}/details",
      type:     'post'
      async:    false
      dataType: 'json'
      success: (data, status, xhr) ->
        if (data.status == 422)
          $(".wish-item-errors").html("Cannot retrieve details for \"#{business_name}\"." + '<a class="close" data-dismiss="alert">&#215;</a>')
          $(".wish-item-errors").fadeIn("fast")
        else
          business_id = data.business.id
        return
      error: (xhr, status, error) ->
        $(".wish-item-errors").html("Error: #{error}" + '<a class="close" data-dismiss="alert">&#215;</a>')
        $(".wish-item-errors").fadeIn("fast")
        return

    if (business_id == "")
      # If there's been an error, don't continue
      e.preventDefault()
    else
      # Fill in the business id
      $('#wish_item_business_id').val(business_id)

    # Continue as normal
    return
