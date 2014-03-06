class Office::ApplicationController < ApplicationController
  layout 'office/application'

  before_filter :authenticate_staff!

  rescue_from ActiveRecord::RecordNotFound do
    redirect_to office_root_url, :alert => 'Record not found'
  end

  private

  def store_location(location)
    session[:return_to] = location
  end
    
  def stored_location
    location = session[:return_to]
    session[:return_to] = nil
    location
  end

  # wrap block call with language set
  def with_language(language = :en)
    locale = I18n.locale
    I18n.locale = language
    yield
    I18n.locale = locale
  end
end
