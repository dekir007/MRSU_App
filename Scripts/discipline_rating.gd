extends Control

@onready var disc_name_label: Label = %DiscNameLabel
@onready var items: VBoxContainer = %Items

@onready var section_container = preload("res://Scenes/UI Elements/section_container.tscn")

var data : Dictionary

func _ready() -> void:
	disc_name_label.text = Globals.current_disc_name
	
	data = await Globals.get_discipline_rating()
	
	parse_data()

func parse_data():
	for section in data["Sections"]:
		var sectionContainer = section_container.instantiate()
		sectionContainer.sectionName = section["Title"].strip_escapes() if section["Title"] != null else "Не указан"
		items.add_child(sectionContainer)
		
		for control_dot in section["ControlDots"]:
			var details : Array[String] = []
			details.append("[b]Срок сдачи:[/b] "+(Globals.get_yy_mm_dd_from_date(control_dot["Date"]) if control_dot["Date"] != null else "Не указан"))
			details.append("[b]Балл:[/b] "+(("%.1f" % control_dot["Mark"]["Ball"]) if control_dot["Mark"] != null else "0.0") + (" / %.1f" % control_dot["MaxBall"] if control_dot["MaxBall"]!= null else "/0.0"))
			
			if control_dot["Report"] != null:
				details.append("[b]Дата добавления отчёта:[/b] "+Globals.get_yy_mm_dd_from_date(control_dot["Report"]["CreateDate"]))
				details.append("[b]Отчёт:[/b] "+"[url="+control_dot["Report"]["DocFile"]["URL"] + "]Скачать файл[/url]")
				
			sectionContainer.add_new_control_point(control_dot["Title"], details)
		

func _on_return_btn_pressed() -> void:
	get_tree().change_scene_to_file("res://Scenes/main.tscn")
