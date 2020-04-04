# Instructions

1. Create these files in RPG Maker XP's script editor and copy their content.
1. Insert following lines at the end of Settings:
```
#===============================================================================
# * Set $Trainer.hidden_status to number of steps or just active/inactive?
# * Number of steps needed to recover 1 shadow point (integer greater than 1)
# * Max shadow points
# * Text to append to charset graphic name when player is hidden
#===============================================================================
SHADOW_BY_STEPS = true
SHADOW_RECOVERY_RATE = 5
SHADOW_POINTS = 100
SHADOW_CHARSET_SUFFIX = '_shadow'
```
1. Search inside Game_Player for all lines matching
`if not event.jumping? and not event.over_trigger?`
and add right after it the following one:
`return result if !Shadow_Utilities.trigger_while_hidden?(event)`
except the one in **pbTriggeredTrainerEvents** method.
1. Search for `if not event.jumping? and not event.over_trigger?` in **pbTriggeredTrainerEvents** method and replace it with:
`if not event.jumping? and not event.over_trigger? and not $Trainer.hidden?`
1. Search in Game_Player for this line: `ret=meta[1] if !ret || ret==""`
add right after it the following one: `ret += SHADOW_CHARSET_SUFFIX if trainer.hidden?`
1. In Game_Player find the following line:
`return true if pbGetMetadata(mapid,MetadataBicycleAlways)`
and add this one after it: `val = !$Trainer.hidden?`
1. Search for `pbMapInterpreterRunning?` in Game_Player_Visuals and replace that line with: `pbMapInterpreterRunning? || $Trainer.hidden?`
1. Search for `repel = ($PokemonGlobal.repel>0)` in PField_Field and add the following line right below it: `$Trainer.process_hidden_status`
1. In PField_FieldMoves search for `def self.triggerConfirmUseMove(item,pokemon)` and add this after it: `return false if !Shadow_Utilities.confirm_field_movement`
1. In PField_FieldMoves find `def Kernel.pbConfirmUseHiddenMove(pokemon,move)` and add this right below it: `return false if $Trainer.hidden? && !Shadow_Utilities.prompt_for_unhide`
1. In PField_FieldMoves replace:
* `if Kernel.pbConfirmMessage(_INTL("Would you like to cut it?"))`
```
  if Kernel.pbConfirmMessage(_INTL("Would you like to cut it?")) \`
  && Shadow_Utilities.confirm_field_movement
```

* `if Kernel.pbConfirmMessage(_INTL("A Pokémon could be in this tree. Would you like to use Headbutt?"))`
```
  if Kernel.pbConfirmMessage(_INTL(
    "A Pokémon could be in this tree. Would you like to use Headbutt?"
  )) && Shadow_Utilities.confirm_field_movement
```

* `if Kernel.pbConfirmMessage(_INTL("This rock appears to be breakable. Would you like to use Rock Smash?"))`
```
  if Kernel.pbConfirmMessage(_INTL(
    "This rock appears to be breakable. Would you like to use Rock Smash?"
  )) && Shadow_Utilities.confirm_field_movement
```

* `if Kernel.pbConfirmMessage(_INTL("Would you like to use Strength?"))`
```
  if Kernel.pbConfirmMessage(_INTL("Would you like to use Strength?")) \
  && Shadow_Utilities.confirm_field_movement
```

* `if Kernel.pbConfirmMessage(_INTL("The water is a deep blue...\nWould you like to surf on it?"))`
```
  if Kernel.pbConfirmMessage(_INTL(
    "The water is a deep blue...\nWould you like to surf on it?"
  )) && Shadow_Utilities.confirm_field_movement
```

* `if Kernel.pbConfirmMessage(_INTL("It's a large waterfall. Would you like to use Waterfall?"))`
```
  if Kernel.pbConfirmMessage(_INTL(
    "It's a large waterfall. Would you like to use Waterfall?"
  )) && Shadow_Utilities.confirm_field_movement
```

1. In PokeBattle_Trainer find `attr_accessor(:language)` and add the following lines after it:
```
  attr_accessor(:hidden_status)
  attr_accessor(:shadow_points)
  attr_accessor(:shadow_recovery_count)
```

1. In PokeBattle_Trainer find `@party=[]` and add below it: `self.set_shadow_default_values`

1. In PScreen_PauseMenu search for `commands[cmdSave = commands.length]   = _INTL("Save") if $game_system && !$game_system.save_disabled` and add below:
```
      if $Trainer.hidden?
        if SHADOW_BY_STEPS
          @scene.pbShowInfo(_INTL(
            "Shadow Points: {1}/{2}\nRemaining steps: {3}",
            $Trainer.shadow_points, SHADOW_POINTS, $Trainer.hidden_status
          ))
        else
          @scene.pbShowInfo(_INTL(
            "Shadow Points {1}/{2}", $Trainer.shadow_points, SHADOW_POINTS
          ))
        end
      end
```

1. Search for `@sprites["player"].src_rect = Rect.new(0,0,charwidth/4,charheight/4)` in PScreen_Load and add this line after it: `@sprites["player"].opacity = 150 if trainer.hidden? else 255`
