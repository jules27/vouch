$ ->
  # Make tagging items easier using tag-it widget
  setTag = () ->
    $.each $(".tagging"), (index, value) ->
      item_id = parseInt($(value).find(".item-id").val())

      # Get existing tags for this wish item
      existing_tags = []
      $.ajax '/wish_items/' + item_id + '/get_tagging',
        type:     'get'
        async:    false
        dataType: 'json'
        success: (data, status, xhr) ->
          $.each data.tags, (tagIndex, tagValue) ->
            existing_tags.push tagValue.name

      # Add existing tags
      $(this).find('input').after("<input type=\"hidden\" id=\"mySingleField#{item_id}\" value=\"#{existing_tags.join('|')}\" />")

      $(value).find(".item-tags").tagit({
        allowDuplicates: false
        singleField: true
        singleFieldNode: $("#mySingleField#{item_id}")
        singleFieldDelimiter: "|"
        allowSpaces: true

        # TODO: disabled autocomplete because hovering over it will set the tag.
        # Can enable autocomplete if that can be fixed.
        autocomplete: { disabled: true }
        availableTags: existing_tags

        beforeTagAdded: (e, ui) ->
          if (!ui.duringInitialization)
            tag_name = ui.tagLabel
            # Save the tag via ajax call
            $.post '/wish_items/' + item_id + '/add_tagging',
            {
              name: tag_name
            },
            (data) ->
              # if (data.success)
              #     console.log "Tag has been added: " + tag_name
        beforeTagRemoved: (e, ui) ->
          if (!ui.duringInitialization)
            tag_name = ui.tagLabel
            # Remove the tag via ajax call
            $.ajax '/wish_items/' + item_id + '/delete_tagging',
              type: 'delete'
              dataType: 'json'
              data: {
                name: tag_name
              }
              success: (data, status, xhr) ->
                # console.log "Tag has been removed: " + tag_name
      })
    return

  # Adding a delay so that items can be read from database first
  # Note: this needs to be at least 500 for the tags to load properly
  # when deployed to Heroku.
  setTimeout setTag, 500

  return
