extends Control

@onready var disc_name_label: Label = %DiscNameLabel
@onready var groups: VBoxContainer = %Groups
@onready var days: HBoxContainer = %Days
@onready var month_label: Label = %MonthLabel

@onready var group_container_scene = preload("res://Scenes/UI Elements/group_container.tscn")

var data : Array
var cur_day : Button

var week_offset:int

func _ready() -> void:
	data = await TimetableService.get_time_table()
	#print(JSON.stringify(data, "\t"))
	parse_data()
	
	var daynum = TimetableService.get_weekday() # 1-6 пн-сб и 0 - вс
	month_label.text = TimetableService.get_month_name()
	cur_day = days.get_child(daynum - 1 if daynum != 0 else 6)
	cur_day.disabled = true
	var first_day_num = TimetableService.day() - daynum + 1
	for cur_day_num : int in range(7):
		var day : Button = days.get_child(cur_day_num)
		# получаем число
		var day_num = wrapi(first_day_num + cur_day_num, 1, TimetableService.get_days_in_month())
		#var day_num = (TimetableService.day() + cur_day_num - daynum + 1) % (TimetableService.get_days_in_month() + 1) + (TimetableService.day() + cur_day_num - daynum + 1) / (TimetableService.get_days_in_month() + 1)
		var month = TimetableService.month()
		if (first_day_num + cur_day_num) > TimetableService.get_days_in_month():
			month += 1
		elif first_day_num + cur_day_num < 1:
			month -= 1
		var year = TimetableService.year()
		if month < 1:
			month = 12
			year -= 1
		if month > 12:
			month = 1
			year += 1
			
		#print("day ", day_num, " month ", month)
		day.button_up.connect(
			func():
				if cur_day != null:
					cur_day.disabled = false
					cur_day = day
					cur_day.disabled = true
					if cur_day.has_meta("time"):
						var time = cur_day.get_meta("time") as String
						get_new_timetable(time)
						var cur_month = int(time.substr(5,2))
						if cur_month != TimetableService.month():
							month_label.text = TimetableService.get_month_name(cur_month)
				)
		day.set_meta("time", str(year)+"-"+str(month).pad_zeros(2)+"-"+str(day_num).pad_zeros(2))
		
		day.text = TimetableService.WEEKDAY_NAME[(cur_day_num+1)%7] + "\n" + str(day_num)# if daynum != 0 else TimetableService.day() 

func parse_data():
	for group in data:
		print(groups.size)
		var group_container = group_container_scene.instantiate()
		group_container.group_name = group["FacultyName"] + " (" + group["Group"] + " группа)"
		#print(group["TimeTable"]["Lessons"])
		group_container.lessons_data = group["TimeTable"]["Lessons"]
		groups.add_child(group_container)


func get_new_timetable(time : String) -> void:
	for child in groups.get_children():
		child.queue_free()
	data = await TimetableService.get_time_table(time)
	parse_data()


func _on_left_button_up() -> void:
	pass # Replace with function body.


func _on_right_button_up() -> void:
	pass # Replace with function body.
