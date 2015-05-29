class JsonSerializers::User
# Constants ======================================================================
  USER_ATTRIBUTES = %i{
    user_id
    first_name
    middle_name
    last_name
    email
    phone
    license_plate_number
    license_plate_state
    driver_license
    driver_license_state
    state
    address
    current_authentication_token
  }

# Instance methods ===========================================================

  def initialize(user)
    @user = user
  end
  
  
  def as_json opts = {}
    @user.valid? ? to_json : errors_to_json
  end

  private

    def to_json
      json = {}

      USER_ATTRIBUTES.each { |attr| json[attr] = @user.send(attr) }

      json
    end

    def errors_to_json
      @user.error_messages
    end

end
