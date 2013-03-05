$ ->
  Friend = (data) ->
    this.fb_id = ko.observable(data.fb_id)
    this.name  = ko.observable(data.name)

  FriendList = () ->
    self = this
    self.friends = ko.observableArray([])
    self.newFriendName = ko.observable()

    self.removeFriend = (friend) ->
      self.friends.remove(friend)

    self.addFriend = () ->
      $(".friend-list-error").hide()

      friend_name = $("#typed_friend_name").val()
      if (friend_name == "")
        $(".friend-list-error").html('Please enter a friend\'s name.')
        $(".friend-list-error").fadeIn("fast")
        return;

    return

  ko.applyBindings(new FriendList())

  # Fade out messages, if there are any
  if ($('.list-show-message').is(":visible"))
    $('.list-show-message').delay(2000).fadeOut("slow")

  return
