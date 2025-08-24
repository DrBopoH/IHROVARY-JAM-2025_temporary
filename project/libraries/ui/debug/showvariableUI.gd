extends Label
class_name showvariableUI


var _varname: String #VARIABLES
var _get_data: FuncRef 
var _value_type: String


func _init(varname: String, get_data: FuncRef, value_type) -> void: #INIT
	add_font_override("font", Options.pixel_font)
	
	_varname = varname
	_get_data = get_data
	_value_type = value_type
	
	name = varname

func _process(delta) -> void: #UPDATING
	var data: Dictionary = _get_data.call_func()
	text = _varname+": "+data['value']+_value_type
	modulate = data['modulate']
