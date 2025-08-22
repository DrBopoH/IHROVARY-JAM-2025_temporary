extends KinematicBody2D


var velocity = Vector2()
var speed = 200
var axis_lock = true

export var flashlight_turn_speed = 5.0
onready var flashlight = $Light2D


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
	
func _ready():
	# Смещаем точку поворота фонарика
	# Если текстура 256x256, то сдвигаем на половину высоты вниз
	flashlight.offset = Vector2(0, 128)  # Для текстуры 256x256
	# Или для другого размера: Vector2(0, высота_текстуры / 2)

func _process(delta):
	# Направление к мыши
	var mouse_pos = get_global_mouse_position()
	var direction = (mouse_pos - global_position).normalized()
	var target_angle = direction.angle() - PI/2  # -90° чтобы основание смотрело на мышь
	
	# Плавный поворот
	flashlight.rotation = lerp_angle(flashlight.rotation, target_angle, flashlight_turn_speed * delta)
