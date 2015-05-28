class Users::RegistrationsController < ApplicationController
  skip_before_action :authenticate!, only: [:sign_up]

  # @description Implements first registration step
  # @param user[user_id] required String Should be uniq
  # @param user[phone] required String User's phone nr
  # @param user[email] required String User's email
  # @param user[password] required String User's password, min length 8 chars
  # @param user[password_confirmation] required String User's password confirmation, min length 8 chars
  def sign_up
    user_params = params.require(:user).permit(
      :user_id, :email, :phone, :password, :password_confirmation
    )
    respond_with_interaction UserRegistrationInteraction, user_params
  end

  
  # @description Implements an update of user's profile
  # @param authentication_token required String Authentication token
  # @param user[phone] required String User's phone number
  # @param user[first_name] required String User's first_name
  # @param user[middle_name] required String User's middle name
  # @param user[last_name] required String User's last name
  # @param user[license_plate_number] required String User's license plate number
  # @param user[license_plate_state] required String User's license plate state
  # @param user[driver_license] required String User's driver license
  # @param user[driver_license_state] required String User's driver license state
  # @param user[state] required String User's state
  # @param user[address] required String User's address
  #
  def update_profile
    user_params = params.require(:user).permit(
      :user_id, :email, :phone, :user_id, :first_name, :middle_name, :last_name,
      :email, :phone, :license_plate_number, :license_plate_state, 
      :driver_license_state, :state, :address, :driver_license,
    )
    respond_with_interaction UpdateUserProfileInteraction, user_params
  end
end
