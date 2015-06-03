class User::RegistrationInteraction < InteractionBase
  include User::Serializers

  def exec
    args[:devices] = session_data
    @user = User.create args
    raise InteractionErrors::ActiveModelError.new @user.errors unless @user.valid?
    UserNotifier.register_new_user(@user).deliver_now
  end

  def session_data
    @_session_data ||= {
      mobile_device_id => {
        platform:             mobile_device_platform,
        app_name:             mobile_app_name,
      }.update(current_authentication_token)
    }
  end

  def current_authentication_token
    @_auth_token ||= { authentication_token: Authentication::Token.new.generate }
  end

  def as_json opts = {}
    serialize_user(@user).update current_authentication_token
  end
end
