extends Resource
class_name TokenData

@export var access_token:String
@export var refresh_token:String
@export var expires_in:int

var created_date : float

func init(_access_token : String, _refresh_token:String, _expires_in:int):
	access_token = _access_token
	refresh_token = _refresh_token
	expires_in = _expires_in
	created_date = Time.get_unix_time_from_system()

func is_expired():
	return (Time.get_unix_time_from_system() - created_date) > expires_in
