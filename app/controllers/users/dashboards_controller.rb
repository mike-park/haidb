class Users::DashboardsController < Users::SignedInController
  def index
    redirect_to new_users_angel_path unless current_user.angel
  end
end