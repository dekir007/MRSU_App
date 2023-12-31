extends Control

func _ready() -> void:
	print(wrapi(10,1,10))
	#for i in range(9):
		#var date = Date.new(1 + i, 1, 2024)
		#check_date_prev(date)
	
	if await Globals.get_token_from_disk() == OK:
		get_tree().call_deferred("change_scene_to_file", "res://Scenes/main.tscn")
	else:
		get_tree().call_deferred("change_scene_to_file", "res://Scenes/login.tscn")

func check_date_next(date:Date):
	print(date.day, " ", date.month, " ", date.year)
	date.change_to_next_week()
	print(date.day, " ", date.month,  " ",date.year, '\n')
func check_date_prev(date:Date):
	print(date.day, " ", date.month, " ", date.year)
	date.change_to_prev_week()
	print(date.day, " ", date.month,  " ",date.year, '\n')
