class ApplicationController < ActionController::Base
  protect_from_forgery
  before_filter :set_user_language

  private
  
  def set_user_language
    if locale = params[:locale]
      if I18n.available_locales.include?(locale.to_sym) ||
          I18n.available_locales.include?(locale)
        I18n.locale = locale.to_sym
      end
    end
  end

end
