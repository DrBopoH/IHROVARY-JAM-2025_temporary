extends KinematicBody2D


var velocity = Vector2()
var speed = 200
var axis_lock = true

export var flashlight_turn_speed = 5.0
onready var flashlight = $Light2D

var hp_bar = LineBar.new()
var current_hp = 100
var max_hp = 100



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
	
func die():
	print("Игрок умер!")
	get_tree().reload_current_scene()
	
func _ready():
	
	hp_bar.resize(50, 8)
	hp_bar.set_pixelize()
	add_child(hp_bar)
	hp_bar.offset.y = -16
	# Смещаем точку поворота фонарика
	# Если текстура 256x256, то сдвигаем на половину высоты вниз
	flashlight.offset = Vector2(0, 128)  # Для текстуры 256x256
	# Или для другого размера: Vector2(0, высота_текстуры / 2)

func _process(delta):
	# Направление к мыши
	var hp = float(current_hp)/float(max_hp)
	hp_bar.progress(hp)
	
	var mouse_pos = get_global_mouse_position()
	var direction = (mouse_pos - global_position).normalized()
	var target_angle = direction.angle() - PI/2  # -90° чтобы основание смотрело на мышь
	
	flashlight.rotation = lerp_angle(flashlight.rotation, target_angle, flashlight_turn_speed * delta)
	
func take_damage(damage):
	current_hp -= damage
	print("Получен урон: ", damage, " HP осталось: ", current_hp)
	
	if current_hp <= 0:
		die()
