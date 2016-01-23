class Player < Chingu::GameObject
  include ScreenWrapping, Shooting, CollisionEffects
  
  traits :timer, :velocity, :effect, :collision_detection
  trait :bounding_circle, :scale => 0.5
  
  THRUST_SOUND = "thrusters_launch.ogg"
  ACCELERATION = 0.5
  TURN_SPEED = 4.5
  FRICTION = 0.05
  
  def initialize(options = {})
    @animation = Chingu::Animation.new(:file => "double_ship.png", :size => [90, 90])
    @image = @animation.first
    super(options)
    @init_color = @color
    @thrust_sound = Gosu::Sound[THRUST_SOUND]
    @missile = Missile
    @shot_type = :wave
    @rapid_shot = false
    
    self.input = {:holding_left => :turn_left,
                  :holding_right => :turn_right,
                  :holding_up => :thrust_on,
                  :released_up => :thrust_off,
                  :space => :regular_shot,
                  :holding_space => :rapid_shot}
  end
  
  def update
    super
    screen_wrap
    apply_friction
  end
  
  def ship_front
    @angle + 90
  end

  def cannon_x
    @x + Gosu.offset_x(ship_front, self.radius)
  end
  
  def cannon_y
    @y + Gosu.offset_y(ship_front, self.radius)
  end
  
  def turn_left
    @angle -= TURN_SPEED
  end

  def turn_right
    @angle += TURN_SPEED
  end
  
  def thrust_on
    @image = @animation.last
    @acceleration_x = Gosu.offset_x(self.ship_front, ACCELERATION)
    @acceleration_y = Gosu.offset_y(self.ship_front, ACCELERATION)
    @thrust_sample = @thrust_sound.play if @thrust_sample.nil? || !@thrust_sample.playing?
  end

  def thrust_off
    @image = @animation.first
    self.acceleration = [0, 0]
    @thrust_sample.stop if !@thrust_sample.nil? && @thrust_sample.playing?
    @thrust_sample = nil
  end

  def apply_friction
    @velocity_x -= @velocity_x * FRICTION
    @velocity_y -= @velocity_y * FRICTION
  end

  def explode!
    Explosion.create(:x => @x, :y => @y, :zorder => 2)
    self.input = nil
    self.destroy
  end

  def basic_shot(modifiers = {})
    super({:x => self.cannon_x, :y => self.cannon_y, :angle => self.ship_front}.merge(modifiers))
  end

  def regular_shot
    unless @rapid_shot
      case @shot_type
      when :normal
        self.normal_shot
      when :wave
        self.wave_shot
      when :explosive
        self.explosive_shot
      end
    end
  end
  
  def rapid_shot
    super(100) if @rapid_shot
  end
    
  def bounce(other_object)
    direction = Gosu.angle(@x, @y, other_object.x, other_object.y) + 180
    speed = Vector.elements(self.velocity).magnitude
    @velocity_x = Gosu.offset_x(direction, speed)
    @velocity_y = Gosu.offset_y(direction, speed)
  end

  def pushed_back_by(other_object)
    direction = Gosu.angle(@x, @y, other_object.x, other_object.y) + 180
    distance = self.radius + other_object.radius
    @x = other_object.x + Gosu.offset_x(direction, distance)
    @y = other_object.y + Gosu.offset_y(direction, distance)
  end

  def knocked_back_by(other_object)
    direction = Gosu.angle(@x, @y, other_object.x, other_object.y) + 180
    speed = Vector.elements(other_object.velocity).magnitude + 10
    @velocity_x = Gosu.offset_x(direction, speed)
    @velocity_y = Gosu.offset_y(direction, speed)
    during(500) {@rotation_rate = -(other_object.rotation_rate + 100)}.then {@rotation_rate = 0}
  end

  def self.spawn
    self.create(:x => $window.width / 2, :y => $window.height / 2, :z => 1)
  end
end
