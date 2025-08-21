extends Control

func _physics_process(delta):
	$debugUI.modify_showing('cpuphysic_loadrate', Options.debug)
	$debugUI.modify_showing('memory_usage', Options.debug)
	$debugUI.modify_showing('rendering_loadrate', Options.debug)
