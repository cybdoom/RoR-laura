class Users::PasswordsController < ApplicationController

  skip_before_action :authenticate!, only: [:new, :edit]
  skip_before_action :validate_headers!, only: [:edit]
  before_action :validate_token!, only: [:edit]

  # @description serves a password recovery request
  # @param email required String User's email
  def new
    respond_with_interaction User::RequestForNewPassword, params

  rescue InteractionErrors::UserNotFound => e
    respond_with_error I18n.t('user.errors.user_not_found'), 404
  
  end

  # @description password recovery form
  # @param token required String Unique password token
  def edit
    
  end
  
  private

  def validate_token!
    @token = PasswordRecoveryToken.find_by token: params[:token]
    unless @token
      respond_with_error I18n.t('user.errors.invalid_password_recovery_token')
    end
  end
end
