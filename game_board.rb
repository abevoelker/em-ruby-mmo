require 'eventmachine'
require 'json'

class GameBoard

  attr_reader :move_channel

  def initialize
    @players = {}
    @board = []
    @move_channel = EM::Channel.new
    @state = :not_started
    @insert_counter = 0
  end

  def player_list
    {}.tap{|h| @players.each{|i,p| h[i] = {:name => p.name, :stats => p.stats}}}
  end

  def start
    return false if game_started?
    @state = :running
    run
  end

  def run
    return false if @state != :running
    @board.shuffle.each do |pid|
    end
  end

  def add_player(p)
    return false if game_started?
    @insert_counter.tap do
      @players[@insert_counter] = p
      @board << @insert_counter
      @insert_counter += 1
    end
  end

  def remove_player(id)
    @players.delete(id)
    @board.delete(id)
  end

  def game_started?
    true unless @state == :not_started
  end

end
