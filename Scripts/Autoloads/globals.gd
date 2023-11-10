extends Node
enum RedirectFrom {
	Profile,
	Discipline,
	Communication,
	Timetable,
	Settings
}

var base_url : String = "https://papi.mrsu.ru/"
var token_data : TokenData :
	get:
		if token_data == null:
			push_error("NO AUTH TOKEN")
			# AuthService.auth(...)
			# await AuthService.token_recieved
		return token_data
var key : String = "gjlbweg;vwevilwvwe".sha256_text()

# used for communication and discipline_rating
var current_disc_name:String
var current_disc_id:int

var redirect_from : RedirectFrom = RedirectFrom.Profile

func _ready() -> void:
	pass

func get_token_from_disk(path:String = "user://token.data") -> Error:
	#if ResourceLoader.exists(path):
	var f : FileAccess =  FileAccess.open_encrypted_with_pass(path, FileAccess.READ, key)
	if f != null:
		var a = JSON.parse_string(f.get_as_text())
		#print(a)
		token_data = TokenData.from_dict(a)
		if token_data.is_expired():
			AuthService.refresh_token()
			await AuthService.token_recieved
		return OK
	else:
		push_error("NO FILE")
		return FAILED

func save_token(path:String = "user://token.data"):
	var f : FileAccess =  FileAccess.open_encrypted_with_pass(path, FileAccess.WRITE, key)
	var saved = JSON.stringify(token_data.to_dict())
	#print(ResourceSaver.save(token_data, "user://test.data"))
	f.store_string(saved)
	print("saved :" + saved)

func init_http_request(parent : Node, http_request: HTTPRequest, callback : Callable) -> void:
	http_request.download_chunk_size = 4096
	http_request.use_threads = true
	parent.add_child(http_request)
	http_request.request_completed.connect(callback)

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
