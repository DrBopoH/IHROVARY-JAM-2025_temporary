extends Control

func _ready():
	rect_position.y = get_viewport().size.y * 0.3
	get_viewport().connect("size_changed", self, "_on_viewport_size_changed")

func _physics_process(delta):
	$debugUI.modify_showing('cpuphysic_loadrate', Options.debug)
	$debugUI.modify_showing('memory_usage', Options.debug)
	$debugUI.modify_showing('rendering_loadrate', Options.debug)

func _on_viewport_size_changed():
	rect_position.y = get_viewport().size.y * 0.3
