require './protocol/mmo_client'

EM.run {
  df = EM::P::MMOClient.start('localhost', 1337)
  df.callback {|res|
    puts "res: #{res}"
  }
}
