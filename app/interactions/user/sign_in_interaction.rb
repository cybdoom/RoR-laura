class User::SignInInteraction < Interaction
  include User::Serializers

  def exec
    the_id = @args[:email].presence || @args[:phone].presence
    @user = User.where('email = :the_id or phone = :the_id', the_id: the_id).first
    raise InteractionErrors::InvalidUserError.new unless @user
    raise InteractionErrors::InvalidCredentialsError.new unless @user.authenticate(args[:password])
    @user.add_auth_token current_authentication_token
  end

  def current_authentication_token
    @_auth_token ||= {
      mobile_device_id => Authentication::Token.new.generate
    }
  end

  def as_json opts = {}
    serialize_user @user
  end
end
