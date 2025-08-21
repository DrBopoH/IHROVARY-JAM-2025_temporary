extends CanvasLayer
class_name debugUI


var COLOR_MATH = ColorMath.new() #GLOBALS

var _list = VBoxContainer.new() #NODES

var _variables: Dictionary = { #VARIABLES
	'cpuphysic_loadrate':[funcref(self, 'cpuphysicload_update'), '%', false],
	'gpuphysic_loadrate':[funcref(self, 'plug_update'), '%', false],
	'memory_usage':[funcref(self, 'memoryusage_update'), 'MB', false],
	'staticmemory_usage':[funcref(self, 'plug_update'), 'MB', false],
	'dynamicmemory_usage':[funcref(self, 'plug_update'), 'MB', false],
	'rendering_loadrate':[funcref(self, 'renderingload_update'), 'F/s', false],
}
var color_stages: Array = [Color(1, 0, 0), Color(1, 1, 0), Color(0, 1, 0)] 


func _ready() -> void: #INIT
	add_child(_list)

func modify_showing(varname: String, enabling: bool) -> void: #METHODS
	_variables[varname][-1] = enabling
	
	for child in _list.get_children():
		child.queue_free()
	for label in _variables:
		if _variables[label][-1]:
			_list.add_child(showvariableUI.new(label, _variables[label][0], _variables[label][1]))
	

func cpuphysicload_update() -> Dictionary: 
	var cpuphysic_loadpercent = Performance.get_monitor(Performance.TIME_PHYSICS_PROCESS)*Engine.iterations_per_second
	var data: Dictionary = {
		'value':str(cpuphysic_loadpercent*100).left(5),
		'modulate':COLOR_MATH.get_interpolated_color(color_stages, clamp(1 - cpuphysic_loadpercent, 0, 1))
	}
	return data

func memoryusage_update() -> Dictionary:
	var memory = float(OS.get_static_memory_usage()+OS.get_dynamic_memory_usage())*0.000001
	var memory_percent = clamp(1 - memory*0.002, 0, 1)
	
	var data: Dictionary = {
		'value':str(memory).left(6),
		'modulate':COLOR_MATH.get_interpolated_color(color_stages, memory_percent)
	}
	return data

func renderingload_update() -> Dictionary:
	var fps = Engine.get_frames_per_second()
	var fps_percent = clamp(fps*0.0083, 0, 1)
	
	var data: Dictionary = {
		'value':str(fps),
		'modulate':COLOR_MATH.get_interpolated_color(color_stages, fps_percent)
	}
	return data

func plug_update() -> Dictionary:
	return {'value':'--/--', 'modulate':Color(1, 1, 1)}
