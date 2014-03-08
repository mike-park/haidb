class Users::RostersController < Users::ApplicationController
  def show
    @roster = Roster.find(params[:id])
    authorize @roster
    @roster = RosterDecorator.new(@roster)
    respond_to do |format|
      format.html
      format.pdf { send_data(@roster.to_pdf, filename: @roster.filename, type: :pdf) }
    end
  end
end