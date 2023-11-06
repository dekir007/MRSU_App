extends Node

signal token_recieved

var auth_http_request : HTTPRequest

func _ready() -> void:
	auth_http_request = HTTPRequest.new()
	Globals.init_http_request(self, auth_http_request, self._auth_http_request_completed)
	
func auth(username:String, password:String) -> void:
	if username == "" || password == "":
		push_error("EMPTY ACCOUNT CREDENTIALS")
		return
	var headers = ["Content-Type: application/x-www-form-urlencoded"]
	var error = auth_http_request.request("https://p.mrsu.ru/OAuth/Token",
		headers, 
		HTTPClient.METHOD_POST, 
		"grant_type=password&username="+username+"&password="+password+"&client_id=8&client_secret=qweasd")
	if error != OK:
		push_error("An error occurred in the HTTP request.")

func _auth_http_request_completed(_result, _response_code, _headers, body) -> void:
	var response = JSON.parse_string(body.get_string_from_utf8())
	
	Globals.token_data = TokenData.new()
	Globals.token_data.init(response["access_token"], response["refresh_token"],response["expires_in"])
	print(Globals.token_data)
	
	token_recieved.emit()
	var thread = Thread.new()
	thread.start(func(): Globals.save_token())
	#thread.wait_to_finish()

func refresh_token():
	var headers = ["Content-Type: application/x-www-form-urlencoded"]
	var error = auth_http_request.request("https://p.mrsu.ru/OAuth/Token",
		headers, 
		HTTPClient.METHOD_POST, 
		"grant_type=refresh_token&refresh_token="+Globals.token_data.refresh_token+"&client_id=8&client_secret=qweasd")
	if error != OK:
		push_error("An error occurred in the HTTP request.")
