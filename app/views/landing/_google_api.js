function getGoogleFriends(token, token_type) {
  var authParams = { access_token: token, token_type: token_type };

  // Get user info. This is commented out.
  /*
  var user_info_url = 'https://www.googleapis.com/oauth2/v1/userinfo?access_token=' + token;
  $.get(user_info_url, function(user_data) {
    // data.email, data.id, data.name
    console.log("email: " + user_data.email);
  });
  */

  $.ajax({
    url: 'https://www.google.com/m8/feeds/contacts/default/full?max-results=2000',
    dataType: 'jsonp',
    data: authParams,
    success: function(data) {
      var xml = $.parseXML(data);
      $(xml).find('entry').each(function() {
        var entry = $(this);
        var name  = entry.find('title').text();
        var email = entry.find('email, gd\\:email').attr('address');
        // console.log("name: " + name + ", email: " + email);
      });
    }
  });

}
