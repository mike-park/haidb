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

  def in_office_zone?
    request.path.match(/^\/office/).present?
  end
  helper_method :in_office_zone?

  def in_team_zone?
    request.path.match(/^\/team/).present?
  end
  helper_method :in_team_zone?

end
