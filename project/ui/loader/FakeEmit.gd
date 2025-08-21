extends Control

var tic: int = 0

func _physics_process(delta):
	tic+= 1
	
	if tic/Engine.iterations_per_second == Options.loader_time:
		$Fake.emit_signal("pressed")
