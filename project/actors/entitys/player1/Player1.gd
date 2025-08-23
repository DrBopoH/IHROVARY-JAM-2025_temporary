extends KinematicBody2D

export var move_speed = 200.0  # Скорость плавного движения
export var flashlight_turn_speed = 5.0

# HP система
export var max_hp = 100
var current_hp = 100

# Pathfinding
var astral := AStar2D.new()
var level_size := 100
var paths: Dictionary
var current_path: Array = []
var target_position: Vector2
var is_moving = false
var path_index = 0

# Узлы
onready var flashlight = $Light2D
onready var arrow = get_parent().get_node("Arrow") 

func _ready():
	current_hp = max_hp
	setup_pathfinding()
	
	# Выравниваем игрока по сетке
	global_position = to_world(to_grid(global_position))
	target_position = global_position
	
	flashlight.offset = Vector2(0, 128)
	
	arrow.modulate.a = 0
	
func setup_pathfinding():
	var id = 0
	# Создаем точки для AStar
	for x in range(-level_size, level_size):
		for y in range(-level_size, level_size):
			var grid_pos = Vector2(x, y)
			astral.add_point(id, to_world(grid_pos))
			paths[grid_pos] = id
			id += 1
	
	# Соединяем соседние точки
	for x in range(-level_size, level_size):
		for y in range(-level_size, level_size):
			var cell = Vector2(x, y)
			var id1 = paths[cell]
			for dir in [Vector2(1,0), Vector2(-1,0), Vector2(0,1), Vector2(0,-1)]:
				var neighbor = cell + dir
				if paths.has(neighbor):
					var id2 = paths[neighbor]
					if not astral.are_points_connected(id1, id2):
						astral.connect_points(id1, id2)

func _input(event):
	if event is InputEventMouseButton and event.pressed:
		if event.button_index == BUTTON_LEFT:
			var current_grid = to_grid(global_position)
			var target_grid = to_grid(get_global_mouse_position())
			
			if current_grid != target_grid and paths.has(current_grid) and paths.has(target_grid):
				# Получаем путь через AStar
				current_path = astral.get_point_path(paths[current_grid], paths[target_grid])
				
				if current_path.size() > 1:
					# Убираем первую точку (текущую позицию)
					current_path.remove(0)
					path_index = 0
					target_position = current_path[0]
					is_moving = true
					
					arrow.modulate.a = 1
					arrow.position = to_world(target_grid)
					
					print("Движемся к: ", target_grid)

func _physics_process(delta):
	if is_moving:
		# Плавно движемся к следующей точке пути
		global_position = global_position.move_toward(target_position, move_speed * delta)
		
		# Проверяем достигли ли цель
		if global_position.distance_to(target_position) < 5:
			global_position = target_position
			path_index += 1
			
			# Есть ли еще точки в пути?
			if path_index < current_path.size():
				target_position = current_path[path_index]
			else:
				# Путь завершен
				is_moving = false
				current_path.clear()

func _process(delta):
	# Поворот фонарика за мышью (как раньше)
	var mouse_pos = get_global_mouse_position()
	var direction = (mouse_pos - global_position).normalized()
	var target_angle = direction.angle() - PI/2  # -90° чтобы основание смотрело на мышь
	
	flashlight.rotation = lerp_angle(flashlight.rotation, target_angle, flashlight_turn_speed * delta)
	
	if arrow.modulate.a > 0:
		arrow.modulate.a = lerp(arrow.modulate.a, 0, 1.0 - exp(-0.5 * delta))

func to_grid(pos: Vector2) -> Vector2:
	return Vector2(round(pos.x / 32), round(pos.y / 32))  # Предполагаю grid_size = 32

func to_world(grid_pos: Vector2) -> Vector2:
	return grid_pos * 32  # Предполагаю grid_size = 32

# HP система
func take_damage(damage):
	current_hp -= damage
	current_hp = max(0, current_hp)
	
	print("Получен урон: ", damage, " HP: ", current_hp, "/", max_hp)
	
	
	if current_hp <= 0:
		die()

func die():
	print("Игрок умер!")
	get_tree().reload_current_scene()
