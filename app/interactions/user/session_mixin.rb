module User::SessionMixin

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
end
