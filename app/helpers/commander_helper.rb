module CommanderHelper
  def load_commander
    @commander = Commander.find(session[:player_id])
  end
end
