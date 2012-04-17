require './protocol/mmo_server'
require './game_board'

EM.run {
  g = GameBoard.new
  EM::P::MMOServer.start('localhost', 1337, {:game_board => g})
  puts "Waiting for players..."
}
