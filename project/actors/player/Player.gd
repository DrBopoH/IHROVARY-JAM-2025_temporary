extends KinematicBody2D


var velocity = Vector2()
var speed = 200

var axis_lock = true


func _physics_process(delta):

	if Input.is_action_pressed("ui_up"): 
		velocity.y = (-1)*speed

		axis_lock = true
	elif Input.is_action_pressed("ui_left"):
		velocity.x = (-1)*speed

		axis_lock = false
	elif Input.is_action_pressed("ui_down"):
		velocity.y = speed

		axis_lock = true
	elif Input.is_action_pressed("ui_right"):
		velocity.x = speed

		axis_lock = false
	else:
		velocity = Vector2()
		
	if axis_lock:
		velocity.x = 0
	else:
		velocity.y = 0
	
	move_and_slide(velocity)
	

