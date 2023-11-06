extends TextureRect

#@onready var lang_menu : MenuButton = get_node("%LanguageMenu")
func _ready():
	pass

func _on_home_button_pressed():
	print('home')


func _on_enrollee_button_pressed():
	print('enrollee')


func _on_button_pressed() -> void:
	if !%Password.text.is_empty():
		AuthService.auth(%Username.text, %Password.text)
		await AuthService.token_recieved
	get_tree().change_scene_to_file("res://Scenes/main.tscn")
