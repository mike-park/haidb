class Office::MembershipsController < Office::ApplicationController
  def index
    select_members
    respond_to do |format|
      format.html
      format.csv { send_data Membership.to_csv(@memberships), filename: "memberships.csv", type: :csv }
      format.vcard { send_data Angel.to_vcard(angels), filename: "memberships.vcf", type: :vcard }
    end
  end

  def new
    @membership = Membership.new(angel_id: params[:angel_id], active_on: Date.current)
  end

  def create
    @membership = Membership.new(membership_params)
    if @membership.save
      redirect_to([:office, @membership], :notice => 'Membership was successfully created.')
    else
      render :new
    end
  end

  def show
    @membership = Membership.find(params[:id]).decorate
  end

  def edit
    @membership = Membership.find(params[:id])
  end

  def update
    @membership = Membership.find(params[:id])
    if @membership.update(membership_params)
      redirect_to office_membership_path(@membership), notice: 'Membership was successfully updated'
    else
      render action: :edit
    end
  end

  def destroy
    membership = Membership.find(params[:id])
    membership.destroy

    redirect_to office_teams_path
  end

  def refresh
    memberships = Membership.recalc_status
    message = memberships.map { |m| "#{m.full_name} to #{m.status}" }.join(", ")
    message = memberships.any? ? "Status refreshed: #{message}" : "No changes"
    redirect_to office_memberships_path(status: 'active'), notice: message
  end

  private

  def membership_params
    params.require(:membership).permit(:angel_id, :default_role, :status, :active_on, :retired_on, :participant_cost, :team_cost, :notes)
  end

  def angels
    @memberships.map(&:angel).uniq
  end

  def select_members
    status = if %w(active retired all).include?(params[:status])
               params[:status]
             else
               'active'
             end
    @header = "#{status.humanize} Team Member"
    @memberships = case status
                     when 'retired'
                       Membership.retired
                     when 'all'
                       Membership.all
                     else
                       Membership.active
                   end.sort
  end
end