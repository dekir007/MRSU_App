@tool
extends MarginContainer

@export var discipline_name : String

var discipline_id : int
var redirect : Globals.RedirectTarget

@onready var label: Label = $MarginContainer/Label

func _ready() -> void:
	label.text = discipline_name

func _on_button_pressed() -> void:
	Globals.current_disc_id = discipline_id
	Globals.current_disc_name = discipline_name
	match redirect:
		Globals.RedirectTarget.Discipline:
			get_tree().change_scene_to_file("res://Scenes/discipline_rating.tscn")
		Globals.RedirectTarget.Communication:
			get_tree().change_scene_to_file("res://Scenes/communication.tscn")
	#get_tree().change_scene_to_file()
