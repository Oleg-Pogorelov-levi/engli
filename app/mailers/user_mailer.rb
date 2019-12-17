class UserMailer < ApplicationMailer

  default from: 'example.com'

  def sendMail(email)
    @user = User.find(1)
    @greeting = 'Hi'
    mail to: email, subject: "Your Subject"
  end
end
