module PlayersHelper
  def current_player
    session[:init] = true
    @current_player ||= Player.find(session[:player_id])
  end
end
