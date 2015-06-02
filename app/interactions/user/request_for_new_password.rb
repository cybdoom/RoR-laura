class User::RequestForNewPassword < Interaction
  include User::Serializers

  def exec
    @current_user = User.find_by email: @args[:email]
    raise InteractionErrors::UserNotFound unless @current_user

    UserNotifier.password_recovery(@current_user).deliver_now
  end

  def as_json(opts = {})
    { message:  I18n.t('user.notifications.password.instructions_sent')}
  end
end
