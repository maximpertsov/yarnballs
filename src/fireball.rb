class Fireball < Missile
  trait :effect
  
  def initialize(options = {})
    super(options.merge(:color => Gosu::Color::YELLOW, :rotation_rate => 10, :scale => 2))
  end
end
