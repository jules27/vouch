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
      self.friends.remove(friend);
      return;
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

      var friend_id = $("#selected_friend_id").val();

      self.friends.push(new Friend({
        name: friend_name,
        fb_id: friend_id
      }));
      self.newFriendName("");
      return;
    };
    self.save = function() {
      $(".friend-list-error").hide();
      $(".friend-list-notice").hide();
      $(".friend-list-success").hide();

      // Create a list of fb id's
      var dataToSave = [];
      $.each(self.friends(), function(index, value) {
        dataToSave.push(value.fb_id());
      });

      if (dataToSave.length == 0) {
        $(".friend-list-error").html("Please add some friends before sharing.");
        $(".friend-list-error").fadeIn("fast");
        return;
      }

      // FB.ui({method: 'apprequests',
      //   title: 'Check out my Vouches!',
      //   message: 'I have shared my vouches with you. Check it out on ' + document.URL + '!',
      //   to: dataToSave
      // }, requestCallback);

      $.each(dataToSave, function(index, value) {
        // If this friend is a fb id...
        var title = $(".list-title").html();
        if (isNaN(value) == false) {
          FB.ui({
            method: "send",
            to: value,
            link: "http://vouch-alpha.herokuapp.com/",//document.URL,
            description: "I just put together my vouches for " + title + ". Check it out!"
          }, requestCallback);
        } else {
          // Email address
          console.log("email")
        }
      });
    };

    function requestCallback(response) {
      if (response != null) {
        if (response.error_code == 100) {
          var msg = "Error: " + response.error_msg;
          $(".friend-list-error").html(msg + '<a class="close" data-dismiss="alert">&#215;</a>');
          $(".friend-list-error").fadeIn("fast");
          return;
        }
        $(".friend-list-success").html('You have successfully shared your list!<a class="close" data-dismiss="alert">&#215;</a>');
        $(".friend-list-success").fadeIn("fast");
      }
    }
  };

  ko.applyBindings(new FriendList());
});
