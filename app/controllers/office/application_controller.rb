class Office::ApplicationController < ApplicationController
  before_filter :authenticate_staff!

  layout 'office/application'
  
  private

  def store_location
    session[:return_to] = request.request_uri
  end
    
  def redirect_back_or_default(default)
    redirect_to(session[:return_to] || default)
    session[:return_to] = nil
  end

  # controller & helper routines to handle angels, events & registrations
  
  def event
    @event ||= Event.find_by_id(params[:event_id] || params[:id])
  end
  helper_method :event

  def angel
    @angel ||= Angel.find_by_id(params[:angel_id] || params[:id])
  end
  helper_method :angel

  
  # return current registration, its ok to return nil
  def registration
    @registration ||= registrations.find_by_id(params[:id])
  end
  helper_method :registration

  # wrap block call with language set
  def with_language(language = :en)
    locale = I18n.locale
    I18n.locale = language
    yield
    I18n.locale = locale
  end
end
