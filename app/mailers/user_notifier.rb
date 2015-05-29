class UserNotifier < ApplicationMailer
  default from: "Laura API <laura-no-reply@yandex.ru>"
  
  
  def profile_updated  user
    @user = user
    mail(to: @user.email, subject: 'Profile has been successfully updates').deliver
  end

  def register_new_user  user
    @user = user
    mail(to: @user.email, subject: 'Register a new user')
  end


end
