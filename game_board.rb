require 'eventmachine'
require 'json'

class GameBoard

  attr_reader :move_channel

  def initialize
    @board = {}
    @move_channel = EM::Channel.new
    @state = :not_started
    @insert_counter = 0
  end

  def player_list
    {}.tap{|h| @board.each{|i,p| h[i] = {:name => p.name, :stats => p.stats}}}
  end

  def start
    return false if game_started?
    @state = :running
    @board.to_a.shuffle.each do |p|
    end
  end

  def add_player(p)
    @insert_counter.tap do
      @board[@insert_counter] = p if !game_started?
      @insert_counter += 1
    end
  end

  def remove_player(id)
    @board.delete(id)
  end

  def game_started?
    true unless @state == :not_started
  end

end
