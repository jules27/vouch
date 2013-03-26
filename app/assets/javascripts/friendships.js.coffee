$ ->
  $("#add_friend_button").on "click", (e) ->
    e.preventDefault()
    $(".fade.in.alert-error").hide()
    $(".fade.in.alert-success").hide()
    $(".friendship-errors").hide()
    $(".friendship-success").hide()

    email_address = $("#friend_email").val()
    if ( email_address == "")
      $(".friendship-errors").html('Please enter an email.<a class="close" data-dismiss="alert">&#215;</a>')
      $(".friendship-errors").fadeIn("fast")
      return

    # Look up user by email
    $.post '/users/lookup',
    {
      email: email_address
    },
    (data) ->
      if (data.success)
        $(".friendship-success").html("#{data.name} has been added as a friend!" + '<a class="close" data-dismiss="alert">&#215;</a>')
        $(".friendship-success").fadeIn("fast")

        $(".my-friends").append("<li class=\"friendship-listing-item\">#{data.name}</li>")
      else
        $(".friendship-errors").html(data.errors + '<a class="close" data-dismiss="alert">&#215;</a>')
        $(".friendship-errors").fadeIn("fast")

    return
