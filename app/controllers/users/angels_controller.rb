class Users::AngelsController < Users::SignedInController
  def new
    @angel = Angel.new
  end

  def edit
    @angel = current_user.angel
  end

  def create
    @angel = Angel.new(params[:angel])
    @angel.email = current_user.email
    if @angel.save
      current_user.update_attribute(:angel_id, @angel.id)
      redirect_to users_angel_path, notice: 'Profil has been created'
    else
      render 'new'
    end
  end

  def update
    @angel = current_user.angel
    if @angel.update_attributes(params[:angel])
      redirect_to users_dashboards_path, notice: 'Profil has been updated'
    else
      render 'edit'
    end
  end
end
