module ScreenWrapping
  
  def screen_wrap
    @x = @x % $window.width
    @y = @y % $window.height
  end

end
