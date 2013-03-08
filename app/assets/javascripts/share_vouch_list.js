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
      // TODO: can be either fb friend or email contact!
      var friend_fb_id, friend_name;
      friend_name = $("#typed_friend_name").val();
      if (friend_name === "") {
        $(".friend-list-error").html('Please enter a friend\'s name.');
        $(".friend-list-error").fadeIn("fast");
        return;
      }
      $(".friend-list-error").fadeOut("fast");

      // It's either friend id or email that's present
      var friend_id = $("#selected_friend_id").val();
      if (friend_id != "") {
        // This is an fb friend
        self.friends.push(new Friend({
          name: friend_name,
          fb_id: friend_id
        }));
      } else {
        // This is a google contact
        var contact_email = $("#selected_contact_email").val();
        self.friends.push(new Friend({
          name: friend_name,
          email: contact_email
        }));
      }

      // Reset text field and hidden fields
      self.newFriendName("");
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
        if (value.fb_id() == null) {
          // This is a google contact
          dataToSave.push(value.email());
        } else {
          // This is an fb friend
          dataToSave.push(value.fb_id());
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
          $(".loading-image").show();
          var jqxhr = $.post('/vouch_lists/share_email/' + VOUCH_LIST,
            {
              email: value
            },
            function(data) {
              console.log("Email sent to " + value + "!");
          });
          jqxhr.complete(function(){
            $(".loading-image").hide();
          });
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
