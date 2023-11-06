extends PanelContainer

@export var sender_name:String = "Name placeholder"
@export var message:String = "Lorem ipsum"
@export var time:String = "12:15"

@onready var name_label: Label = %NameLabel
@onready var message_label: Label = %MessageLabel
@onready var time_label: Label = %TimeLabel

func _ready() -> void:
	name_label.text = sender_name
	message_label.text = message
	time_label.text = time
