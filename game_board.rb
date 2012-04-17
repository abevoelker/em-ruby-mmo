require 'eventmachine'

class GameBoard

  def initialize
    @board = []
    @move_channel = EM::Channel.new
    @state = :not_started
  end

  def start
    @state = :running unless game_started?
  end

  def add_player(p)
    @board << p if !game_started?
  end

  def game_started?
    true unless @state == :not_started
  end

end
