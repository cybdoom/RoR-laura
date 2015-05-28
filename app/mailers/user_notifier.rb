class UserNotifier < ApplicationMailer
  default from: "Laura API <no-reply@laura.com>"
  
  
  def profile_updated  user
    @user = user
    mail(to: @user.email, subject: 'Profile has been successfully updates').deliver
  end

  def register_new_user  user
    @user = user
    mail(to: @user.email, subject: 'Register a new user').deliver
  end


end
