require 'eventmachine'

module EventMachine
  module Protocols
    class MMOClient < EventMachine::Connection
      include Protocols::LineText2
      attr_accessor :args

      def initialize(args={})
        EventMachine.connect(args[:host], args[:port], self) do |conn|
          conn.args = args
        end
      end

      def receive_line ln
        puts "received #{ln}"
      end
    end
  end
end
