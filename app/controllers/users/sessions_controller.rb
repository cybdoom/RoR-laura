class Users::SessionsController < ApplicationController

  skip_before_action :authenticate!, only: [ :create ]

  # @description User sign in. User can be signed in via email or phone
  # @param auth_credentials[email] required String User's email
  # @param auth_credentials[phone] required String User's phone
  # @param auth_credentials[password] required String User's password
  def create
    auth_params = params.require(:auth_credentials).permit(
      :email, :phone, :password
    )
    respond_with_interaction UserSignInInteraction, auth_params
  end

  # @descriptio User sign out
  # @param authentication_token required String Authentication token
  def destroy
    respond_with_interaction UserSignOutInteraction, params
  end


  # @description User's profile
  # @param authentication_token required String Authentication token
  def profile
    respond_with_interaction UserProfileInteraction, params
  end
end
