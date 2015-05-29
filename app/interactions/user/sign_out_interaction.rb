class User::SignOutInteraction < Interaction
  def exec
    require_current_user!
    current_user.remove_token mobile_device_id

    self
  end

  def as_json opts = {}
    { message: I18n.t('user.notifications.sign_out') }
  end
end
