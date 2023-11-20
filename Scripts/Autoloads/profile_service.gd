extends Node

signal profile_recieved

var profile_http_request : HTTPRequest

# for profile scene
var profile : Dictionary

func _ready():
	profile_http_request = HTTPRequest.new()
	Globals.init_http_request(self, profile_http_request, self._profile_http_request_completed)

func get_profile():
	profile_http_request.request(Globals.base_url+"v1/User", 
		Globals.get_auth_header(), HTTPClient.METHOD_GET, "")
	
	await profile_recieved
	return profile


func _profile_http_request_completed(_result, _response_code, _headers, body : PackedByteArray) -> void:
	var response = JSON.parse_string(body.get_string_from_utf8())
	profile = response
	profile_recieved.emit()
