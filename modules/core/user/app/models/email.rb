class Email < ActionMailer::Base
  # Private message.
  def pm(sender, recipient, message)
    from       sender.email
    recipients recipient.email
    subject    "#{SiteConf.instance.title} - From #{sender.openid}"
    body       :sender => sender, :recipient => recipient, :message => message
  end
end
