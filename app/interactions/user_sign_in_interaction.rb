class UserSignInInteraction < UserInteraction

  class InvalidUser

    def valid?
      false
    end
   
    def error_messages
      { error: I18n.t('user.errors.invalid_credentials') }
    end

  end


  def initialize(params, headers)
    super
    sign_in params
  end
  
  

  private
  

    def current_authentication_token
      @_auth_token ||= {
        mobile_device_id => Authentication::Token.new.generate
      }     
    end

    def sign_in params
      the_id = params[:email] || params[:phone]
      user = User.where('email = :the_id or phone = :the_id', the_id: the_id).first
      
      @user = if user and user.authenticate(params[:password])
        user.add_auth_token current_authentication_token 
        User.current_user = user

      else
        InvalidUser.new
      end
      
      
    end


  
end
