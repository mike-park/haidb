class Team::ApplicationController < ApplicationController
  before_filter :authenticate_team!
  layout 'team/application'
end
