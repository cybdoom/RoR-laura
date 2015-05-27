class UserRegistrationInteraction < Interaction

  def initialize(params, headers)
    @headers = headers
    create_user params
  end

  
  def as_json opts = {}
    return {} unless mobile_headers_valid? 
    JsonSerializers::User.new(@user)
  end
  
  
  def status_code
    (@user.valid? && mobile_headers_valid?) ? 200 : 422
  end


  private

    def create_user params
      params[:devices] =[{
        device_id: mobile_device_id,
        authentication_token: Authentication::Token.new.generate
      }]

      @user = User.create params

      if @user.valid?
        User.current_user = @user 
        UserNotifier.register_new_user @user
      end

    end

end
