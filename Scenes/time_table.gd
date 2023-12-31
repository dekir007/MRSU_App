extends Control

@onready var disc_name_label: Label = %DiscNameLabel
@onready var groups: VBoxContainer = %Groups
@onready var days: HBoxContainer = %Days
@onready var month_label: Label = %MonthLabel

#@onready var group_container_scene = preload("res://Scenes/UI Elements/group_container.tscn")
@onready var group_container_scene = preload("res://Scenes/UI Elements/group_container_no_collapsible.tscn")

var data : Array
var cur_day_btn : Button

var date : Date

func _ready() -> void:
	date = Date.new()
	data = await TimetableService.get_time_table()
	#print(JSON.stringify(data, "\t"))
	parse_data()
	
	update_buttons(true)
	
func parse_data():
	for group in data:
		var group_container = group_container_scene.instantiate()
		group_container.group_name = group["FacultyName"] + " (" + group["Group"] + " группа)"
		#print(group["TimeTable"]["Lessons"])
		group_container.lessons_data = group["TimeTable"]["Lessons"]
		groups.add_child(group_container)

func update_buttons(connect:bool = false):
	var daynum = TimetableService.get_weekday(date.day, date.month, date.year) # 1-6 пн-сб и 0 - вс
	if daynum == 0:
		daynum = 7
	var date1 = date.duplicate()
	date1.shift_back(daynum-1) # first_day
	print(date1)
	
	
	month_label.text = TimetableService.get_month_name(date.month)
	cur_day_btn = days.get_child(daynum - 1) #if daynum != 0 else 6)
	cur_day_btn.disabled = true
	var first_day_num = date.day - daynum + 1
	if first_day_num < 0: # костыли мои любимые, как и весь этот кусок кода безбожный
		first_day_num -= 1 
	var i = 0
	for day_date : Date in date1.get_week():
		var day_btn : Button = days.get_child(i)
		
		if connect:
			day_btn.button_up.connect(
				func():
					if cur_day_btn != null:
						cur_day_btn.disabled = false
						cur_day_btn = day_btn
						cur_day_btn.disabled = true
						if cur_day_btn.has_meta("date"):
							var cur_date = cur_day_btn.get_meta("date") as Date
							
							get_new_timetable(cur_date.to_yy_mm_dd())
							
							if cur_date.month != date.month:
								month_label.text = TimetableService.get_month_name(cur_date.month)
							date = cur_date.duplicate()
							print("cur_date: ", date.day, " ", date.month, " ", date.year)
					)
		
		day_btn.set_meta("date", day_date )#str(year)+"-"+str(month).pad_zeros(2)+"-"+str(day_num).pad_zeros(2))
		
		day_btn.text = TimetableService.WEEKDAY_NAME[(i+1)%7] + "\n" + str(day_date.day)# if daynum != 0 else TimetableService.day() 
		
		i += 1

func get_new_timetable(time : String) -> void:
	for child in groups.get_children():
		child.queue_free()
	data = await TimetableService.get_time_table(time)
	parse_data()


func _on_left_button_up() -> void:
	date.change_to_prev_week()
	cur_day_btn.disabled = false
	update_buttons()
	cur_day_btn.button_up.emit()


func _on_right_button_up() -> void:
	date.change_to_next_week()
	cur_day_btn.disabled = false
	update_buttons()
	cur_day_btn.button_up.emit()
