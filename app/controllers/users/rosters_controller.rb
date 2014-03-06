class Users::RostersController < Users::ApplicationController
  def show
    # TODO authorize this access
    @roster = Roster.find(params[:id])
    @roster = RosterDecorator.new(@roster)
    respond_to do |format|
      format.html
      format.pdf { send_data(@roster.to_pdf, filename: @roster.filename, type: :pdf) }
    end
  end
end