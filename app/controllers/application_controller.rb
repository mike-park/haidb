class ApplicationController < ActionController::Base
  protect_from_forgery
  before_filter :set_user_language

  protected

  def authenticate_inviter!
    authenticate_staff!(:force => true)
  end

  private

  # devise redirect on staff login
  def staff_root_path
    office_root_path
  end

  # devise sign out path
  def after_sign_out_path_for(scope)
    scope == :staff ? staff_root_path : users_root_path
  end

  def set_user_language
    if (locale = params[:locale])
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

  def in_users_zone?
    request.path.match(/^\/users/).present?
  end
  helper_method :in_users_zone?

end
