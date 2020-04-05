class Shadow_Utilities

  def self.check_player_charset
    if $PokemonGlobal.surfing || $PokemonGlobal.diving
        char_id = $PokemonGlobal.surfing ? 3 : 5
        meta = pbGetMetadata(0,MetadataPlayerA+$PokemonGlobal.playerID)
        $game_player.character_name = pbGetPlayerCharset(meta, char_id)
    end
  end

  def self.confirm_field_movement
    return $Trainer.hidden? ? self.prompt_for_unhide : true
  end

  def self.dispels_shadows?(name)
    return name[/Trainer\((\d+)\)/] || name.include?('[DS]')
  end

  def self.prompt_for_unhide
    unhide = Kernel.pbConfirmMessage(_INTL(
      "This action will dispel the shadows surrounding you. Want to unhide?"
    ))
    $Trainer.unhide if unhide
    return unhide
  end

  def self.star_hide(steps=SHADOW_POINTS, no_rehide=true)
    hid = false
    if Kernel.pbConfirmMessage(_INTL("Want to hide in them?"))
      if $Trainer.hidden? && no_rehide
        Kernel.pbMessage(_INTL("You are already hidden."))
      elsif $Trainer.shadow_points <= 0
        Kernel.pbMessage(_INTL("You haven't got enough shadow power."))
      else
        $Trainer.hide steps
        hid = true
      end
    end
    return hid
  end

  def self.trigger_while_hidden?(event)
    if $Trainer.hidden? && Shadow_Utilities.dispels_shadows?(event.name)
      result = Shadow_Utilities.prompt_for_unhide
    else
      result = true
    end
    return result
  end

end
