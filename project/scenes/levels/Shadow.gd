extends KinematicBody2D

export var tile_size = 32  # Размер клетки тайлмапа
export var move_delay = 1.5  # Задержка между движениями
export var damage = 20

var player = null
var is_moving = false
var move_timer = 0.0
var target_position = Vector2()

func _ready():
	var players = get_tree().get_nodes_in_group("player")
	if players.size() > 0:
		player = players[0]
	
	# Выровняем позицию моба по сетке
	global_position = snap_to_grid(global_position)
	target_position = global_position

func _process(delta):
	if not player or not is_instance_valid(player):
		return
	
	# Обновляем таймер
	move_timer += delta
	
	# Если пора двигаться и не двигаемся сейчас
	if move_timer >= move_delay and not is_moving:
		try_move_towards_player()
		move_timer = 0.0
	
	# Плавно перемещаемся к целевой позиции
	if is_moving:
		global_position = global_position.move_toward(target_position, 200 * delta)
		
		# Проверяем достигли ли цель
		if global_position.distance_to(target_position) < 5:
			global_position = target_position
			is_moving = false
			
			# Проверяем касание с игроком
			check_attack()

func try_move_towards_player():
	var current_grid_pos = world_to_grid(global_position)
	var player_grid_pos = world_to_grid(player.global_position)
	
	# Вычисляем направление к игроку
	var direction = Vector2()
	
	if abs(player_grid_pos.x - current_grid_pos.x) > abs(player_grid_pos.y - current_grid_pos.y):
		# Движемся горизонтально
		direction.x = sign(player_grid_pos.x - current_grid_pos.x)
	else:
		# Движемся вертикально
		direction.y = sign(player_grid_pos.y - current_grid_pos.y)
	
	# Новая позиция
	var new_grid_pos = current_grid_pos + direction
	var new_world_pos = grid_to_world(new_grid_pos)
	
	# Проверяем коллизии (опционально)
	if can_move_to(new_world_pos):
		target_position = new_world_pos
		is_moving = true

func world_to_grid(world_pos):
	return Vector2(floor(world_pos.x / tile_size), floor(world_pos.y / tile_size))

func grid_to_world(grid_pos):
	return Vector2(grid_pos.x * tile_size + tile_size/2, grid_pos.y * tile_size + tile_size/2)

func snap_to_grid(pos):
	var grid_pos = world_to_grid(pos)
	return grid_to_world(grid_pos)

func can_move_to(world_pos):
	# Простая проверка - всегда можем двигаться
	# Можешь добавить проверку коллизий с тайлмапом
	return true

func check_attack():
	if player and global_position.distance_to(player.global_position) < tile_size:
		if player.has_method("take_damage"):
			player.take_damage(damage)
			print("Тень атаковала игрока!")
