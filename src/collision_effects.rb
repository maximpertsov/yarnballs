module CollisionEffects
  def flash_red(duration)
    during(duration) do
      if (Gosu.milliseconds).odd?
        @color = Gosu::Color::RED
        @mode = :additive
      else
        @color = @init_color
        @mode = :default
      end
    end.then do
      @color = @init_color
      @mode = :default
    end
  end
end
