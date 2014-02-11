class Office::MembershipsController < Office::ApplicationController
  before_filter :select_members, only: [:index]

  def index
    respond_to do |format|
      format.html
      format.csv do
        send_data Angel.to_csv(team_members), {
            :filename => filename('.csv'),
            :type => :csv
        }
      end
      format.vcard do
        send_data Angel.to_vcard(team_members), {
            :filename => filename('.vcf'),
            :type => :vcard
        }
      end
    end
  end

  def new
    @membership = Membership.new(active_on: Date.current)
  end

  def create
    @membership = Membership.new(params[:membership])
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
    if @membership.update_attributes(params[:membership])
      redirect_to office_membership_path(@membership), notice: 'Membership was successfully updated'
    else
      render action: :edit
    end
  end

  def destroy
    @membership = Membership.find(params[:id])
    @membership.destroy

    redirect_to office_teams_path
  end

  private

  def select_members
    status = if %w(active retired all).include?(params[:status])
               params[:status]
             else
               'active'
             end
    @header = "#{status.humanize} Team Members"
    @memberships = case status
                   when 'retired'
                     Membership.retired
                   when 'all'
                     Membership.all
                   else
                     Membership.active
                 end
  end
end