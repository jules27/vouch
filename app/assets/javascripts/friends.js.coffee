$ ->
  $(".add-to-wish-list").on "click", (e) ->
    e.preventDefault()
    $(".friend-list-errors").hide()
    $(".friend-list-success").hide()

    business_id = $(this).attr('id')
    loading_class = ".loading-image#loading_#{business_id}"
    friend_id     = parseInt($(this).siblings('#friend_id').val())
    vouch_item_id = parseInt($(this).siblings('#vouch_item_id').val())
    wish_item_id  = ""

    $(this).addClass("disabled")
    $(loading_class).show()
    success = false
    tags = ""

    # Add this item to user's wish list
    $.ajax '/wish_items/add',
      type:     'post'
      async:    false
      dataType: 'json'
      data: {
          city_id: CITY_ID,
          vouch_item_id: vouch_item_id,
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

        success = true
        wish_item_id = data.wish_item_id
        tags = data.tags

        $(".friend-list-success").html('The item has been successfully added to your wish list!<a class="close" data-dismiss="alert">&#215;</a>')
        $(".friend-list-success").fadeIn("fast")

        return
      error: (xhr, status, error) ->
        $(".friend-list-errors").html("Errors: " + error + '<a class="close" data-dismiss="alert">&#215;</a>')
        $(".friend-list-errors").fadeIn("fast")
        return

    if (success == true)
      # Add taggings that this vouch item has for the new wish item
      $.each tags, (tagIndex, tagValue) ->
        $.ajax "/wish_items/#{wish_item_id}/add_tagging",
          type:     'post'
          async:    false
          dataType: 'json'
          data: {
            name: tagValue
          }
          success: (data, status, xhr) ->
            # console.log "tag #{tagValue} added"

      $(loading_class).hide()
      # Keep the disabled class, but change the text of the link
      $(this).text("Added to your wish list!")
    else if ($(this).hasClass("disabled"))
      $(this).removeClass("disabled")
      $(loading_class).hide()
    return

  return
