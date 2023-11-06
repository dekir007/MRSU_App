extends Node

signal time_table_recieved

var time_table_http_request : HTTPRequest

# for time_table scene
var time_table : Array

func _ready():
	time_table_http_request = HTTPRequest.new()
	Globals.init_http_request(self, time_table_http_request, self._time_table_http_request_completed)

func get_time_table(date : String = Time.get_datetime_string_from_system().left(10)) -> Array:
	time_table_http_request.request(Globals.base_url + "v1/StudentTimeTable?date=" + date,
		Globals.get_auth_header(),
		HTTPClient.METHOD_GET)
	
	await time_table_recieved
	return time_table

func _time_table_http_request_completed(_result, _response_code, _headers, body) -> void:
	var response = JSON.parse_string(body.get_string_from_utf8())
	time_table = response
	time_table_recieved.emit()
