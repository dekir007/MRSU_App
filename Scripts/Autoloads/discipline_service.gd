extends Node

signal discipline_rating_recieved

var discipline_rating_http_request : HTTPRequest

# for discipline_rating scene
var discipline_rating : Dictionary

func _ready():
	discipline_rating_http_request = HTTPRequest.new()
	Globals.init_http_request(self, discipline_rating_http_request, self._discipline_rating_http_request_completed)

func get_discipline_rating(discipline_id : int = Globals.current_disc_id) -> Dictionary:
	discipline_rating_http_request.request(Globals.base_url + "v2/StudentRatingPlan/" + str(discipline_id),
		Globals.get_auth_header(),
		HTTPClient.METHOD_GET)
	
	await discipline_rating_recieved
	return discipline_rating

func _discipline_rating_http_request_completed(_result, _response_code, _headers, body) -> void:
	var response = JSON.parse_string(body.get_string_from_utf8())
	discipline_rating = response
	discipline_rating_recieved.emit()
