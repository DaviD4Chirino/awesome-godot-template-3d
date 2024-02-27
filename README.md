# godot-template

A personal __Godot Engine__ startup template. The general idea is that i grab this files and im ready to go.

It includes Blueprint code, addons and some ui screens

## Skeleton

Each system has its own autoload. And all signals originates form another autoload called `SignalBus` in `autoloads/SignalBus.gd`.

The only autoload loaded before `SignalBus` is `Global.gd` *(called in engine as simple `g`)*

### Systems

* `Global (g)` in `autoloads/global.gd`
  * a generic autoload, it contains information like the player node and the node of the current level
* `Scenes` in `autoloads/scenes.gd`
  * It contains paths of commonly used scenes. Like the main menu and the levels
* `AudioManager` in `autoloads/managers/AudioManager.gd`
* `Utility` in `autoloads/Utility.gd`
  * As in a bunch of functions that are needed in multiple places, but with one source
* `Level` in `classes/Level.gd`
  * The level manages the game state, for that it calls upon the methods: `pause_game`, `resume_game` and `restart_scene` *(Restart reloads the current level, or itself)* from `Utility.gd`
  * As a shared autoload with misc functions
* `SceneManager` in `autoloads/managers/SceneManager.gd`
* `onstart` in `autoloads/onstart.gd`
  * Its designed to be a autoload that runs first thing when the game starts, right now its loading input and audio customizations

### Premade Scenes

All of the below are instantiated in a `configuration_screen` in `scenes/screens/config/configuration_screen.tscn`

* `inputs_config` in `scenes/screens/config/inputs_config.tscn`
  * It lets you customize your inputs
* `audio_config` in `scenes/screens/config/audio_config.tscn`
  * also `audio_slider` in the same folder as a complement to the audio scene
* `screen_mode` in `scenes/screens/config/screen_mode.tscn`

Note: There was a screen resolution but it did not work when it was in full screen so it was scrapped
____

Apart from that and their respective helper scenes, theres a few to mention:

* `consent_screen` in `scenes/screens/consent_screen.tscn`
  * And the subsequently Utility function `create_consent_screen` *(instantiate the screen and adds them at the bottom of the tree, it returns the newly made screen so you connect the `accepted` signal to continue)* see it in action in the `restore_button` in `scenes/screens/config/restore_button.gd.gd`

## Addons

* `Save Made Easy` - by [AdamKormos](https://github.com/AdamKormos/SaveMadeEasy)
