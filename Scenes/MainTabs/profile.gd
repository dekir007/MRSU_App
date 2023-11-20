extends Control

@onready var photo: TextureRect = %Photo
@onready var fio_label: Label = %FIO_Label
@onready var id_label: Label = %IdLabel

func _ready() -> void:
	var response = await ProfileService.get_profile()
	
	var fio : String = response["FIO"]
	fio_label.text = fio.insert(fio.find(" "), "\n")
	
	id_label.text = "ID: " + response["StudentCod"] 
	
	photo.texture = await PhotoService.get_photo(response["Photo"]["UrlSource"])
