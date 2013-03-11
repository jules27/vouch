module VouchListsHelper
  # TODO: localhost:3000 needs to be changed for production
  def google_login_link(list_id)
    'https://accounts.google.com/o/oauth2/auth'\
    '?scope=https%3A%2F%2Fwww.google.com%2Fm8%2Ffeeds'\
    "&state=#{list_id}"\
    '&response_type=token'\
    '&client_id=1058703828317.apps.googleusercontent.com'\
    "&redirect_uri=http%3A%2F%2F#{Settings.domain}%3A3000%2Foauth2callback"
  end

  def capitalize_title(title)
    title.slice(0,1).capitalize + title.slice(1..-1)
  end
end
