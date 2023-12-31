extends RefCounted
class_name Date

@export var day : int
@export var month : int
@export var year : int

func _init(day : int = Time.get_datetime_dict_from_system()["day"], 
		month : int = Time.get_datetime_dict_from_system()["month"], 
		year : int = Time.get_datetime_dict_from_system()["year"]):
	self.day = day
	self.month = month
	self.year = year

func change_to_next_week():
	shift_forward(7)

func change_to_prev_week():
	shift_back(7)

func shift_back(shift : int):
	day -= shift
	if day < 1:
		month -= 1
		if month < 1:
			month = 12
			year -= 1
		if day == 0:
			day = TimetableService.get_days_in_month(month, year)
		else:
			day = wrapi(day+1, 1, TimetableService.get_days_in_month(month, year))

func shift_forward(shift : int):
	day += shift
	if day > TimetableService.get_days_in_month(month, year):
		day = wrapi(day, 1, TimetableService.get_days_in_month(month, year)+1)
		month += 1
		if month > 12:
			month = 1
			year += 1

func change_to_next_day():
	shift_forward(1)

func change_to_prev_day():
	shift_back(1)

func get_first_day_in_week() -> Date:
	var daynum = TimetableService.get_weekday(day, month, year) # 1-6 пн-сб и 0 - вс
	if daynum == 0:
		daynum = 7
	var date1 = duplicate()
	date1.shift_back(daynum-1) # first_day
	return date1

func get_week() -> Array[Date]:
	var week : Array[Date] = []
	for i in range(7):
		var date1 = duplicate() as Date
		date1.shift_forward(i)
		week.append(date1)
	return week

func to_yy_mm_dd():
	return str(year)+"-"+str(month).pad_zeros(2)+"-"+str(day).pad_zeros(2)

func duplicate() -> Date:
	return Date.new(day, month, year)

func _to_string() -> String:
	return to_yy_mm_dd()
