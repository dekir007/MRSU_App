@tool
extends MarginContainer

@export var faculty_name : String
@onready var label: Label = $MarginContainer/Label

func _ready() -> void:
	label.text = faculty_name
