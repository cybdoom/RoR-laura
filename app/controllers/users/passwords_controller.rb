class Users::PasswordsController < ApplicationController

  skip_before_action :authenticate!, only: [:new]

  def new
    respond_with_interaction User::RequestForNewPassword, params

  rescue InteractionErrors::UserNotFound => e
    respond_with_error I18n.t('user.errors.user_not_found'), 404
  
  end

  # POST /resource/password
  # def create
  #   super
  # end

  # GET /resource/password/edit?reset_password_token=abcdef
  # def edit
  #   super
  # end

  # PUT /resource/password
  # def update
  #   super
  # end

  # protected

  # def after_resetting_password_path_for(resource)
  #   super(resource)
  # end

  # The path used after sending reset password instructions
  # def after_sending_reset_password_instructions_path_for(resource_name)
  #   super(resource_name)
  # end
end
