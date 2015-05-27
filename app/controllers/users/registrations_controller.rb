class Users::RegistrationsController < ApplicationController
# before_filter :configure_sign_up_params, only: [:create]
# before_filter :configure_account_update_params, only: [:update]

  # @description Implements first registration step
  # @param user[:user_id] required String Should be uniq
  # @param user[:phone_number] required String User's phone nr
  # @param user[:email] required String User's email
  # @param user[:password] required String User's password, min length 8 chars
  # @param user[:password_confirmation] required String User's password confirmation, min length 8 chars
  def sign_up
    user_params = params.require(:user).permit(
      :user_id, :email, :phone, :password, :password_confirmation
    )
    respond_with_interaction UserRegistrationInteraction, user_params
  end

  # POST /resource
  # def create
  #   super
  # end

  # GET /resource/edit
  # def edit
  #   super
  # end

  # PUT /resource
  # def update
  #   super
  # end

  # DELETE /resource
  # def destroy
  #   super
  # end

  # GET /resource/cancel
  # Forces the session data which is usually expired after sign
  # in to be expired now. This is useful if the user wants to
  # cancel oauth signing in/up in the middle of the process,
  # removing all OAuth session data.
  # def cancel
  #   super
  # end

  # protected

  # If you have extra params to permit, append them to the sanitizer.
  # def configure_sign_up_params
  #   devise_parameter_sanitizer.for(:sign_up) << :attribute
  # end

  # If you have extra params to permit, append them to the sanitizer.
  # def configure_account_update_params
  #   devise_parameter_sanitizer.for(:account_update) << :attribute
  # end

  # The path used after sign up.
  # def after_sign_up_path_for(resource)
  #   super(resource)
  # end

  # The path used after sign up for inactive accounts.
  # def after_inactive_sign_up_path_for(resource)
  #   super(resource)
  # end
end
