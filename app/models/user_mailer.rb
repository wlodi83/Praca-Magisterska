class UserMailer < ActionMailer::Base
  def signup_notification(user)
    setup_email(user)
    @subject    += ' Aktywacja konta'
    @body[:url]  = "http://#{SITE_URL}/activate/#{user.activation_code}"
  end

  def activation(user)
    setup_email(user)
    @subject    += ' Twoje konto zostało aktywowane!'
    @body[:url]  = "http://#{SITE_URL}/"
  end

  def forgot_password(user)
    setup_email(user)
    @subject    += ' Wysłałeś wiadomość w celu zmiany hasła swojego konta.'
    @body[:url]  = "http://#{SITE_URL}/reset_password/#{user.password_reset_code}"
  end

  def reset_password(user)
    setup_email(user)
    @subject    += ' Twoje hasło zostało zresetowane.'
  end

  protected

  def setup_email(user)
    @recipients  = "#{user.email}"
    @from        = "lwlodarczyk@gazetamyszkowska.pl"
    @subject     = "#{SITE_URL}"
    @sent_on     = Time.now
    @body[:user] = user
  end
end