# Shadow System

With this shadow system, you can avoid both trainer and wild battles by hiding in shadows.

## New Files

1. Create two new files in RPG Maker XP's script editor names:
  * PokeBattle_Trainer_Shadow
  * Shadow_Utilities
1. Copy the content of this files from within **new_files** folder and paste them at the script editor.

## Edited Files

### Blank Project

If you haven't edited any of the files which name matches those inside **edited_files** folder, just copy and paste their content at the script editor (each one on the tab they are named after).


### Edited Project

For any file you have already changed, you can install this system by adding or replacing the following lines.

#### Settings

1. **Insert following lines at the end**
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

#### Game_Player

1. **Search**: `if not event.jumping? and event.over_trigger?`
   **Add below**: `return result if !Shadow_Utilities.trigger_while_hidden?(event)`
1. **Find both occurrences of**: `if not event.jumping? and !event.over_trigger?`
   **Add below**: `return result if !Shadow_Utilities.trigger_while_hidden?(event)`
1. **Search just in method named check_event_trigger_touch**: `if not event.jumping? and not event.over_trigger?`
   **Add below**: `return result if !Shadow_Utilities.trigger_while_hidden?(event)`
1. **Search just in method called pbTriggeredTrainerEvents**: `if not event.jumping? and not event.over_trigger?`
   **Replace with**: `if not event.jumping? and not event.over_trigger? and not $Trainer.hidden?`
1. **Search**: `ret=meta[1] if !ret || ret==""`
   **Add below**: `ret += SHADOW_CHARSET_SUFFIX if trainer.hidden?`
1. **Search**: `return true if pbGetMetadata(mapid,MetadataBicycleAlways)`
   **Add below**: `val = !$Trainer.hidden?`

#### Game_Player_Visuals

1. **Search**: `pbMapInterpreterRunning?`
   **Replace with**: `pbMapInterpreterRunning? || $Trainer.hidden?`
1. **Search**: `return @defaultCharacterName if @defaultCharacterName!=""` 
   **Add below**: `@opacity = $Trainer.get_opacity`

#### PField_Field

1. **Search**: `repel = ($PokemonGlobal.repel>0)`
   **Add below**: `$Trainer.process_hidden_status`
1. **Search**: `return if $Trainer.ablePokemonCount==0`
   **Add below**: `return if $Trainer.hidden?`

#### PField_Field_Moves

1. **Search**: `def self.triggerConfirmUseMove(item,pokemon)`
   **Add below**: `return false if !Shadow_Utilities.confirm_field_movement`
1. **Search**: `def Kernel.pbConfirmUseHiddenMove(pokemon,move)`
   **Add below**: `return false if $Trainer.hidden? && !Shadow_Utilities.prompt_for_unhide`
1. **Search**: `if Kernel.pbConfirmMessage(_INTL("Would you like to cut it?"))`
   **Replace with**:
   ```
     if Kernel.pbConfirmMessage(_INTL("Would you like to cut it?")) \`
     && Shadow_Utilities.confirm_field_movement
   ```
1. **Search**: `if Kernel.pbConfirmMessage(_INTL("A Pokémon could be in this tree. Would you like to use Headbutt?"))`
   **Replace with**:
   ```
     if Kernel.pbConfirmMessage(_INTL(
       "A Pokémon could be in this tree. Would you like to use Headbutt?"
     )) && Shadow_Utilities.confirm_field_movement
   ```
1. **Search**: `if Kernel.pbConfirmMessage(_INTL("This rock appears to be breakable. Would you like to use Rock Smash?"))`
   **Replace with**:
   ```
     if Kernel.pbConfirmMessage(_INTL(
       "This rock appears to be breakable. Would you like to use Rock Smash?"
     )) && Shadow_Utilities.confirm_field_movement
   ```
1. **Search**: `if Kernel.pbConfirmMessage(_INTL("Would you like to use Strength?"))`
   **Replace with**:
   ```
     if Kernel.pbConfirmMessage(_INTL("Would you like to use Strength?")) \
     && Shadow_Utilities.confirm_field_movement
   ```
1. **Search**: `if Kernel.pbConfirmMessage(_INTL("The water is a deep blue...\nWould you like to surf on it?"))`
   **Replace with**:
   ```
     if Kernel.pbConfirmMessage(_INTL(
       "The water is a deep blue...\nWould you like to surf on it?"
     )) && Shadow_Utilities.confirm_field_movement
   ```
1. **Search**: `if Kernel.pbConfirmMessage(_INTL("It's a large waterfall. Would you like to use Waterfall?"))`
   **Replace with**:
   ```
     if Kernel.pbConfirmMessage(_INTL(
       "It's a large waterfall. Would you like to use Waterfall?"
     )) && Shadow_Utilities.confirm_field_movement
   ```

#### PokeBattle_Trainer

1. **Search**: `attr_accessor(:language)`
   **Add below**:
   ```
     attr_accessor(:hidden_status)
     attr_accessor(:shadow_points)
     attr_accessor(:shadow_recovery_count)
   ```
1. **Search**: `@party=[]`
   **Add below**: `self.set_shadow_default_values`

#### PScreen_PauseMenu

1. **Search**: `commands[cmdSave = commands.length]   = _INTL("Save") if $game_system && !$game_system.save_disabled`
   **Add below**:
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

#### PScreen_Load

1. **Search**: `@sprites["player"].src_rect = Rect.new(0,0,charwidth/4,charheight/4)`
1. **Add below**: `@sprites["player"].opacity = trainer.get_opacity`


## Usage

You can now use **$Trainer.hide steps (optional)**, **$Trainer.unhide** and **$Trainer.hidden?** in your own scripts or events.


# Light System

The light system is just a random item giver, you can set the items you want together with the chances of receiving each one.

## Installation

1. Insert a new tab at RPG Maker XP's script editor and paste there the contents of the **Light_Item.rb** file, which can be found inside **new_files** folder.

## Usage

You may use it in an event or a script just like this:

```
@li = Light_Item.new({
  :POTION => 30,
  :SUPERPOTION => 20,
  :HYPERPOTION => 10,
  :MAXPOTION => 1
})
@given = @li.sun_crest
```

* **Remaining percentage will be the chances of receiving nothing**
* **@given will be true if the item is chosen, even if you receive nothing.**
