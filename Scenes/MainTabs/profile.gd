extends Control

@onready var photo: TextureRect = %Photo
@onready var fio_label: Label = %FIO_Label
@onready var id_label: Label = %IdLabel

@onready var http_request: HTTPRequest = $HTTPRequest
@onready var get_photo: HTTPRequest = $GetPhoto

func _ready() -> void:
	if !visible:
		return
	http_request.request_completed.connect(self._http_request_completed)
	# for tests
	if Globals.token_data == null:
		return
	var _error = http_request.request(Globals.base_url+"v1/User", Globals.get_auth_header(), HTTPClient.METHOD_GET, "")


func _http_request_completed(_result, _response_code, _headers, body : PackedByteArray) -> void:
	var response = JSON.parse_string(body.get_string_from_utf8())
	var fio : String = response["FIO"]
	fio_label.text = fio.insert(fio.find(" "), "\n")
	
	id_label.text = "ID: " + response["StudentCod"] 
	
	get_photo.request(response["Photo"]["UrlSource"])
	return

func _on_get_photo_request_completed(result: int, _response_code: int, _headers: PackedStringArray, body: PackedByteArray) -> void:
	if result != HTTPRequest.RESULT_SUCCESS:
		push_error("Image couldn't be downloaded. Try a different image.")

	var image = Image.new()
	var error = image.load_png_from_buffer(body)
	if error != OK:
		push_error("Couldn't load the image.")

	var texture = ImageTexture.create_from_image(image)
	photo.texture = texture
