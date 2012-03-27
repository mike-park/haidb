class Team::OmniauthCallbacksController < Devise::OmniauthCallbacksController
  def facebook
    @team = Team.find_for_facebook_oauth(request.env["omniauth.auth"], current_team)

    if @team
      flash[:notice] = I18n.t "devise.omniauth_callbacks.success", :kind => "Facebook"
      sign_in_and_redirect @team, :event => :authentication
    else
      session["devise.facebook_data"] = request.env["omniauth.auth"]
      redirect_to new_team_session_url
    end
  end
end