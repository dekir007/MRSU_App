extends Node
enum RedirectTarget {
	Discipline,
	Communication
}

signal discipline_rating_recieved
signal time_table_recieved

var base_url : String = "https://papi.mrsu.ru/"
var token_data : TokenData :
	get:
		if token_data == null:
			push_error("NO AUTH TOKEN")
			# AuthService.auth(...)
			# await AuthService.token_recieved
		return token_data
var key : String = "gjlbweg;vwevilwvwe".sha256_text()


#var auth_http_request : HTTPRequest
var discipline_rating_http_request : HTTPRequest
var time_table_http_request : HTTPRequest

# used for communication and discipline_rating
var current_disc_name:String
var current_disc_id:int

# for discipline_rating scene
var discipline_rating : Dictionary

# for time_table scene
var time_table : Array

func _ready() -> void:
	discipline_rating_http_request = HTTPRequest.new()
	init_http_request(self, discipline_rating_http_request, self._discipline_rating_http_request_completed)
	time_table_http_request = HTTPRequest.new()
	init_http_request(self, time_table_http_request, self._time_table_http_request_completed)

func get_token_from_disk(path:String = "user://token.data") -> Error:
	#if ResourceLoader.exists(path):
	var f : FileAccess =  FileAccess.open_encrypted_with_pass(path, FileAccess.READ, key)
	if f != null:
		var a = JSON.parse_string(f.get_as_text())
		print(a)
		token_data = a
		if token_data.is_expired():
			AuthService.refresh_token()
			await AuthService.token_recieved
		return OK
	else:
		push_error("NO FILE")
		return FAILED

func save_token(path:String = "user://token.data"):
	var f : FileAccess =  FileAccess.open_encrypted_with_pass(path, FileAccess.WRITE, key)
	var saved = JSON.stringify(token_data)
	f.store_string(saved)
	print("saved :" + saved)

func init_http_request(parent : Node, http_request: HTTPRequest, callback : Callable) -> void:
	http_request.download_chunk_size = 4096
	http_request.use_threads = true
	parent.add_child(http_request)
	http_request.request_completed.connect(callback)

func get_time_table(date : String = Time.get_datetime_string_from_system().left(10)) -> Array:
	time_table_http_request.request(base_url + "v1/StudentTimeTable?date=" + date,
		Globals.get_auth_header(),
		HTTPClient.METHOD_GET)
	
	await time_table_recieved
	return time_table

func _time_table_http_request_completed(_result, _response_code, _headers, body) -> void:
	var response = JSON.parse_string(body.get_string_from_utf8())
	time_table = response
	time_table_recieved.emit()

var hh_mm_regex : RegEx

func get_hh_mm_from_date(date : String) -> String:
	if hh_mm_regex == null:
		hh_mm_regex = RegEx.new()
		hh_mm_regex.compile("\\d{2}:\\d{2}")
	var res = hh_mm_regex.search(date)
	return res.get_string()

func get_yy_mm_dd_from_date(date : String) -> String:
	var res = date.left(10).split("-")
	return res[2]+'.'+res[1]+'.'+res[0]

func get_auth_header():
	return ["Authorization: Bearer " + Globals.token_data.access_token]
	
func get_discipline_rating(discipline_id : int = current_disc_id) -> Dictionary:
	discipline_rating_http_request.request(base_url + "v2/StudentRatingPlan/" + str(discipline_id),
		Globals.get_auth_header(),
		HTTPClient.METHOD_GET)
	
	await discipline_rating_recieved
	return discipline_rating

func _discipline_rating_http_request_completed(_result, _response_code, _headers, body) -> void:
	var response = JSON.parse_string(body.get_string_from_utf8())
	discipline_rating = response
	discipline_rating_recieved.emit()
