extends Control

@onready var message_container = preload("res://Scenes/UI Elements/message_container.tscn")
@onready var messages: VBoxContainer = %Messages

@onready var disc_name_label: Label = %DiscNameLabel
@onready var scroll_container: ScrollContainer = $VBoxContainer/MessagesMarginContainer/ScrollContainer

func _ready() -> void:
	disc_name_label.text = Globals.current_disc_name
	# auto scroll
	scroll_container.get_v_scroll_bar().changed.connect(self.scroll_to_end)
	
	var response = await CommunicationService.get_communication()
	parse_response(response)

func parse_response(response : Array):
	for message_data in response:
		var message = message_container.instantiate()
		message.sender_name = message_data["User"]["FIO"]
		message.message = message_data["Text"]
		message.time = Globals.get_hh_mm_from_date(message_data["CreateDate"])
		messages.add_child(message)

func scroll_to_end():
	scroll_container.scroll_vertical = ceili(scroll_container.get_v_scroll_bar().max_value)

func _on_send_btn_pressed() -> void:
	var text = %TextMessageEdit.text
	pass # sending message 

func _on_return_btn_pressed() -> void:
	get_tree().change_scene_to_file("res://Scenes/main.tscn")
