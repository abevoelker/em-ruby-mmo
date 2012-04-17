require 'state_machine'

class Player
  attr_accessor :health, :strength

  state_machine :state, :initial => :idle do
    event :take_damage do
      transition all => :dead, :if => lambda {|p| p.health <= 0}
    end

    after_transition any => :resting do |p, transition|
      p.health += 10
    end
  end

  def initialize
    @health = 100
    @strenth = 10
    super
  end
end
