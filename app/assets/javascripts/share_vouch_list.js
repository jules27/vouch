$(function() {
  var Friend, FriendList;

  Friend = function(data) {
    this.name = ko.observable(data.name);
    this.fb_id = ko.observable(data.fb_id);
    this.fb_link = ko.observable(data.fb_link);
    this.fb_username = ko.observable(data.fb_username);
  };

  FriendList = function() {
    var self;
    self = this;
    self.friends = ko.observableArray([]);
    self.newFriendName = ko.observable();
    self.removeFriend = function(friend) {
      return self.friends.remove(friend);
    };
    self.addFriend = function() {
      var friend_fb_id, friend_name;
      friend_name = $("#typed_friend_name").val();
      if (friend_name === "") {
        $(".friend-list-error").html('Please enter a friend\'s name.');
        $(".friend-list-error").fadeIn("fast");
        return;
      }
      $(".friend-list-error").fadeOut("fast");
      friend_fb_id = "";
      friend_name = "";
      return self.friends.push(new Friend({
        name: friend_name
      }));
    };
  };

  ko.applyBindings(new FriendList());
});
