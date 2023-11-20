extends Node

signal photo_recieved

var png_http_request : HTTPRequest
var jpg_http_request : HTTPRequest

var photo : ImageTexture

func _ready():
	png_http_request = HTTPRequest.new()
	jpg_http_request = HTTPRequest.new()
	Globals.init_http_request(self, png_http_request, self._png_http_request_completed)
	Globals.init_http_request(self, jpg_http_request, self._jpg_http_request_completed)

func get_photo(url : String):
	if url.right(3) == "png":
		if png_http_request.get_http_client_status() > 0:
			await png_http_request.request_completed
		png_http_request.request(url)
	elif url.right(3) == "jpg":
		if jpg_http_request.get_http_client_status() > 0:
			await jpg_http_request.request_completed
		jpg_http_request.request(url)
	else:
		push_error("NOT SUPPORTED IMAGE EXTENSION")
	await photo_recieved
	return photo

func _png_http_request_completed(result, _response_code, _headers, body : PackedByteArray) -> void:
	if result != HTTPRequest.RESULT_SUCCESS:
		push_error("Image couldn't be downloaded. Try a different image.")

	var image = Image.new()
	var error = image.load_png_from_buffer(body)
	if error != OK:
		push_error("Couldn't load the image.")

	photo = ImageTexture.create_from_image(image)
	photo_recieved.emit()
	
func _jpg_http_request_completed(result, _response_code, _headers, body : PackedByteArray) -> void:
	if result != HTTPRequest.RESULT_SUCCESS:
		push_error("Image couldn't be downloaded. Try a different image.")

	var image = Image.new()
	var error = image.load_jpg_from_buffer(body)
	if error != OK:
		push_error("Couldn't load the image.")
	#image.crop(image.get_width(), image.get_width())
	photo = ImageTexture.create_from_image(image)
	photo_recieved.emit()
