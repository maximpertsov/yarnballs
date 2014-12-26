class Enemy < Chingu::GameObject
  include ScreenWrapping, Shooting, CollisionEffects

  traits :timer, :velocity, :effect, :collision_detection
  trait :bounding_circle, :scale => 0.8
  
  IMAGE_FILE = "yarn_ball_256x256.png"
  
  def initialize(options)
    case (options[:scale] * 100).to_i
    when 70...75
      options[:health] = 20
      options[:color] = Gosu::Color::GRAY
      options[:velocity].map! {|v| v * 0.5}
      options[:scale] *= 2
    when 45...70
      options[:health] = 9
      options[:color] = Gosu::Color::FUCHSIA
    else
      options[:health] = 3
      options[:color] = Gosu::Color::YELLOW
      options[:velocity].map! {|v| v * 2}
      options[:scale] *= 0.8
    end
    @health = options[:health]
    super(options.merge(:image => IMAGE_FILE))
    @missile = Fireball
    @init_color = @color
  end
  
  def update
    super
    screen_wrap
    self.rapid_shot(1000)
    self.explode! if self.dead?
  end
    
  def dead?
    @health == 0
  end

  def reduce_health_by(damage)
    @health = [0, @health - damage].max 
  end
  
  def explode!
    # spawn explosion proportional to object scale
    Explosion.create(:x => @x, :y => @y, :zorder => 2, :scale => self.scale + 0.5)
    self.destroy
  end

  def basic_shot(modifiers = {})
    super({:angle => @angle + 45}.merge(modifiers))
  end

  def bounce(other_object)
    direction = Gosu.angle(@x, @y, other_object.x, other_object.y) + 180
    speed = Vector.elements(self.velocity).magnitude
    @velocity_x = Gosu.offset_x(direction, speed)
    @velocity_y = Gosu.offset_y(direction, speed)
  end

  def self.spawn_random(options)
    rand_x = Gosu.random(0, $window.width)
    rand_y = Gosu.random(0, $window.height)
    if Gosu.distance(rand_x, rand_y, options[:x], options[:y]) > 200 # Enemies will not spawn within this distance from the player
      rand_vel = random_velocity(*options[:speed_range])
      rand_spin = random_rotation_rate(*options[:spin_range])
      rand_scale = Gosu.random(*options[:scale_range])
      self.create(:x => rand_x, :y => rand_y, :zorder => 1, :velocity => rand_vel, :rotation_rate => rand_spin, :scale => rand_scale)
    end
  end

  private

  def self.random_velocity(min_speed, max_speed)
    rand_angle = Gosu.random(0, 360)
    rand_speed = Gosu.random(min_speed, max_speed)
    [Gosu.offset_x(rand_angle, rand_speed), Gosu.offset_y(rand_angle, rand_speed)]
  end

  def self.random_rotation_rate(min_spin, max_spin)
    # randomly determine if rotating clockwise or counter-clockwise
    rand_spin_direction = Gosu.random(0,2).to_i == 0 ? -1 : 1
    Gosu.random(min_spin, max_spin) * rand_spin_direction
  end
end
