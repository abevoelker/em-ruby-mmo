require 'eventmachine'

class GameBoard

  def initialize
    @board = {}
    @move_channel = EM::Channel.new
    @state = :not_started
  end

  def start
    @state = :running unless game_started?
  end

  def add_player(p)
    @board[p.name] = p if !game_started?
  end

  def remove_player(p)
    @board.delete(p.name)
  end

  def game_started?
    true unless @state == :not_started
  end

end
