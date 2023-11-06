@tool
extends MarginContainer

@onready var items: VBoxContainer = %Items
@onready var section_name: Label = %SectionName

@onready var control_point = preload("res://Scenes/UI Elements/control_point_container.tscn")

@export var sectionName : String

func _ready() -> void:
	section_name.text = sectionName

func add_new_control_point(controlPointName, details: Array[String]):
	var controlPoint = control_point.instantiate()
	controlPoint.controlPointName = controlPointName.strip_escapes() if controlPointName != null else "-"
	controlPoint.detailLines = details
	items.add_child(controlPoint)
