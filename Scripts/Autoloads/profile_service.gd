extends Node

signal profile_recieved
signal photo_recieved

var profile_http_request : HTTPRequest
var photo_http_request : HTTPRequest

# for profile scene
var profile : Dictionary
var photo : ImageTexture

func _ready():
	profile_http_request = HTTPRequest.new()
	photo_http_request = HTTPRequest.new()
	Globals.init_http_request(self, profile_http_request, self._profile_http_request_completed)
	Globals.init_http_request(self, photo_http_request, self._photo_http_request_completed)

func get_profile():
	profile_http_request.request(Globals.base_url+"v1/User", 
		Globals.get_auth_header(), HTTPClient.METHOD_GET, "")
	
	await profile_recieved
	return profile

func get_photo():
	photo_http_request.request(profile["Photo"]["UrlSource"])
	
	await photo_recieved
	return photo

func _profile_http_request_completed(_result, _response_code, _headers, body : PackedByteArray) -> void:
	var response = JSON.parse_string(body.get_string_from_utf8())
	profile = response
	profile_recieved.emit()

func _photo_http_request_completed(result, _response_code, _headers, body : PackedByteArray) -> void:
	if result != HTTPRequest.RESULT_SUCCESS:
		push_error("Image couldn't be downloaded. Try a different image.")

	var image = Image.new()
	var error = image.load_png_from_buffer(body)
	if error != OK:
		push_error("Couldn't load the image.")

	photo = ImageTexture.create_from_image(image)
	photo_recieved.emit()
