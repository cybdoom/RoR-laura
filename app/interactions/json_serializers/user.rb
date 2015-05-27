class JsonSerializers::User
  def initialize(user)
    @user = user
  end
  
  
  def as_json opts = {}
    @user.valid? ? to_json : errors_to_json
  end

  private

    def to_json
      @user
    end

    def errors_to_json
      @user.errors.messages
    end

end
