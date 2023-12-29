extends Control

@onready var message_container = preload("res://Scenes/UI Elements/message_container.tscn")
@onready var messages: VBoxContainer = %Messages

@onready var disc_name_label: Label = %DiscNameLabel
@onready var scroll_container: ScrollContainer = $VBoxContainer/MessagesMarginContainer/ScrollContainer
@onready var text_message_edit: TextEdit = %TextMessageEdit

var check_kb : bool = false

func _ready() -> void:
	disc_name_label.text = Globals.current_disc_name
	# auto scroll
	scroll_container.get_v_scroll_bar().changed.connect(self.scroll_to_end)
	
	var response = await CommunicationService.get_communication()
	parse_response(response)

func _process(delta: float) -> void:
	if check_kb:
		if DisplayServer.virtual_keyboard_get_height() == 0:
			text_message_edit.release_focus()

func parse_response(response : Array):
	for message_data in response:
		var message = message_container.instantiate()
		message.sender_name = message_data["User"]["FIO"]
		message.message = message_data["Text"] if message_data["Text"] != null else ""
		message.time = Globals.get_hh_mm_from_date(message_data["CreateDate"])
		messages.add_child(message)

func scroll_to_end():
	scroll_container.scroll_vertical = ceili(scroll_container.get_v_scroll_bar().max_value)

func _on_send_btn_pressed() -> void:
	var text = %TextMessageEdit.text
	pass # sending message 

func _notification(what):
	if (what == NOTIFICATION_WM_GO_BACK_REQUEST):
		print("focus ",text_message_edit.has_focus())
		if text_message_edit.has_focus():
			text_message_edit.release_focus()
		#if DisplayServer.virtual_keyboard_get_height() > 0:
			#position.y = 0
			#text_message_edit.text = "back changed to 0"
			#await get_tree().create_timer(0.5).timeout
			#
			#text_message_edit.release_focus()
		else:
			get_tree().change_scene_to_file("res://Scenes/main.tscn")

func _input(event: InputEvent) -> void:
	if event is InputEventKey and event.keycode == KEY_ESCAPE and event.is_released():
		if text_message_edit.has_focus():
			text_message_edit.release_focus()
		else:
			get_tree().change_scene_to_file("res://Scenes/main.tscn")


func _on_text_message_edit_focus_entered() -> void:
	await get_tree().create_timer(0.5).timeout
	position.y = clamp(-DisplayServer.virtual_keyboard_get_height()+160, -1000, 0)#DisplayServer.virtual_keyboard_get_height()
	text_message_edit.text ="screen size: " + str(DisplayServer.screen_get_size()) + "; usable rect: " + str(DisplayServer.screen_get_usable_rect()) + "; kb_height: "+str(DisplayServer.virtual_keyboard_get_height())
	check_kb = true
	
func _on_text_message_edit_focus_exited() -> void:
	position.y = 0
	text_message_edit.text = "focus changed to 0"
	check_kb = false
