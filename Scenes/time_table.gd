extends Control

@onready var time_table_v_box: VBoxContainer = %TimeTableVBox
@onready var disc_name_label: Label = %DiscNameLabel
@onready var items: VBoxContainer = %Items

var data : Array

func _ready() -> void:
	data = await TimetableService.get_time_table()
	#print(JSON.stringify(data, "\t"))
	parse_data()
	

func parse_data():
	for group in data:
		pass


func _on_button_pressed() -> void:
	data = await Globals.get_time_table($Vbox/ScrollContainer/Items/Calendar/LineEdit.text)
	parse_data()
