@tool
extends PanelContainer

# number of lesson, lesson time, auditorum, campus_id
@onready var lesson_info_label: Label = $VBoxContainer/LessonInfo
@onready var photo_rect: TextureRect = $VBoxContainer/HBoxContainer/PhotoRect
@onready var lesson_name_and_teacher: RichTextLabel = $VBoxContainer/HBoxContainer/LessonNameAndTeacher

@export var lesson_info : String
@export var teacher : String
@export var discipline_name : String
@export var photo : Texture2D

@export var disc_id : int

func _ready() -> void:
	lesson_info_label.text = lesson_info
	photo_rect.texture = photo
	lesson_name_and_teacher.text = "[b]"+discipline_name+"[/b]\n"+teacher


func _on_gui_input(event: InputEvent) -> void:
	if event is InputEventScreenTouch and event.is_released():
		return
		#print("left" if event.position.x < global_position.x + size.x/2 else "right")
		Globals.current_disc_id = disc_id
		Globals.current_disc_name = discipline_name
		Globals.redirect_from = Globals.RedirectFrom.Timetable
		get_tree().change_scene_to_file("res://Scenes/discipline_rating.tscn")

func _on_button_pressed() -> void:
	print(disc_id)
	Globals.current_disc_id = disc_id
	Globals.current_disc_name = discipline_name
	Globals.redirect_from = Globals.RedirectFrom.Timetable
	get_tree().change_scene_to_file("res://Scenes/discipline_rating.tscn")
