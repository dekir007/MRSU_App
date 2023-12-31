extends Control

func _ready() -> void:
	
	if await Globals.get_token_from_disk() == OK:
		get_tree().call_deferred("change_scene_to_file", "res://Scenes/main.tscn")
	else:
		get_tree().call_deferred("change_scene_to_file", "res://Scenes/login.tscn")
