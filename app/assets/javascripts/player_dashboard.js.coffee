updatePlayer = ->
  $.get('/players/tick', (player) -> 
    $('#health').text(player.health)
    $('#hunger').text(player.hunger)
  )
  timer()

timer = -> 
  setTimeout -> 
    updatePlayer()
  ,5000

timer()
