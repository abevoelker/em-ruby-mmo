require 'eventmachine'
require './player'
require './game_board'

module EventMachine
  module Protocols
    class MMOServer < EventMachine::Connection
      include Protocols::LineText2
      attr_accessor :game_board

      JoinRegex = /\AJOIN\s*/i

      def self.start(host='localhost', port=1337, opts={})
        @server = EM.start_server host, port, self do |conn|
          conn.game_board = opts[:game_board]
        end
      end

      def initialize(args={})
        super
      end

      def receive_line ln
        case ln
        when JoinRegex
          process_join $'.dup
        end
      end

      def process_join name
        if @player
          send_data "500 You've already joined, #{@player.name}\r\n"
          return
        end
        @player = Player.new({:name => name})
        @game_board.add_player @player
        send_data "Player '#{name}' joined\r\n"
      end
    end
  end
end

EM.run {
  g = GameBoard.new
  EM::P::MMOServer.start('localhost', 1337, {:game_board => g})
  puts "Waiting for players..."
}
