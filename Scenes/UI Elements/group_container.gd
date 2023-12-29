extends VBoxContainer

@export var group_name : String

@onready var collapsible_container: Control = $CollapsibleContainer
#@onready var button: Button = $Button
@onready var lessons: VBoxContainer = %Lessons
@onready var label: Label = $PanelContainer/Label

@onready var lesson_container_scene = preload("res://Scenes/UI Elements/lesson_container.tscn")
@onready var no_lessons_scene = preload("res://Scenes/UI Elements/AuxiliaryElements/no_lessons.tscn")
var lessons_data : Array

func _ready() -> void:
	print(group_name, collapsible_container.size, size)
	label.text = group_name
	parse_lessons_data()
	#collapsible_container.custom_minimum_size = Vector2(100000,100000)
	#collapsible_container.custom_minimum_size = Vector2.ZERO
	#collapsible_container.custom_minimum_size = Vector2.ZERO
	#propagate_notification(NOTIFICATION_RESIZED)



func parse_lessons_data():
	if lessons_data.is_empty():
		var no_lessons = no_lessons_scene.instantiate()
		lessons.add_child(no_lessons)
	else:
		var time = ["8:30 - 10:00", "10:10 - 11:40", "12:00 - 13:30", "13:45 - 15:15", "15:25 - 16:55", "17:05 - 18:35", "18:40 - 20:10"]
		for lesson in lessons_data:
			var lesson_container = lesson_container_scene.instantiate()
			#3. 10:10 - 11:40 211 (к.1)
			lesson_container.lesson_info = str(lesson["Number"]) + ". " + time[lesson["Number"] - 1] + " " + lesson["Disciplines"][0]["Auditorium"]["Number"] + " (к."+str(lesson["Disciplines"][0]["Auditorium"]["CampusTitle"])+")"
			lesson_container.discipline_name = lesson["Disciplines"][0]["Title"]
			lesson_container.teacher = lesson["Disciplines"][0]["Teacher"]["UserName"]
			lesson_container.photo = await PhotoService.get_photo(lesson["Disciplines"][0]["Teacher"]["Photo"]["UrlSmall"])
			
			lessons.add_child(lesson_container)
	print(group_name, collapsible_container.size, get_parent().name, get_parent().size)

func _on_button_pressed() -> void:
	collapsible_container.open_tween_toggle()
