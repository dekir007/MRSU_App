@tool
extends PanelContainer

@onready var items: VBoxContainer = %Items
@onready var control_point_name: Label = %ControlPointName

@onready var labelScene : PackedScene = preload("res://Scenes/UI Elements/AuxiliaryElements/rich_text_label.tscn")

@export var controlPointName : String
@export var detailLines : Array[String]

func _ready() -> void:
	control_point_name.text = controlPointName
	for detail in detailLines:
		var label = labelScene.instantiate()
		label.mouse_filter = MOUSE_FILTER_PASS
		label.text = detail
		items.add_child(label)
