module User::Serializers

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
  }

  def serialize_user user
    USER_ATTRIBUTES.inject({}){ |a,m| a.update m => user.send(m) }
  end

end
