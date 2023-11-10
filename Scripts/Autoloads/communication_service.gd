extends Node

signal communication_recieved

var communication_http_request : HTTPRequest

# for communication scene
var communication : Array

func _ready():
	communication_http_request = HTTPRequest.new()
	Globals.init_http_request(self, communication_http_request, self._communication_http_request_completed)

func get_communication(disc_id : int = Globals.current_disc_id) -> Array:
	communication_http_request.request(Globals.base_url+"v1/ForumMessage?disciplineId="+str(disc_id),
						 Globals.get_auth_header(),
						 HTTPClient.METHOD_GET)
	
	await communication_recieved
	return communication

func _communication_http_request_completed(result, response_code, _headers, body) -> void:
	if result != HTTPRequest.RESULT_SUCCESS:
		return
	if response_code == 401:
		return
	var response = JSON.parse_string(body.get_string_from_utf8())
	response.reverse()
	communication = response
	communication_recieved.emit()
