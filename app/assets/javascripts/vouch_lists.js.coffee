$ ->
  $("#add_restaurant").on "click", (e) ->
    e.preventDefault()
    name = $("#typed_restaurant_name").val()
    if (name == "")
      return;

    $.ajax '/businesses/' + CITY + "/" + name + "/details",
      type: 'post'
      dataType: 'json'
      success: (data, status, xhr) ->
        new_tr = "<tr>" +
                 "<td>" + data['business']['name'] + "</td>" +
                 "<td>" + data['business']['neighborhood']   + "</td>" +
                 "<td>" + data['business']['city'] + "</td>" +
                 "<td>" + data['business']['yelp_rating']    + "</td>" +
                 "<td>" + data['business']['yelp_review_count'] + "</td>" +
                 "</tr>"
        $(".restaurants-table tr:last").after(new_tr)
        $(".restaurant-placeholder").remove()
      error: (xhr, status, error) ->
        $(".list-errors").html("Errors: " + error)
        $(".list-errors").fadeIn("fast")
