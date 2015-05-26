class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception


  # @description creates Category from given parameters
  # description text may be multiline
  # @param category[title] required String Category title
  # @param category[weight] in which order Category will be shown
  # param text may also be multiline
  def create
    category = Category.new(create_category_params)

    if category.save
      render json: { category: category }.to_json, status: 201
    else
      render json: { errors: category.errors.full_messages }, status: 422
    end
  end
end
