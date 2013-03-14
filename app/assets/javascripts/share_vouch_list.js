$(function() {
  var Friend, FriendList;

  Friend = function(data) {
    this.id    = ko.observable(data.id);
    this.name  = ko.observable(data.name);
    this.fb_id = ko.observable(data.fb_id);
    this.email = ko.observable(data.email);
  };

  FriendList = function(initialize, friendsList) {
    var self = this;

    self.newFriendName = ko.observable();
    self.friends = ko.observableArray([]);

    if (initialize == true) {
      var f;
      $.each(friendsList, function(index, value) {
        f = new Friend({
                         id:    value.id,
                         name:  value.name,
                         fb_id: value.facebook_id,
                         email: value.email
                      });
        self.friends.push(f);
      });
    }

    self.removeFriend = function(friend) {
      // Remove friend from database
      $.ajax({
        type: 'delete',
        url:  '/shared_friends/' + friend.id(),
        success: function(data) {
          console.log("Removed friend from the database");
        }
      });

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
      var other_contact = "";
      var email_to_save = "";
      var friend_type = "";
      var id_to_save = "";

      if (friend_id != "") {
        friend_type = "facebook";
      } else if (contact_email != "") {
        // This is a google contact
        friend_type = "google";
        email_to_save = contact_email;
      } else {
        friend_type = "email";
        // Get assumed email straight from the text field
        other_contact = $("#typed_friend_name").val();
        email_to_save = other_contact;
      }

      // Persist this data
      $.ajax({
        type: 'post',
        url:  '/vouch_lists/' + VOUCH_LIST + '/add_shared_friend',
        dataType: "json",
        async: false,
        data: {
                name:  friend_name,
                email: email_to_save,
                facebook_id: friend_id
              },
        success: function(data) {
          id_to_save = data.id;
          if (data.friend_name != "") {
            $(".friend-list-success").html("You are now friends with " + data.friend_name + '!<a class="close" data-dismiss="alert">&#215;</a>');
            $(".friend-list-success").fadeIn("fast");
          }
          console.log("Added friend " + friend_name + " with id: " + id_to_save);
        }
      });

      // Now add this friend to the view list, with id for deleting
      if (friend_type == "facebook") {
        self.friends.push(new Friend({
          id:   id_to_save,
          name: friend_name,
          fb_id: friend_id
        }));
      } else if (friend_type == "google") {
        self.friends.push(new Friend({
          id:   id_to_save,
          name: friend_name,
          email: contact_email
        }));
      } else {
        self.friends.push(new Friend({
          id:   id_to_save,
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
            link: document.URL,
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

  // Initialize friends list
  $.get('/vouch_lists/' + VOUCH_LIST + '/get_shared_friends',
    function(data) {
      if (data.friends.length > 0) {
        ko.applyBindings(new FriendList(true, data.friends));
      } else {
        ko.applyBindings(new FriendList(false));
      }
    }
  );

});
