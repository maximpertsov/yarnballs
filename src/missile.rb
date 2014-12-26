class Missile < Chingu::GameObject
  traits :timer, :velocity, :collision_detection
  trait :bounding_circle, :scale => 0.5
  attr_reader :damage, :speed
  
  IMAGE_FILE = "shot2.png"
  SOUND_FILE = "laser-02.ogg"
  SPEED = 8

  def initialize(options) 
    super(options.merge(:image => IMAGE_FILE))
    @damage = options[:damage] || 1
    @explosion_info = options[:explosion_info] || {}
    @lifespan = options[:lifespan] || false
    Gosu::Sound[SOUND_FILE].play
  end

  def update
    super
    remove_when_expired
    remove_when_off_screen
  end

  def remove_when_expired
    after(@lifespan) {self.destroy} if @lifespan
  end

  def remove_when_off_screen
    self.destroy if !(0..$window.width).include?(@x) || !(0..$window.height).include?(@y)
  end

  def explode!
    # spawn explosion proportional to object scale
    explosion_velocity = self.velocity.map {|v| v * 0.1}
    default_options = {:x => @x, :y => @y, :zorder => 2, :scale => 0.2, :color => Gosu::Color::CYAN, :velocity => explosion_velocity}
    Explosion.create(default_options.merge(@explosion_info))
    self.destroy
  end

  def self.shoot(options)
    options[:velocity_x] += Gosu.offset_x(options[:angle], SPEED)
    options[:velocity_y] += Gosu.offset_y(options[:angle], SPEED)
    self.create(options)
  end
end
