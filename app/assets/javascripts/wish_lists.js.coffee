$ ->
  # Remove a wish item from a list
  $(".remove-wish-item").on "click", (e) ->
    e.preventDefault()

    if (!confirm("Are you sure you want to delete this item?"))
      return

    $(".wish-list-errors").hide()
    $(".wish-list-success").hide()

    wish_item_id = $(this).attr('id')
    loading_class = ".loading-image#loading_#{wish_item_id}"
    friend_id = parseInt($(this).next().val())

    $(this).addClass("disabled")
    $(loading_class).show()
    current_element = $(this)

    # Add this item to user's wish list
    $.ajax '/wish_items/' + wish_item_id,
      type:     'delete'
      async:    false
      dataType: 'json'
      success: (data, status, xhr) ->
        # Remove the whole row from current html
        current_element.parent().parent().remove()

        $(".wish-list-success").html('The item has been removed from your list.<a class="close" data-dismiss="alert">&#215;</a>')
        $(".wish-list-success").fadeIn("fast")
        return
      error: (xhr, status, error) ->
        $(".wish-list-errors").html("Errors: " + error + '<a class="close" data-dismiss="alert">&#215;</a>')
        $(".wish-list-errors").fadeIn("fast")
        return

    if $(this).hasClass("disabled")
      $(this).removeClass("disabled")
      $(loading_class).hide()
    return

  # Move an item from wish list into their vouch list
  $(".mark-item-visited").on "click", (e) ->
    e.preventDefault()

    $(".alert-error").hide()
    $(".alert-success").hide()
    $(".wish-list-errors").hide()
    $(".wish-list-success").hide()

    wish_item_id  = $(this).attr('id')
    vouch_item_id = ""
    tags = ""
    loading_class = ".loading-image#loading_#{wish_item_id}"
    success = false

    $(this).addClass("disabled")
    $(loading_class).show()
    current_element = $(this)

    # Add this item to user's wish list
    $.ajax '/wish_items/visited',
      type:     'post'
      async:    false
      dataType: 'json'
      data: {
        id: wish_item_id
      }
      success: (data, status, xhr) ->
        if (data.status == 422)
          $(".wish-list-errors").html("Errors: " + data.errors + '<a class="close" data-dismiss="alert">&#215;</a>')
          $(".wish-list-errors").fadeIn("fast")
          return

        success = true
        vouch_item_id = data.vouch_item_id
        tags = data.tags

        # Remove the whole row from current html
        current_element.parent().parent().remove()

        $(".wish-list-success").html('The item has been added to your vouch list.<a class="close" data-dismiss="alert">&#215;</a>')
        $(".wish-list-success").fadeIn("fast")
        return
      error: (xhr, status, error) ->
        $(".wish-list-errors").html("Errors: " + error + '<a class="close" data-dismiss="alert">&#215;</a>')
        $(".wish-list-errors").fadeIn("fast")
        return

    if (success == true)
      # Add taggings that this vouch item has for the new wish item
      $.each tags, (tagIndex, tagValue) ->
        $.ajax "/vouch_items/#{vouch_item_id}/add_tagging",
          type:     'post'
          async:    false
          dataType: 'json'
          data: {
            name: tagValue
          }
          success: (data, status, xhr) ->
            # console.log "tag #{tagValue} added"
    else if $(this).hasClass("disabled")
      $(this).removeClass("disabled")
      $(loading_class).hide()
    return

  return