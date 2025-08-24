extends Control

func _ready():
	Options.paused = false
	
	Options.current_hpbar = $LineBar
	$LineBar.resize(24, 1)
	$LineBar.set_pixelize()
	
	$LineBar.position = get_viewport().size*0.5
	$LineBar.position.y-= 64

func _process(delta):
	$LineBar.scale = Vector2(1, 1)/Options.current_camera.zoom
