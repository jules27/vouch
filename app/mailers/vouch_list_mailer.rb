class VouchListMailer < ActionMailer::Base
  default from: "vouch@example.com"

  # Subject can be set in your I18n file at config/locales/en.yml
  # with the following lookup:
  #
  #   en.vouch_list_mailer.share_vouch.subject
  #
  def share_vouch(to_email, vouch_list, root_url)
    @vouch_list = vouch_list
    @root_url   = root_url

    mail to: to_email,
         subject: "Check out #{@vouch_list.owner.name}\'s Vouch!"
  end
end
