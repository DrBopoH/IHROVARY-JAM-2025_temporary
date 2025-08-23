extends Camera2D
class_name PCamera

export(Vector2) var minmax 

export var zoomfactor = 1
export var zoomspeed = 20
export var zoomstep = 0.03
export var factorstep = 0.01

func _process(delta):
	zoom.x = lerp(zoom.x, zoomfactor*zoom.x, zoomspeed*delta)
	zoom.y = lerp(zoom.y, zoomfactor*zoom.y, zoomspeed*delta)
	
	zoom.x = clamp(zoom.x, minmax.x, minmax.y)
	zoom.y = clamp(zoom.y, minmax.x, minmax.y)
	
	if zoomfactor > 1:
		zoomfactor -= factorstep
	elif zoomfactor < 1:
		zoomfactor += factorstep

func _input(event):
	if event is InputEventMouseButton:
		if event.button_index == BUTTON_WHEEL_UP:
			zoomfactor -= zoomstep
		elif event.button_index == BUTTON_WHEEL_DOWN:
			zoomfactor += zoomstep
