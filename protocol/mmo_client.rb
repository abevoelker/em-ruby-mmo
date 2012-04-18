require 'eventmachine'
require 'state_machine'
require './strategies/default'

module EventMachine
  module Protocols
    class MMOClient < EventMachine::Connection
      include EventMachine::Deferrable
      include Protocols::LineText2
      attr_accessor :args

      state_machine :state, :initial => :pre_join do
        event :join do
          transition :pre_join => :join
        end

        state :pre_join do
          def receive_line(ln)
            parse_line_response(ln) do |data|
              @id = data.to_i
              self.join
            end
          end
        end
      end

      def self.start(host='localhost', port=1337, args={})
        args[:host] ||= host
        args[:port] ||= port
        EventMachine.connect(host, port, self) do |conn|
          conn.args = args
        end
      end

      def connection_completed
        send_data "JOIN #{@strategy.name}\r\n"
      end

      def initialize(strat=Strategy.new)
        @strategy = strat
      end

      private

      def parse_line_response(resp, &blk)
        resp_spl = resp.split
        status_code = resp_spl[0].to_i
        if status_code == 200
          blk.call(resp_spl[1])
        elsif status_code == 500
          raise "Server error: #{resp_spl[1]}"
        else
          raise "Don't know how to handle this: #{resp}"
        end
      end

    end
  end
end
