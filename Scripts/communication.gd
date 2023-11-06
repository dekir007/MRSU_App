extends Control

@onready var http_request: HTTPRequest = $HTTPRequest
@onready var message_container = preload("res://Scenes/UI Elements/message_container.tscn")
@onready var messages: VBoxContainer = %Messages

@onready var disc_name_label: Label = %DiscNameLabel
@onready var scroll_container: ScrollContainer = $VBoxContainer/MessagesMarginContainer/ScrollContainer

func _ready() -> void:
	disc_name_label.text = Globals.current_disc_name
	http_request.request(Globals.base_url+"v1/ForumMessage?disciplineId="+str(Globals.current_disc_id),
						 Globals.get_auth_header(),
						 HTTPClient.METHOD_GET)
	
func _on_http_request_request_completed(result: int, response_code: int, _headers: PackedStringArray, body: PackedByteArray) -> void:
	if result != HTTPRequest.RESULT_SUCCESS:
		return
	if response_code == 401:
		return
	var response = JSON.parse_string(body.get_string_from_utf8())
	response.reverse()
	for message_data in response:
		var message = message_container.instantiate()
		message.sender_name = message_data["User"]["FIO"]
		message.message = message_data["Text"]
		message.time = Globals.get_hh_mm_from_date(message_data["CreateDate"])
		messages.add_child(message)
	#TODO 
	await get_tree().create_timer(0.1).timeout
	scroll_container.set_deferred("scroll_vertical",100000)


func _on_send_btn_pressed() -> void:
	var text = %TextMessageEdit.text
	pass # sending message 


func _on_return_btn_pressed() -> void:
	get_tree().change_scene_to_file("res://Scenes/main.tscn")
