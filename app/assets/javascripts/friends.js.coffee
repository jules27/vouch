$ ->
  $(".add-to-wish-list").on "click", (e) ->
    e.preventDefault()

    item_id = $(this).attr('id')
    loading_class = ".loading-image#loading_#{item_id}"
    friend_id = parseInt($(this).next().val())

    $(this).addClass("disabled")
    $(loading_class).show()

    # Add this item to user's wish list
    $.ajax '/wish_items/add',
      type:     'post'
      async:    false
      dataType: 'json'
      data: {
          city_id: CITY_ID,
          wish_item: {
            business_id: item_id,
            user_id: friend_id
          }
        }
      success: (data, status, xhr) ->
        if (data.status == 422)
          $(".friend-list-errors").html("Errors: " + data.errors + '<a class="close" data-dismiss="alert">&#215;</a>')
          $(".friend-list-errors").fadeIn("fast")
          return

        $(".friend-list-success").html('The item has been successfully added!<a class="close" data-dismiss="alert">&#215;</a>')
        $(".friend-list-success").fadeIn("fast")
        return
      error: (xhr, status, error) ->
        $(".friend-list-errors").html("Errors: " + error + '<a class="close" data-dismiss="alert">&#215;</a>')
        $(".friend-list-errors").fadeIn("fast")
        return

    if $(this).hasClass("disabled")
      $(this).removeClass("disabled")
      $(loading_class).hide()
    return

  return
