class Explosion < Chingu::GameObject
  traits :velocity, :collision_detection
  trait :bounding_circle, :scale => 0.7
  attr_reader :damage
  
  IMAGE_FILE = "explosion_alpha.png"
  TILE_SIZE = [128, 128]
  INIT_DELAY = 25
  SOUND_FILE = "explosion-01.ogg"
  
  def initialize(options)
    @animation = Chingu::Animation.new(:file => IMAGE_FILE, :size => TILE_SIZE, :loop => false, :delay => INIT_DELAY)
    super(options.merge(:image => @animation.first, :mode => :additive))
    @damage = options[:damage] || 0
    Gosu::Sound[SOUND_FILE].play
  end

  def setup
    @image = @animation.first
  end
  
  def update
    super
    animate
  end
  
  def animate
    @image = @animation.next
    self.destroy if @animation.last_frame?
  end
end
