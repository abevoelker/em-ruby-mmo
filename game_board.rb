require 'eventmachine'
require 'json'

class GameBoard

  attr_reader :move_channel

  def initialize
    @board = {}
    @move_channel = EM::Channel.new
    @state = :not_started
  end

  def player_list
    {}.tap{|h| @board.each{|n,p| h[n] = {:stats => p.stats}}}
    #@board.reduce({}){|a,v| a[v[0]] = {:stats => v[1].stats}; a}
  end

  def start
    return false if game_started?
    @state = :running
    @board.to_a.shuffle.each do |p|
    end
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
