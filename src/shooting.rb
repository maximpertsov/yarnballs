module Shooting
  def basic_shot(modifiers = {})
    options = {:x => @x, :y => @y, :angle => @angle, :velocity_x => @velocity_x, :velocity_y => @velocity_y}
    @missile.shoot(options.merge(modifiers))
  end

  def normal_shot
    self.basic_shot
  end

  def wave_shot
    (-4..4).each do |angle_offset|
      self.basic_shot(:angle => 10 * angle_offset + @angle)
    end
  end

  def explosive_shot
    self.basic_shot(:color => Gosu::Color::RED, :scale => 1.5, :explosion_info => {:scale => 3, :color => Gosu::Color::RED, :damage => 0.1})
  end
  
  def rapid_shot(reload_time)
    unless @reloading
      self.basic_shot
      @reloading = true
      after(reload_time) {@reloading = false}
    end
  end

  # def aim_shot(target, reload_time)
  #   self.basic_shot
  # end
  
end
