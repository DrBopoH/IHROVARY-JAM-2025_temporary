extends KinematicBody2D

export var speed = 50
export var detection_range = 200
export var damage = 20  # Урон который наносит моб
export var attack_cooldown = 1.0  # Как часто может атаковать

var player = null
var velocity = Vector2()
var can_attack = true

func _ready():
	var players = get_tree().get_nodes_in_group("player")
	if players.size() > 0:
		player = players[0]

func _physics_process(delta):
	if player:
		var distance = global_position.distance_to(player.global_position)
		
		if distance < detection_range:
			chase_player(delta)
			
			# Проверяем касание с игроком
			if distance < 32 and can_attack:  # 32 - дистанция касания
				attack_player()
		else:
			velocity = Vector2()
	
	velocity = move_and_slide(velocity)

func chase_player(delta):
	var direction = (player.global_position - global_position).normalized()
	velocity = direction * speed

func attack_player():
	if player.has_method("take_damage"):
		player.take_damage(damage)
		can_attack = false

		# Запусаем кулдаун атаки
		yield(get_tree().create_timer(attack_cooldown), "timeout")
		can_attack = true
