require 'eventmachine'
require './player'
require './game_board'

module EventMachine
  module Protocols
    class MMOServer < EventMachine::Connection
      include Protocols::LineText2
      attr_accessor :game_board

      JoinRegex = /\AJOIN\s*/i
      ReadyRegex = /\AREADY/i
      PlayerListRegex = /\APLAYERLIST/i

      def self.start(host='localhost', port=1337, opts={})
        @server = EM.start_server host, port, self do |conn|
          conn.game_board = opts[:game_board]
        end
      end

      def initialize(args={})
        super
      end

      def unbind
        if @player
          game_board.remove_player(@player)
          puts "Player '#{@player.name}' left"
        end
      end

      private

      def receive_line ln
        case ln
        when JoinRegex
          process_join $'.dup
        when ReadyRegex
          process_ready
        when PlayerListRegex
          process_player_list
        end
      end

      def process_join name
        if @player
          send_data "500 You've already joined, #{@player.name}\r\n"
          return
        end
        @player = Player.new({:name => name})
        @game_board.add_player @player
        puts "Player '#{name}' joined\r\n"
        send_data "200 Welcome, #{name}\r\n"
      end

      def process_ready
        if @player && !@player.ready?
          @player.ready
          send_data("200 OK\r\n")
        else
          send_data("500 You haven't joined yet\r\n") && return unless @player
          send_data("500 You're already ready...\r\n") if @player.ready?
        end
      end

      def process_player_list
        send_data("200 OK\r\n#{@game_board.player_list.to_json}\r\n")
        return
        if @game_board.game_started?
          send_data("200 OK\r\n#{@game_board.player_list.to_json}\r\n")
        else
          send_data("500 Game hasn't started yet\r\n")
        end
      end
    end
  end
end
