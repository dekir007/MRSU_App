extends Node

signal time_table_recieved

var time_table_http_request : HTTPRequest

# for time_table scene
var time_table : Array

func _ready():
	time_table_http_request = HTTPRequest.new()
	Globals.init_http_request(self, time_table_http_request, self._time_table_http_request_completed)

func get_time_table(date : String = Time.get_datetime_string_from_system().left(10)) -> Array:
	# TODO
	time_table_http_request.cancel_request()
	
	time_table_http_request.request(Globals.base_url + "v1/StudentTimeTable?date=" + date,
		Globals.get_auth_header(),
		HTTPClient.METHOD_GET)
	
	await time_table_recieved
	return time_table

func _time_table_http_request_completed(result, response_code, _headers, body) -> void:
	if result != 0 or response_code != 200: 
		return
	var response = JSON.parse_string(body.get_string_from_utf8())
	time_table = response
	time_table_recieved.emit()

enum Month { JAN = 1, FEB = 2, MAR = 3, APR = 4, MAY = 5, JUN = 6, JUL = 7,
		AUG = 8, SEP = 9, OCT = 10, NOV = 11, DEC = 12 }

const MONTH_NAME = [ 
		"Январь", "Февраль", "Март", "Апрель", 
		"Май", "Июнь", "Июль", "Август", 
		"Сентябрь", "Октябрь", "Ноябрь", "Декабрь" ]

const WEEKDAY_NAME = [ 
		"ВС", "ПН", "ВТ", "СР", 
		"ЧТ", "ПТ", "СБ" ]

#const WEEKDAY_NAME_ENG = [ 
#		"Su", "Mo", "Tu", "We", 
#		"Th", "Fr", "Sa" ]

func get_days_in_month(month : int = month(), year : int = year()) -> int:
	var number_of_days : int
	if(month == Month.APR || month == Month.JUN || month == Month.SEP
			|| month == Month.NOV):
		number_of_days = 30
	elif(month == Month.FEB):
		var is_leap_year = (year % 4 == 0 && year % 100 != 0) || (year % 400 == 0)
		if(is_leap_year):
			number_of_days = 29
		else:
			number_of_days = 28
	else:
		number_of_days = 31
	
	return number_of_days

func get_weekday(day : int = day(), month : int = month(), year : int = year()) -> int:
	var t : Array = [0, 3, 2, 5, 0, 3, 5, 1, 4, 6, 2, 4]
	if(month < 3):
		year -= 1
	return (year + year/4 - year/100 + year/400 + t[month - 1] + day) % 7

func get_weekday_name(day : int = day(), month : int = month(), year : int = year()) -> String:
	var day_num = get_weekday(day, month, year)
	return WEEKDAY_NAME[day_num]

func hour() -> int:
	return Time.get_datetime_dict_from_system()["hour"]

func minute() -> int:
	return Time.get_datetime_dict_from_system()["minute"]

func second() -> int:
	return Time.get_datetime_dict_from_system()["second"]

func day() -> int:
	return Time.get_datetime_dict_from_system()["day"]

func weekday() -> int:
	return Time.get_datetime_dict_from_system()["weekday"]

func month() -> int:
	return Time.get_datetime_dict_from_system()["month"]

func year() -> int:
	return Time.get_datetime_dict_from_system()["year"]
	
func get_month_name(month : int = month()) -> String:
	return MONTH_NAME[month - 1]
