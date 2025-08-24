extends Control

func _ready():
	Options.paused = false
	
	Options.current_hpbar = $LineBar
	$LineBar.resize(24, 1)
	$LineBar.set_pixelize()
	$LineBar.position = get_viewport().size*0.5
	$LineBar.position.y-= 64
	
	Options.step_timebar = $Time
	$Time.resize(int(get_viewport().size.x*0.8), 7)
	$Time.set_pixelize()
	$Time.position.x = get_viewport().size.x*0.5
	$Time.position.y = 40
	
	$Pause.rect_position.x = get_viewport().size.x*0.01
	
	Options.AM = $AM
	$AM.rect_position.x = get_viewport().size.x - $AM.rect_size.x*2.1
	
	Options.steps = $Steps

func _process(delta):
	$LineBar.scale = Vector2(1, 1)/Options.current_camera.zoom
