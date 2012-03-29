class Users::RostersController < Users::ApplicationController
  load_and_authorize_resource

  def show
    @roster = RosterDecorator.new(@roster)
    respond_to do |format|
      format.html
      format.pdf { send_data(@roster.to_pdf, filename: @roster.filename, type: :pdf) }
    end
  end
end