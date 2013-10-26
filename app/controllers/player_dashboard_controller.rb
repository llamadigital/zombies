class PlayerDashboardController < ApplicationController
  include PlayersHelper

  def index
    @player = current_player
  end
end
