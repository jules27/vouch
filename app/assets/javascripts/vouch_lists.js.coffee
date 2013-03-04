$ ->
  VouchItem = (data) ->
    this.id   = ko.observable(data.id)
    this.name = ko.observable(data.name)
    this.neighborhood = ko.observable(data.neighborhood)
    this.city = ko.observable(data.city)
    this.yelp_rating  = ko.observable(data.yelp_rating)
    this.yelp_reviews = ko.observable(data.yelp_reviews)
    return

  VouchList = () ->
    self = this
    self.title = ko.observable()
    self.items = ko.observableArray([])
    self.newItemName = ko.observable()

    # Remove an item from the list
    self.removeItem = (item) ->
      self.items.remove(item)

    # Get the details for a business and add it to the list
    self.addItem = () ->
      name = $("#typed_restaurant_name").val()
      if (name == "")
        $(".restaurant-input-error").html('Please enter a restaurant name.<a class="close" data-dismiss="alert">&#215;</a>')
        $(".restaurant-input-error").fadeIn("fast")
        return;
      $(".restaurant-input-error").fadeOut("fast")

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

          self.items.push(new VouchItem({
                            id:   item_id,
                            name: item_name,
                            neighborhood: item_neighborhood,
                            city: item_city,
                            yelp_rating:  item_yelp_rating,
                            yelp_reviews: item_yelp_reviews,
                          }))
          self.newItemName("") # Clear the text box
          return
        error: (xhr, status, error) ->
          $(".restaurant-input-error").html("Errors: " + error + '<a class="close" data-dismiss="alert">&#215;</a>')
          $(".restaurant-input-error").fadeIn("fast")

      # TODO: Sort the items
      # this.items.sort( (a, b) ->
      #   return a.name < b.name ? -1 : 1
      # )

    # Create a list with businesses listed
    self.save = () ->
      dataToSave = $.map(self.items(), (item) ->
        return {
          business_id: item.id()
        }
      )

      if (dataToSave.length == 0)
        $(".restaurant-input-error").html("Please add some items to your list.")
        $(".restaurant-input-error").fadeIn("fast")
        return

      # Create the list with items!
      $.ajax '/vouch_lists/',
        type: 'post'
        dataType: 'json'
        data: {
          vouch_items: dataToSave,
          vouch_list: {
            owner_id: $('#owner_id').val(),
            title: self.title()
          }
        }
        success: (data, status, xhr) ->
          if (data.status == 422)
            $(".restaurant-input-error").html("Errors: " + data.errors)
            $(".restaurant-input-error").fadeIn("fast")
            return

          notice = "Your list has been successfully saved!"
          window.location.replace "/vouch_lists/#{data.list_id}?notice=#{notice}"
          return
        error: (xhr, status, error) ->
          $(".list-errors").html("Errors: " + error + '<a class="close" data-dismiss="alert">&#215;</a>')
          $(".list-errors").fadeIn("fast")

    # This is needed to prevent coffeescript from adding "return self.addItem",
    # which throws off knockout's js parser.
    return

  ko.applyBindings(new VouchList())

  # This is for vouch_list#show. Fade out notice message if any.
  if ($('.list-show-message').is(":visible"))
    $('.list-show-message').delay(2000).fadeOut("slow")

  return

  ###
    $.ajax '/businesses/' + CITY + "/" + name + "/details",
      beforeSend: ->
        $(".loading-image").show()
      complete: ->
        $(".loading-image").hide()
  ###
