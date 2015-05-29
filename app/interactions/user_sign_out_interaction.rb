class UserSignOutInteraction < UserInteraction

  def initialize(params, headers)
    super
    sign_out
  end
  

  def as_json opts = {}

    return {} unless mobile_headers_valid? 
    { message: I18n.t('user.notifications.sign_out') }

  end

  def status_code
    200
  end
  

  private

    def sign_out
      user = User.current_user
      user.current_authentication_token.delete(mobile_device_id)
    end


  
end
