extends Node

var current_Scene = null

# Key: Name; Value: Packed Scene
var scenes = {
	"MAIN_MENU": preload("res://Scenes/main_menu.tscn"),
	"LOBBY": preload("res://Scenes/Levels/lobby.tscn"),
	}


func _ready():
	var root = get_tree().root
	current_Scene = root.get_child(root.get_child_count() - 1)
	


# Only the server can RPC switch scenes
@rpc("authority")
func switch_scene(name: String):
	if !scenes.has(name):
		print("Error! Scene does not exist!")
		return
	
	# Wait till idle time to free the scene and load the new one
	call_deferred("_deferred_switch_scene", name)
	


func _deferred_switch_scene(name: String):
	current_Scene.free()
	get_tree().change_scene_to_packed(scenes[name])
	
	var root = get_tree().root
	current_Scene = root.get_child(root.get_child_count() - 1)
