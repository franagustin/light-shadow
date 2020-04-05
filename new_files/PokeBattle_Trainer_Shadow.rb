class PokeBattle_Trainer

  def get_opacity
    return 150 if self.hidden? else 255
  end

  def hide(steps=SHADOW_POINTS)
    val = SHADOW_BY_STEPS ? steps : true
    @hidden_status = val if !@shadow_points.nil? && @shadow_points > 0
    Shadow_Utilities.check_player_charset
  end

  def hidden?
    val = !@hidden_status.nil?
    val &= !@shadow_points.nil? && @shadow_points > 0
    if SHADOW_BY_STEPS
      return val && @hidden_status > 0
    end
    return val && @hidden_status
  end

  def unhide
    @hidden_status = SHADOW_BY_STEPS ? 0 : false
    Shadow_Utilities.check_player_charset
  end

  def process_hidden_status
    self.set_shadow_default_values
    if self.hidden?
      @shadow_points -= 1 if @shadow_points > 0
      @hidden_status -= 1 if SHADOW_BY_STEPS && @hidden_status > 0
      if @shadow_points <= 0 || (SHADOW_BY_STEPS && @hidden_status <= 0)
        self.unhide
      end
    elsif self.shadow_recovery_count < SHADOW_RECOVERY_RATE
      @shadow_recovery_count += 1
    elsif @shadow_points < SHADOW_POINTS
      @shadow_points += 1
      @shadow_recovery_count = 0
    end
  end

  def set_shadow_default_values
    @hidden_status = SHADOW_BY_STEPS ? 0 : false if self.hidden_status.nil?
    @shadow_points = SHADOW_POINTS if self.shadow_points.nil?
    @shadow_recovery_count = 0 if self.shadow_recovery_count.nil?
  end

end
