extends VBoxContainer

@onready var profile : PackedScene = preload("res://Scenes/MainTabs/profile.tscn")
@onready var subjects : PackedScene = preload("res://Scenes/MainTabs/subjects.tscn")
@onready var time_table : PackedScene = preload("res://Scenes/time_table.tscn")
@onready var main: Control = %MainControl

@onready var profile_button: TextureButton = $Control2/Footer/HBoxContainer/ProfileButton
@onready var subjects_button: TextureButton = $Control2/Footer/HBoxContainer/SubjectsButton
@onready var communication_button: TextureButton = $Control2/Footer/HBoxContainer/CommunicationButton
@onready var time_table_button: TextureButton = $Control2/Footer/HBoxContainer/TimeTableButton


var current_tab : Control 
var current_tab_id : Globals.RedirectFrom

func _ready() -> void:
	match Globals.redirect_from:
		Globals.RedirectFrom.Profile:
			current_tab_id = -1
			change_tabs(profile, Globals.RedirectFrom.Profile)
		Globals.RedirectFrom.Communication:
			current_tab_id = 0 # TODO
			change_tabs(subjects, Globals.RedirectFrom.Communication)
		Globals.RedirectFrom.Discipline:
			current_tab_id = 0 # TODO
			change_tabs(subjects, Globals.RedirectFrom.Discipline)
		

func _on_profile_button_pressed():
	change_tabs(profile, Globals.RedirectFrom.Profile)

func _on_subjects_button_pressed():
	change_tabs(subjects, Globals.RedirectFrom.Discipline)

func _on_communication_button_pressed() -> void:
	change_tabs(subjects, Globals.RedirectFrom.Communication)

func _on_time_table_button_pressed() -> void:
	change_tabs(time_table, Globals.RedirectFrom.Timetable)

func change_tabs(tab : PackedScene, new_id : Globals.RedirectFrom):
	if new_id == current_tab_id:
		return
	match current_tab_id:
		Globals.RedirectFrom.Profile:
			profile_button.material.set_shader_parameter("focus_color", Vector3(0.95,0.95,0.95))
		Globals.RedirectFrom.Discipline:
			subjects_button.material.set_shader_parameter("focus_color", Vector3(0.95,0.95,0.95))
		Globals.RedirectFrom.Communication:
			communication_button.material.set_shader_parameter("focus_color", Vector3(0.95,0.95,0.95))
		Globals.RedirectFrom.Timetable:
			time_table_button.material.set_shader_parameter("focus_color", Vector3(0.95,0.95,0.95))
	
	get_previous_tab_away_anim(current_tab)
	current_tab = tab.instantiate()
	
	match new_id:
		Globals.RedirectFrom.Profile:
			Globals.redirect_from = Globals.RedirectFrom.Profile
			profile_button.material.set_shader_parameter("focus_color", Vector3.ZERO)
		Globals.RedirectFrom.Discipline:
			Globals.redirect_from = Globals.RedirectFrom.Discipline
			subjects_button.material.set_shader_parameter("focus_color", Vector3.ZERO)
		Globals.RedirectFrom.Communication:
			Globals.redirect_from = Globals.RedirectFrom.Communication
			communication_button.material.set_shader_parameter("focus_color", Vector3.ZERO)
		Globals.RedirectFrom.Timetable:
			Globals.redirect_from = Globals.RedirectFrom.Timetable
			time_table_button.material.set_shader_parameter("focus_color", Vector3(1,0,0))
	main.add_child(current_tab)
	main.move_child(current_tab,0)
	
	current_tab_id = new_id
	print(Globals.redirect_from)

func get_previous_tab_away_anim(previous_tab : Control):
	if previous_tab == null:
		return
	var t = get_tree().create_tween()
	t.tween_property(current_tab, "scale", Vector2(1.1,1.1), 0.3).from(Vector2.ONE)
	t.tween_property(current_tab, "position:x", 1200, 0.3).from(0)
	t.play()
	t.finished.connect(func(): previous_tab.queue_free())



