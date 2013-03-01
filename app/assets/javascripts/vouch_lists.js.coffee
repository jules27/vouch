$ ->
  VouchItem = (data) ->
    this.name = ko.observable(data.name)
    this.neighborhood = ko.observable(data.neighborhood)
    this.city = ko.observable(data.city)
    this.yelp_rating  = ko.observable(data.yelp_rating)
    this.yelp_reviews = ko.observable(data.yelp_reviews)
    return

  VouchList = () ->
    # Data
    self = this
    self.items = ko.observableArray([])
    self.newItemName = ko.observable()

    # Operations
    self.addItem = () ->
      item_name = ""
      item_neighborhood = ""
      item_city = ""
      item_yelp_rating  = ""
      item_yelp_reviews = ""

      # Get info from server
      $.post '/businesses/' + CITY + "/" + self.newItemName() + "/details", (data) ->
        item_name = data['business']['name']
        item_neighborhood = data['business']['neighborhood']
        item_city = data['business']['city']
        item_yelp_rating  = data['business']['yelp_rating']
        item_yelp_reviews = data['business']['yelp_review_count']
        self.items.push(new VouchItem({
                          name: item_name,
                          neighborhood: item_neighborhood,
                          city: item_city,
                          yelp_rating:  item_yelp_rating,
                          yelp_reviews: item_yelp_reviews,
                        }))
        self.newItemName("") # Clear the text box
        return

    # This is needed to prevent coffeescript from adding "return self.addItem",
    # which throws off knockout's js parser.
    return

  ko.applyBindings(new VouchList())
  return

  ###
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
  ###
