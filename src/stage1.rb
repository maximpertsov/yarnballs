class Stage1 < Chingu::GameState
  STAGE_MUSIC = ""
  
  def initialize
    super
    self.input = {:escape => :close}
    spawn_player
    @stage_music = nil # Gosu::Song[STAGE_MUSIC]
  end

  def setup
    Enemy.destroy_all
    @stage_music.play(true) unless @stage_music.nil?
  end
  
  def update
    super
    spawn_player if Player.size == 0
    Enemy.spawn_random(:x => @player.x, :y => @player.y, :speed_range => [1, 5], :spin_range => [1, 5], :scale_range => [0.25, 0.75]) if Enemy.size < 5
    enemy_enemy_collisions
    player_enemy_collisions
    player_fireball_collisions
    missile_enemy_collisions
    explosion_enemy_collisions
  end

  def finalize
    @stage_music.stop unless @stage_music.nil?
  end

  def enemy_enemy_collisions
    Enemy.each_bounding_circle_collision(Enemy) do |e1, e2|
      e1.bounce(e2)
    end
  end

  def player_enemy_collisions
    Player.each_bounding_circle_collision(Enemy) do |p, e|
      p.flash_red(500)
      p.knocked_back_by(e)
    end
  end

  def player_fireball_collisions
    Player.each_bounding_circle_collision(Fireball) do |p, f|
      #p.flash_red(500)
      p.explode!
    end
  end

  def missile_enemy_collisions
    Missile.each_bounding_circle_collision(Enemy) do |m, e|
      e.flash_red(50)
      e.reduce_health_by(m.damage)
      m.explode!
    end
  end

  def explosion_enemy_collisions
    Explosion.each_bounding_circle_collision(Enemy) do |ex, e|
      e.flash_red(50)
      e.reduce_health_by(ex.damage)
    end
  end

  def spawn_player
    Player.spawn
    @player = Player.all.first
  end
end
