class Debris < Chingu::GameObject
  include ScreenWrapping
  
  traits :timer, :velocity
  
  IMAGE_FILE = "debris2_blue.png"
  
  def initialize(options = {})
    super(options.merge(:image => IMAGE_FILE, :x => $window.width / 2, :y => $window.height, :velocity_x => 0.4, :scale => 3))
  end
  
  def update
    super
    screen_wrap
  end
end
