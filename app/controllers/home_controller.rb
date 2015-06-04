class HomeController < ApplicationController
  def dashboard
    render text: I18n.t('welcome')
  end
end
