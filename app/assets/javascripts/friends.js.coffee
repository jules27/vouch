$ ->
  $(".add-to-wish-list").on "click", (e) ->
    e.preventDefault()
    $(".friend-list-errors").hide()
    $(".friend-list-success").hide()

    business_id = $(this).attr('id')
    loading_class = ".loading-image#loading_#{business_id}"
    friend_id = parseInt($(this).next().val())

    $(this).addClass("disabled")
    $(loading_class).show()
    success = false

    # Add this item to user's wish list
    $.ajax '/wish_items/add',
      type:     'post'
      async:    false
      dataType: 'json'
      data: {
          city_id: CITY_ID,
          wish_item: {
            business_id: business_id,
            user_id: friend_id
          }
        }
      success: (data, status, xhr) ->
        if (data.status == 422)
          $(".friend-list-errors").html("Errors: " + data.errors + '<a class="close" data-dismiss="alert">&#215;</a>')
          $(".friend-list-errors").fadeIn("fast")
          return

        $(".friend-list-success").html('The item has been successfully added to your wish list!<a class="close" data-dismiss="alert">&#215;</a>')
        $(".friend-list-success").fadeIn("fast")
        success = true

        return
      error: (xhr, status, error) ->
        $(".friend-list-errors").html("Errors: " + error + '<a class="close" data-dismiss="alert">&#215;</a>')
        $(".friend-list-errors").fadeIn("fast")
        return

    if (success == true)
      $(loading_class).hide()
      # Keep the disabled class, but change the text of the link
      $(this).text("Added to your wish list!")
    else if ($(this).hasClass("disabled"))
      $(this).removeClass("disabled")
      $(loading_class).hide()
    return

  return
