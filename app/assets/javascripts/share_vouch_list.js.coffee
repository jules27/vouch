$ ->
  Friend = (data) ->
    this.name    = ko.observable(data.name)
    this.fb_id   = ko.observable(data.fb_id)
    this.fb_link = ko.observable(data.fb_link)
    this.fb_username = ko.observable(data.fb_username)

  FriendList = () ->
    self = this
    self.friends = ko.observableArray([])
    self.newFriendName = ko.observable()

    self.removeFriend = (friend) ->
      self.friends.remove(friend)

    self.addFriend = () ->
      friend_name = $("#typed_friend_name").val()
      if (friend_name == "")
        $(".friend-list-error").html('Please enter a friend\'s name.')
        $(".friend-list-error").fadeIn("fast")
        return

      $(".friend-list-error").fadeOut("fast")

      friend_fb_id = ""
      friend_name  = ""

      # Get the friend's ID 

    return

  ko.applyBindings(new FriendList())

  # Fade out messages, if there are any
  if ($('.list-show-message').is(":visible"))
    $('.list-show-message').delay(2000).fadeOut("slow")

  return
