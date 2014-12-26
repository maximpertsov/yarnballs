class Intro < Chingu::GameState
  def initialize
    Debris.create
    super
    self.input = {:space => Stage1,
                  :escape => :close_game}
  end

  def draw
    super
    $window.font.draw_rel("PRESS SPACE TO BEGIN", $window.width / 2, $window.height / 2, 10, 0.5, 0.5, 1, 1, Gosu::Color::GREEN) #Chingufy?
  end
end
