$(function() {
  var Friend, FriendList;

  Friend = function(data) {
    this.name  = ko.observable(data.name);
    this.fb_id = ko.observable(data.fb_id);
    this.email = ko.observable(data.email);
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
      $(".friend-list-error").fadeOut("fast");
      $(".friend-list-notice").fadeOut("fast");
      $(".friend-list-success").fadeOut("fast");

      var friend_fb_id, friend_name;
      friend_name = $("#typed_friend_name").val();
      if (friend_name === "") {
        $(".friend-list-error").html('Please enter a friend\'s name.');
        $(".friend-list-error").fadeIn("fast");
        return;
      }

      // Can have either friend id or email present
      var friend_id = $("#selected_friend_id").val();
      var contact_email = $("#selected_contact_email").val();
      var other_contact;

      if (friend_id != "") {
        // This is an fb friend
        self.friends.push(new Friend({
          name: friend_name,
          fb_id: friend_id
        }));
      } else if (contact_email != "") {
        // This is a google contact
        self.friends.push(new Friend({
          name: friend_name,
          email: contact_email
        }));
      } else {
        // Get assumed email straight from the text field
        other_contact = $("#typed_friend_name").val();
        self.friends.push(new Friend({
          name: other_contact
        }));
      }

      // Reset text field and hidden fields
      self.newFriendName("");
      $("#typed_friend_name").val('');
      $("#selected_friend_id").val('');
      $("#selected_contact_email").val('');

      return;
    };
    self.save = function() {
      $(".friend-list-error").hide();
      $(".friend-list-notice").hide();
      $(".friend-list-success").hide();

      // Create a list of fb id's or contact emails
      var dataToSave = [];
      $.each(self.friends(), function(index, value) {
        if (value.fb_id() != null) {
          // This is an fb friend
          dataToSave.push(value.fb_id());
        } else if (value.email() != null) {
          // This is a google contact
          dataToSave.push(value.email());
        } else {
          // This should be a manually entered email
          dataToSave.push(value.name());
        }
      });

      if (dataToSave.length == 0) {
        $(".friend-list-error").html("Please add some friends before sharing.");
        $(".friend-list-error").fadeIn("fast");
        return;
      }

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
          // This is an email address from google contact
          // $(".loading-image").show();
          var jqxhr = $.post('/vouch_lists/share_email/' + VOUCH_LIST,
            {
              email: value
            },
            function(data) {
              console.log("Email sent to " + value + "!");
          });
          jqxhr.complete(function(){
            // $(".loading-image").hide();
          });
        }
      });

      $(".friend-list-success").html("Your list has been shared!");
      $(".friend-list-success").fadeIn("fast");
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
