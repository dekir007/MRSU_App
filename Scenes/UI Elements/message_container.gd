extends PanelContainer

@export var sender_name:String = "Name placeholder"
@export var message:String = "Lorem ipsum"
@export var time:String = "12:15"

@export var message_id : int
@export var sender_id : String

@onready var name_label: Label = %NameLabel
@onready var message_label: Label = %MessageLabel
@onready var time_label: Label = %TimeLabel
@onready var delete_button: Button = %DeleteButton

func _ready() -> void:
	name_label.text = sender_name
	message_label.text = message
	time_label.text = time
	
	if sender_id == ProfileService.profile["Id"]:
		print("it's mine!")
		modulate = Color(192./256., 112./256., 234./256., .75)
		delete_button.show()

func _on_delete_button_pressed() -> void:
	CommunicationService.delete(message_id)
	print("deleted!")
	queue_free()
