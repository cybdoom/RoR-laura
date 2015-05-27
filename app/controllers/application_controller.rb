class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception

  private
     def respond_with_interaction interaction_class, interaction_params
       render json: interaction_class.new(interaction_params, request.headers)
     end
    
end
