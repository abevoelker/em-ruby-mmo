require 'eventmachine'
require './player'
require './game_board'

module EventMachine
  module Protocols
    class MMOServer < EventMachine::Connection
      include Protocols::LineText2
      attr_accessor :options

      GameStateRegex = /\AGAMESTATE\s*/i

      def initialize(args={})
        super
        @p = Player.new
      end

=begin
      def self.start(host = 'localhost', port = 1337, *args)
        puts "start"
        @server = EM.start_server host, port, self do |conn|
          puts "start_server"
          conn.state = 0
        end
      end
=end

      def receive_line ln
        @p.take_damage
        send_data "OK"
      end
    end
  end
end

EM.run {
  g = GameBoard.new
  EM.start_server 'localhost', 1337, EM::P::MMOServer do |conn|
    puts "start_server"
    conn.options = {:game_board => g}
  end
  puts "Listening..."
}
