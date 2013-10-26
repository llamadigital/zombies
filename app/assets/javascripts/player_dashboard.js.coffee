updatePlayer = ->
  $.get('/players/tick', (player) -> 
    $('#health').text(player.health)
    $('#hunger').text(player.hunger)
  )
  timer()

timer = -> 
  setTimeout -> 
    updatePlayer()
  ,2500

timer()
