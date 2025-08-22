extends KinematicBody2D

export var speed = 100
export var detection_range = 200
var player = null
var velocity = Vector2()

func _ready():
	# Найдем игрока в сцене
	player = get_tree().get_nodes_in_group("player")[0]

func _physics_process(delta):
	if player:
		var distance = global_position.distance_to(player.global_position)
		
		if distance < detection_range:
			# Преследуем игрока
			chase_player(delta)
		else:
			# Останавливаемся
			velocity = Vector2()
	
	velocity = move_and_slide(velocity)

func chase_player(delta):
	# Направление к игроку
	var direction = (player.global_position - global_position).normalized()
	velocity = direction * speed
