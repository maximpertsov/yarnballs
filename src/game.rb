class Game < Chingu::Window
  attr_reader :font, :music

  WINDOW_SIZE = [800, 600]
  BACKGROUND_IMAGE = "nebula_blue.s2014.png"
  GAME_FONT = "synchro_let.ttf"
  
  def initialize
    super(*WINDOW_SIZE, false)
    @background = Gosu::Image[BACKGROUND_IMAGE]
    @font = Gosu::Font[GAME_FONT, 50]
    push_game_state(Intro)
  end

  def update
    super
  end
  
  def draw
    super
    @background.draw(0, 0, 0)
  end
end
