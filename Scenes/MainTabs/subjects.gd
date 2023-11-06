extends Control

@onready var http_request: HTTPRequest = $HTTPRequest
@onready var faculties: VBoxContainer = %Faculties
@onready var title_label: Label = %TitleLabel

@onready var faculty_name_container = preload("res://Scenes/UI Elements/faculty_container.tscn")
@onready var discipline_container = preload("res://Scenes/UI Elements/discipline_container.tscn")

var redirect_target : Globals.RedirectTarget

func _ready() -> void:
	if !visible:
		return
	if Globals.token_data == null:
		return
	match redirect_target:
		Globals.RedirectTarget.Communication:
			title_label.text = "Communication"
		Globals.RedirectTarget.Discipline:
			title_label.text = "My Subjects"
	var _error = http_request.request(Globals.base_url+"v1/StudentSemester?selector=current", Globals.get_auth_header(), HTTPClient.METHOD_GET, "")

func _on_http_request_request_completed(_result: int, _response_code: int, _headers: PackedStringArray, body: PackedByteArray) -> void:
	var response = JSON.parse_string(body.get_string_from_utf8())
	for faculty in response["RecordBooks"]:
		print("\nfaculty: ", faculty["Faculty"] + "\n")
		var faculty_container := VBoxContainer.new()
		faculty_container.set("theme_override_constants/separation", 15)
		faculty_container.size_flags_vertical = Control.SIZE_SHRINK_BEGIN
		faculty_container.name = faculty["Faculty"]
		faculties.add_child(faculty_container)
		#faculties.move_child()
		
		var fac_name = faculty_name_container.instantiate()
		fac_name.faculty_name = faculty["Faculty"]
		faculty_container.add_child(fac_name)
		
		for discipline in faculty["Disciplines"]:
			print(discipline["Title"])
			var disc = discipline_container.instantiate()
			disc.discipline_name = discipline["Title"]
			disc.discipline_id = discipline["Id"]
			disc.redirect = redirect_target
			faculty_container.add_child(disc)

