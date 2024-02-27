## Here are all the saved variables in your project, call them as SavePaths.*
## For better casting, write a comment expecting the type of the variable, see below
class_name SavePaths

## Dictionary: {"bus_index": "volume_db"}
static var audio_settings: String = "audio_levels"
## Dictionary: {
##	"action_name": {
##	InputEvent
## }
##	}
## its necessary to reconstruct the event into a proper InputEvent, 
##for this you can use SaveSystem._dict_to_resource, 
## for the class, each event has a custom "class" key
static var input_map: String = "input_map"

## Int: see DisplayServer.WindowMode for reference
static var video_settings: String = "video_settings"