extends Control

@onready var disc_name_label: Label = %DiscNameLabel
@onready var groups: VBoxContainer = %Groups
@onready var date_input: LineEdit = %DateInput

@onready var group_container_scene = preload("res://Scenes/UI Elements/group_container.tscn")

var data : Array

func _ready() -> void:
	data = await TimetableService.get_time_table()
	#print(JSON.stringify(data, "\t"))
	parse_data()
	

func parse_data():
	for group in data:
		print(groups.size)
		var group_container = group_container_scene.instantiate()
		group_container.group_name = group["FacultyName"] + " (" + group["Group"] + " группа)"
		#print(group["TimeTable"]["Lessons"])
		group_container.lessons_data = group["TimeTable"]["Lessons"]
		groups.add_child(group_container)

func _on_button_button_up() -> void:
	for child in groups.get_children():
		child.queue_free()
	data = await TimetableService.get_time_table(date_input.text)
	parse_data()
