$ ->
  # Knockout bindings
  VouchItem = (data) ->
    this.id   = ko.observable(data.id)
    this.name = ko.observable(data.name)
    this.neighborhood = ko.observable(data.neighborhood)
    this.city = ko.observable(data.city)
    this.yelp_rating  = ko.observable(data.yelp_rating)
    this.yelp_reviews = ko.observable(data.yelp_reviews)
    this.item_id = ko.observable(data.item_id)
    this.tags    = ko.observable(data.tags)
    return

  VouchList = (initialize, listTitle, listItems) ->
    self = this

    if (initialize == false)
      self.title = ko.observable()
      self.items = ko.observableArray([])
      self.newItemName = ko.observable()
    else
      self.title = ko.observable(listTitle)
      self.items = ko.observableArray([])

      $.each listItems, (index, value) ->
        v = new VouchItem({
                        id:   value.id,
                        name: value.name,
                        neighborhood: value.neighborhood,
                        city: value.city,
                        yelp_rating:  value.yelp_rating,
                        yelp_reviews: value.yelp_reviews,
                        item_id:      value.item_id
                      })
        self.items.push(v)

      self.newItemName = ko.observable()

    # Remove an item from the list
    self.removeItem = (item) ->
      self.items.remove(item)

      # Make another ajax call to remove the item if this is an existing list
      if (VOUCH_LIST > 0)
        $.ajax "/vouch_items/#{item.item_id()}",
        type: 'delete'
        dataType: 'json'
        success: (data, status, xhr) ->
          $(".list-success").html("Item has been removed from the list.")
          $(".list-success").fadeIn("fast")

      return

    # Get the details for a business and add it to the list
    self.addItem = () ->
      name = $("#typed_restaurant_name").val()
      if (name == "")
        $(".restaurant-input-error").html('Please enter a restaurant name.<a class="close" data-dismiss="alert">&#215;</a>')
        $(".restaurant-input-error").fadeIn("fast")
        return

      $(".restaurant-input-error").fadeOut("fast")
      $(".list-success").hide()

      item_id   = ""
      item_name = ""
      item_neighborhood = ""
      item_city = ""
      item_yelp_rating  = ""
      item_yelp_reviews = ""

      # Get business info from the server
      $.ajax '/businesses/' + CITY + "/" + self.newItemName() + "/details",
        type: 'post'
        dataType: 'json'
        success: (data, status, xhr) ->
          # Check for server errors
          if (data.status == 422)
            $(".restaurant-input-error").html("Errors: " + data.errors)
            $(".restaurant-input-error").fadeIn("fast")
            return

          item_id   = data['business']['id']
          item_name = data['business']['name']
          item_neighborhood = data['business']['neighborhood']
          item_city = data['business']['city']
          item_yelp_rating  = data['business']['yelp_rating']
          item_yelp_reviews = data['business']['yelp_review_count']

          # Check for duplicates
          should_quit = false
          $.each self.items(), (index, value) ->
            if value.id() == item_id
              $(".restaurant-input-error").html('You have already added this business to the list.')
              $(".restaurant-input-error").fadeIn("fast")
              self.newItemName("") # Clear the text box
              should_quit = true

            if should_quit == true
              return

          if should_quit == true
            return

          self.items.push(new VouchItem({
                            id:   item_id,
                            name: item_name,
                            neighborhood: item_neighborhood,
                            city: item_city,
                            yelp_rating:  item_yelp_rating,
                            yelp_reviews: item_yelp_reviews,
                          }))
          self.newItemName("") # Clear the text box

          # Make another ajax call to create item if this is an existing list
          if (VOUCH_LIST > 0)
            $.post '/vouch_items/',
            {
              id: VOUCH_LIST,
              vouch_item: {
                  vouch_list_id: VOUCH_LIST,
                  business_id:   item_id
                }
            },
            (data) ->
              if (data.success)
                $(".list-success").html("Item has been added to the list.")
                $(".list-success").fadeIn("fast")

                # Make a new tag input for this item
                vouch_item_id = data.vouch_item_id
                $(".items").last().find(".item-tags").tagit({
                  allowDuplicates: false
                  singleField: true
                  singleFieldDelimiter: "|"
                  allowSpaces: true

                  # TODO: disabled autocomplete because hovering over it will set the tag.
                  # Can enable autocomplete if that can be fixed.
                  autocomplete: { disabled: true }

                  beforeTagAdded: (e, ui) ->
                    if (!ui.duringInitialization)
                      tag_name = ui.tagLabel
                      # Save the tag via ajax call
                      $.post '/vouch_items/' + vouch_item_id + '/add_tagging',
                      {
                        name: tag_name
                      },
                      (tagData) ->
                        if (tagData.success)
                          console.log "Tag has been added: " + tag_name
                  beforeTagRemoved: (e, ui) ->
                    if (!ui.duringInitialization)
                      tag_name = ui.tagLabel
                      # Remove the tag via ajax call
                      $.ajax '/vouch_items/' + vouch_item_id + '/delete_tagging',
                        type: 'delete'
                        dataType: 'json'
                        data: {
                          name: tag_name
                        }
                        success: (tagData, status, xhr) ->
                          console.log "Tag has been removed: " + tag_name
                })
                return
          else
            # Make a new tag input for this item
            row_number = $(".items").length - 1

            $.each $(".items"), (index, value) ->
              if (index == row_number)
                $(value).find(".item-tags").tagit({
                  allowDuplicates: false
                  singleField: true
                  singleFieldDelimiter: "|"
                  allowSpaces: true
                  autocomplete: { disabled: true }
                })
                return

          return
        error: (xhr, status, error) ->
          $(".restaurant-input-error").html("Errors: " + error + '<a class="close" data-dismiss="alert">&#215;</a>')
          $(".restaurant-input-error").fadeIn("fast")

    # Create a list with businesses listed
    self.save = () ->
      $(".list-success").hide()
      $(".restaurant-input-error").hide()

      dataToSave = $.map(self.items(), (item) ->
        return {
          business_id: item.id()
        }
      )

      if (dataToSave.length == 0)
        $(".restaurant-input-error").html("Please add some items to your list.")
        $(".restaurant-input-error").fadeIn("fast")
        return

      # Disable button to prevent duplicate submissions
      $(".save-list-submit").attr('disabled','disabled')
      $(".loading-image").show()

      if (VOUCH_LIST == 0)
        allTags = []
        $.each $("input[name=tags]"), (index, value) ->
          tags = $(this).val().split("|")
          allTags.push tags
          return

        # Create the list with items!
        $.ajax '/vouch_lists/',
          type: 'post'
          dataType: 'json'
          data: {
            vouch_items: dataToSave,
            item_tags: allTags,
            vouch_list: {
              owner_id: $('#owner_id').val(),
              city_id:  $('#city_id').val(),
              title: self.title()
            }
          }
          success: (data, status, xhr) ->
            if (data.status == 422)
              $(".restaurant-input-error").html("Errors: " + data.errors)
              $(".restaurant-input-error").fadeIn("fast")
              return

            # notice = "Your list has been successfully saved!"
            window.location.replace "/vouch_lists/#{data.list_id}" #?notice=#{notice}"
            return
          error: (xhr, status, error) ->
            $(".list-errors").html("Errors: " + error + '<a class="close" data-dismiss="alert">&#215;</a>')
            $(".list-errors").fadeIn("fast")
          complete: (xhr, status) ->
            $(".save-list-submit").removeAttr('disabled')
            $(".loading-image").hide()
      else
        # Update an existing list
        $.ajax '/vouch_lists/' + VOUCH_LIST,
          type: 'put'
          dataType: 'json'
          data: {
            vouch_items: dataToSave,
            vouch_list: {
              owner_id: $('#owner_id').val(),
              city_id:  $('#city_id').val(),
              title: self.title()
            }
          }
          success: (data, status, xhr) ->
            if (data.status == 422)
              $(".restaurant-input-error").html("Errors: " + data.errors)
              $(".restaurant-input-error").fadeIn("fast")
              return

            $(".list-success").html("Your list has been successfully updated!")
            $(".list-success").fadeIn("fast")
            return
          error: (xhr, status, error) ->
            $(".list-errors").html("Errors: " + error + '<a class="close" data-dismiss="alert">&#215;</a>')
            $(".list-errors").fadeIn("fast")
          complete: (xhr, status) ->
            $(".save-list-submit").removeAttr('disabled')
            $(".loading-image").hide()

    # This is needed to prevent coffeescript from adding "return self.addItem",
    # which throws off knockout's js parser.
    return

  if (VOUCH_LIST == 0)
    # console.log "create a new list"
    ko.applyBindings(new VouchList(false))
  else
    # console.log "existing list"
    # Initialize data from server
    $.get '/vouch_list_details/' + VOUCH_LIST,
      (data) ->
        ko.applyBindings(new VouchList(true, data.title, data.items))

  # Make tagging items easier using tag-it widget
  setTag = () ->
    $.each $(".tagging"), (index, value) ->
      item_id = parseInt($(value).find(".item_id").html())

      # Get tags for this vouch item
      existing_tags = []
      $.ajax '/vouch_items/' + item_id + '/get_tagging',
        type:     'get'
        async:    false
        dataType: 'json'
        success: (data, status, xhr) ->
          $.each data.tags, (tagIndex, tagValue) ->
            existing_tags.push tagValue.name

      # Add existing tags
      $(this).find('span').after("<input type=\"hidden\" id=\"mySingleField#{item_id}\" value=\"#{existing_tags.join('|')}\" />")

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
            if (VOUCH_LIST > 0)
              # Save the tag via ajax call
              $.post '/vouch_items/' + item_id + '/add_tagging',
              {
                name: tag_name
              },
              (data) ->
                # if (data.success)
                #   console.log "Tag has been added: " + tag_name
        beforeTagRemoved: (e, ui) ->
          if (!ui.duringInitialization)
            tag_name = ui.tagLabel
            if (VOUCH_LIST > 0)
              # Remove the tag via ajax call
              $.ajax '/vouch_items/' + item_id + '/delete_tagging',
                type: 'delete'
                dataType: 'json'
                data: {
                  name: tag_name
                }
                success: (data, status, xhr) ->
                  # console.log "Tag has been removed: " + tag_name
      })

  # Adding a delay so that items can be read from database first
  # Note: this needs to be at least 500 for the tags to load properly
  # when deployed to Heroku.
  setTimeout setTag, 500

  return
