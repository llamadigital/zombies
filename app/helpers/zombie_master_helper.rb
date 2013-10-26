module ZombieMasterHelper
  def load_zombie_master
    @zombie_master = ZombieMaster.find(session[:player_id])
  end
end
