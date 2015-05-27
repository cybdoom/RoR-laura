class UserRegistrationInteraction < Interaction

  def initialize(params, headers)
    @headers = headers
    create_user params
  end

  
  def as_json opts = {}
    JsonSerializers::User.new(@user)
  end
  

  private

    def create_user params
      params[:devices] =[ {
        device_id: mobile_device_id,
        authentication_token: Authentication::Token.new.generate
      }]

      @user = User.create params
      User.current_user = @user if @user.valid?
    end

end
