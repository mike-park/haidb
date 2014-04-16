class ApplicationController < ActionController::Base
  protect_from_forgery
  include Pundit
  before_action :adjust_view_path
  before_action :set_user_language

  protected

  def authenticate_inviter!
    authenticate_staff!(:force => true)
  end

  private

  def adjust_view_path
    prepend_view_path "app/views/#{Site.name}"
  end

  def audit_user
    current_staff
  end

  # devise redirect on staff login
  def staff_root_path
    office_root_path
  end

  # devise redirect on users login
  def user_root_path
    users_root_path
  end

  # devise sign out path
  def after_sign_out_path_for(scope)
    scope == :staff ? staff_root_path : users_root_path
  end

  def set_user_language
    locale = params[:locale]
    if locale && Site.available_locales.include?(locale)
      I18n.locale = locale.to_sym
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
