extends Resource
class_name TokenData

@export var access_token:String
@export var refresh_token:String
@export var expires_in:int

var created_date : float

func init(_access_token : String, 
		_refresh_token:String, 
		_expires_in:int,
		_create_data = Time.get_unix_time_from_system()):
	access_token = _access_token
	refresh_token = _refresh_token
	expires_in = _expires_in
	created_date = _create_data

func is_expired():
	return (Time.get_unix_time_from_system() - created_date) > expires_in

static func from_dict(dict : Dictionary) -> TokenData:
	var tok = TokenData.new()
	tok.init(dict["access_token"],
		dict["refresh_token"],
		dict["expires_in"],
		dict["created_date"])
	return tok

func to_dict():
	return {
		"access_token" : access_token,
		"refresh_token" : refresh_token,
		"expires_in" : expires_in,
		"created_date" : created_date
	}
