class Users::AngelsController < Users::SignedInController
  def new
    @angel = Angel.new
  end

  def edit
    @angel = current_user.angel
  end

  def create
    @angel = Angel.new(angel_params)
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
    if @angel.update(angel_params)
      redirect_to users_dashboards_path, notice: 'Profil has been updated'
    else
      render 'edit'
    end
  end

  private

  def angel_params
    params.require(:angel).permit(:payment_method, :iban, :bank_account_name,
                                  :bic, :notes, :first_name,
                                  :last_name, :gender, :address, :postal_code, :city, :country,
                                  :home_phone, :mobile_phone, :work_phone, :lang)
  end
end
