class UserRegistrationInteraction < UserInteraction

  def initialize(params, headers)
    super
    create_user params
  end


  private

    def create_user params
      
      params[:devices] = current_authentication_token

      @user = User.create params

      if @user.valid?
        @user.current_authentication_token = current_authentication_token
        User.current_user = @user 
        UserNotifier.register_new_user @user
      end

    end

    def current_authentication_token
      @_auth_token ||={mobile_device_id => Authentication::Token.new.generate}     
    end

end
