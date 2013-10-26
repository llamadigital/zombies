updatePlayer = ->
  $.get('/players/tick', (player) -> 
    $('#health').text(player.health)
    $('#hunger').text(player.hunger)

    if player.type == 'Zombie'
      $('#player_image').attr('src', '/assets/zombie.png')
    else
      $('#player_image').attr('src', 'http://doomguy.herokuapp.com/damage/' +
        (100 - player.health) + '.gif')
  )
  timer()

timer = -> 
  setTimeout -> 
    updatePlayer()
  ,2500

timer()
