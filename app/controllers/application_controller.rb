class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  # protect_from_forgery with: :exception
  before_action :authenticate!


  private
    def authenticate!
      token = params[:authentication_token]

      User.find_by_auth_token device_id, token

      render text: '', status: 401 and return unless User.current_user

    end
    
    def device_id
      request.headers['X-DEVICE-X-DEVICE-ID'] || request.headers['X-DEVICE-ID']
    end
    

    def respond_with_interaction interaction_class, interaction_params
      entity = interaction_class.new(interaction_params, request.headers)
      render json: entity, status: entity.status_code
    end
    
end
