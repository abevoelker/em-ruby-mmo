class Player
  attr_reader :name
  attr_reader :max_health, :health, :level, :strength, :defense, :alive

  LEVEL_THRESHOLDS = [ 50, 100, 200, 500, 1000, 1500, 2500, 4000]
  HEALTH_INDEX     = [100, 110, 125, 145,  170,  195,  225,  260]
  STRENGTH_INDEX   = [ 20,  22,  25,  29,   34,   40,   47,   55]
  DEFENSE_INDEX    = [ 20,  22,  24,  26,   28,   30,   32,   34]

  def initialize(args={})
    @name = args[:name]
    @health = 100
    @level = 0
    @max_health = HEALTH_INDEX[@level]
    @strength = STRENGTH_INDEX[@level]
    @defense = DEFENSE_INDEX[@level]
    @experience = 0
    @alive = true
  end

  # the attack move
  def attack(opponent)
    if opponent.class == Player || opponent.class == Monster
      points = @strength - opponent.defense/2
      opponent.suffer_damage(points)
    elsif opponent.nil?
      puts "No such opponent."
    else
      raise "Can only attack Player objects. Object was #{opponent.class}"
    end
  end

  # the rest move
  def rest(arg)
    if @health <= @max_health
      @health = @health + 10
    end
    if @health > @max_health
      @health = @max_health
    end
  end

  # this is called when the player is the object of another player's attack
  def suffer_damage(points)
    @health = @health - points
    if @health <= 0
      #puts "#{proxy} has died."
      @alive = false
      @health = 0
    end
  end

  def stats
    { health: @health, level: @level, strength: @strength, defense: @defense, experience: @experience }
  end

  # Reward player with experiences after killing an opponent in group of certain size
  #
  # Experiences could be based on the opponents stats like level, reshare experiences, etc
  def reward(opponent, groupsize)
    @experience = @experience + opponent.max_health / groupsize
    if @experience >= LEVEL_THRESHOLDS[@level]
      upgrade(@level)
    end
  end

  private

  def upgrade(level)
    @level += 1
    @strength = STRENGTH_INDEX[@level]
    @defense = DEFENSE_INDEX[@level]
    @max_health = HEALTH_INDEX[@level]
    @health = @max_health
  end
end
